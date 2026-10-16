import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../booking/booking_screen.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';

/// The number on the bell (P05 → P25, v2.32). Loaded once, then kept up to date by the live
/// socket's `notification.new` (session controller) and set to 0 when the inbox is opened.
class UnreadCountController extends AsyncNotifier<int> {
  @override
  Future<int> build() async => (await ref.watch(patientApiProvider).patientNotificationsUnread()).data!.unread;

  /// From the socket: the server's count after the new message.
  void set(int unread) => state = AsyncData(unread);

  /// After a reconnect (a message may have been missed meanwhile).
  void reload() => ref.invalidateSelf();
}

final unreadCountProvider = AsyncNotifierProvider<UnreadCountController, int>(UnreadCountController.new);

/// One page after another of the family's inbox, newest first.
class Inbox {
  const Inbox(this.items, {required this.total, this.loadingMore = false});

  final List<NotificationOut> items;
  final int total;
  final bool loadingMore;

  bool get hasMore => items.length < total;
}

/// The inbox (P25): the server keeps the last 30 days, at most the newest 50 (v2.33). Every
/// page shown is marked read, by its own ids only, so a message that
/// arrives meanwhile stays new (review, 16 Oct 2026); the unread dots stay on this visit so the
/// family sees what was new. A failed "mark read" never hides the list.
class InboxController extends AsyncNotifier<Inbox> {
  static const pageSize = 30;
  int _page = 1;

  @override
  Future<Inbox> build() async {
    _page = 1;
    final first = await _load(1);
    return Inbox(first.items.toList(), total: first.count);
  }

  Future<PagedNotificationOut> _load(int number) async {
    // read before any await: the screen may close meanwhile
    final api = ref.read(patientApiProvider);
    final bell = ref.read(unreadCountProvider.notifier);
    final page = (await api.patientNotificationsList(page: number, pageSize: pageSize)).data!;
    final unread = [
      for (final n in page.items)
        if (n.readAt == null) n.id,
    ];
    if (unread.isNotEmpty) {
      try {
        bell.set((await api.patientNotificationsRead(markReadIn: MarkReadIn(ids: unread))).data!.unread);
      } catch (_) {
        // the list still shows; the bell keeps its number until the next message or reconnect
      }
    }
    return page;
  }

  /// "Show older".
  Future<void> loadMore() async {
    final now = state.value;
    if (now == null || !now.hasMore || now.loadingMore) return;
    state = AsyncData(Inbox(now.items, total: now.total, loadingMore: true));
    try {
      final next = await _load(_page + 1);
      if (!ref.mounted) return;
      _page++;
      final seen = {for (final n in now.items) n.id};
      state = AsyncData(Inbox([...now.items, ...next.items.where((n) => !seen.contains(n.id))], total: next.count));
    } catch (_) {
      if (ref.mounted) state = AsyncData(Inbox(now.items, total: now.total));
    }
  }
}

final notificationsProvider = AsyncNotifierProvider.autoDispose<InboxController, Inbox>(InboxController.new);

/// P25 Notifications: booking confirmed, partner assigned, reminders, on the way, completed,
/// cancelled / refunded, WellWish's replies. A message about a booking opens it.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const path = '/notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final items = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: SafeArea(
        child: items.when(
          loading: () => const WWLoading(),
          error: (e, _) => WWErrorState(
            message: patientErrorMessage(l10n, e),
            retryLabel: l10n.tryAgain,
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
          data: (inbox) => RefreshIndicator(
            onRefresh: () => ref.refresh(notificationsProvider.future),
            child: inbox.items.isEmpty
                ? ListView(
                    // scrollable, so pull-to-refresh works on an empty inbox too
                    children: [
                      const SizedBox(height: 120),
                      WWEmptyState(icon: Icons.notifications_none, title: l10n.noNotifications),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(WWSpacing.screen),
                    itemCount: inbox.items.length + 1, // + "Load more" or the 30-day note
                    separatorBuilder: (_, _) => const SizedBox(height: WWSpacing.sm),
                    itemBuilder: (context, i) => i < inbox.items.length
                        ? _Message(item: inbox.items[i])
                        : !inbox.hasMore
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: WWSpacing.md),
                            child: Text(
                              l10n.notificationsKept,
                              key: const Key('notifications-kept'),
                              style: WWType.caption,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Center(
                            child: inbox.loadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(WWSpacing.md),
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton(
                                    key: const Key('notifications-more'),
                                    onPressed: () => ref.read(notificationsProvider.notifier).loadMore(),
                                    child: Text(l10n.loadMore),
                                  ),
                          ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.item});

  final NotificationOut item;

  @override
  Widget build(BuildContext context) {
    final bookingId = item.data['bookingId'];
    final unread = item.readAt == null;
    return WWCard(
      key: Key('notification-${item.id}'),
      onTap: bookingId == null || bookingId.isEmpty ? null : () => context.push(BookingScreen.pathFor(bookingId)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: WWSpacing.sm),
            child: CircleAvatar(radius: 4, backgroundColor: unread ? WWColors.primary : Colors.transparent),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: WWType.cardTitle),
                const SizedBox(height: WWSpacing.xs),
                Text(item.body, style: WWType.body),
                const SizedBox(height: WWSpacing.xs),
                Text(istDateTime(context, item.createdAt), style: WWType.caption),
              ],
            ),
          ),
          if (bookingId != null && bookingId.isNotEmpty) const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}

/// The bell on Home: opens the inbox and shows how many messages are unread.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final unread = ref.watch(unreadCountProvider).value ?? 0;
    return IconButton(
      key: const Key('notification-bell'),
      tooltip: unread > 0 ? l10n.notificationsUnread(unread) : l10n.notificationsTitle,
      onPressed: () => context.push(NotificationsScreen.path),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 99 ? '99+' : '$unread'),
        child: const Icon(Icons.notifications_none, color: WWColors.primary),
      ),
    );
  }
}
