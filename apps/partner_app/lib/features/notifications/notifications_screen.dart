import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../registration/partner_errors.dart';

/// The partner's inbox (status messages, document reminders). Opening it marks them read.
final notificationsProvider = FutureProvider.autoDispose<List<NotificationOut>>((ref) async {
  final api = ref.watch(partnerApiProvider);
  final page = (await api.partnerNotificationsList(page: 1, pageSize: 50)).data!;
  if (page.items.any((n) => n.readAt == null)) {
    await api.partnerNotificationsRead(markReadIn: MarkReadIn());
  }
  return page.items;
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  static const path = '/notifications';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final items = ref.watch(notificationsProvider);
    final format = DateFormat('d MMM, h:mm a', Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: SafeArea(
        child: items.when(
          loading: () => const WWLoading(),
          error: (e, _) => WWErrorState(
            message: partnerErrorMessage(l10n, e),
            retryLabel: l10n.tryAgain,
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
          data: (list) => list.isEmpty
              ? WWEmptyState(icon: Icons.notifications_none, title: l10n.noNotifications)
              : ListView.separated(
                  padding: const EdgeInsets.all(WWSpacing.screen),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: WWSpacing.sm),
                  itemBuilder: (context, i) {
                    final n = list[i];
                    return WWCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (n.readAt == null) ...[
                                const CircleAvatar(radius: 4, backgroundColor: WWColors.primary),
                                const SizedBox(width: WWSpacing.sm),
                              ],
                              Expanded(child: Text(n.title, style: WWType.cardTitle)),
                            ],
                          ),
                          const SizedBox(height: WWSpacing.xs),
                          Text(n.body, style: WWType.body),
                          const SizedBox(height: WWSpacing.xs),
                          Text(format.format(n.createdAt.toLocal()), style: WWType.caption),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
