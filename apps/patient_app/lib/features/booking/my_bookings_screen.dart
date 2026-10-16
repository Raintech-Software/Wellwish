import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'booking_flow.dart';
import 'booking_screen.dart';

/// P17 My bookings: Upcoming (soonest first), Ongoing, Past (latest first), 20 at a time.
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  static const path = '/bookings';

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.myBookings),
          bottom: TabBar(
            tabs: [
              Tab(key: const Key('tab-upcoming'), text: l10n.tabUpcoming),
              Tab(key: const Key('tab-ongoing'), text: l10n.tabOngoing),
              Tab(key: const Key('tab-past'), text: l10n.tabPast),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BookingsTab(bucket: 'upcoming', empty: l10n.noUpcomingBookings),
            _BookingsTab(bucket: 'ongoing', empty: l10n.noOngoingBookings),
            _BookingsTab(bucket: 'past', empty: l10n.noPastBookings),
          ],
        ),
      ),
    );
  }
}

class _BookingsTab extends ConsumerStatefulWidget {
  const _BookingsTab({required this.bucket, required this.empty});

  final String bucket;
  final String empty;

  @override
  ConsumerState<_BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends ConsumerState<_BookingsTab> with AutomaticKeepAliveClientMixin {
  int _pages = 1;

  @override
  bool get wantKeepAlive => true;

  Future<void> _refresh() {
    setState(() => _pages = 1);
    return ref.refresh(myBookingsProvider((widget.bucket, 1)).future);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = WWLocalizations.of(context);
    final first = ref.watch(myBookingsProvider((widget.bucket, 1)));
    if (first.value == null) {
      return first.hasError
          ? WWErrorState(
              message: patientErrorMessage(l10n, first.error!),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(myBookingsProvider((widget.bucket, 1))),
            )
          : const WWLoading();
    }
    final rows = <BookingRowOut>[];
    final seen = <String>{};
    var loading = false;
    Object? error;
    var failedPage = 0;
    var total = first.value!.count;
    var more = false;
    for (var page = 1; page <= _pages; page++) {
      final result = ref.watch(myBookingsProvider((widget.bucket, page)));
      if (result.value != null) {
        // The list can shift between pages (a booking moves tab): show each booking once.
        rows.addAll(result.value!.items.where((b) => seen.add(b.id)));
        total = result.value!.count;
        more = page * result.value!.pageSize < total;
      } else if (result.hasError) {
        error = result.error;
        failedPage = page;
        break;
      } else {
        loading = true;
        break;
      }
    }
    if (rows.isEmpty && !loading && error == null) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            const SizedBox(height: WWSpacing.xl),
            WWEmptyState(icon: Icons.event_note_outlined, title: widget.empty),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          for (final b in rows) ...[
            BookingRowCard(booking: b, onTap: () => context.push(BookingScreen.pathFor(b.id))),
            const SizedBox(height: WWSpacing.sm),
          ],
          if (loading) const Padding(padding: EdgeInsets.all(WWSpacing.md), child: WWLoading()),
          if (error != null)
            WWErrorState(
              message: patientErrorMessage(l10n, error),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(myBookingsProvider((widget.bucket, failedPage))),
            )
          else if (!loading && more)
            WWSecondaryButton(
              key: const Key('bookings-more'),
              label: l10n.loadMore,
              onPressed: () => setState(() => _pages++),
            ),
        ],
      ),
    );
  }
}

/// A booking in a list: service, for whom and when, status (P17 and the Home card).
class BookingRowCard extends StatelessWidget {
  const BookingRowCard({super.key, required this.booking, required this.onTap});

  final BookingRowOut booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final color = switch (booking.status) {
      'PENDING_PAYMENT' => WWColors.warning,
      'CANCELLED' || 'EXPIRED' || 'PATIENT_NO_SHOW' => WWColors.textSecondary,
      _ => WWColors.brandGreen,
    };
    return WWCard(
      key: Key('booking-${booking.code}'),
      onTap: onTap,
      child: Row(
        children: [
          const Icon(Icons.event_note_outlined, color: WWColors.primary, size: 32),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bookedServiceName(context, booking.service), style: WWType.cardTitle),
                Text('${booking.memberName} · ${istDateTime(context, booking.pickupAt)}', style: WWType.caption),
                Text(
                  bookingStatusLabel(l10n, booking.status),
                  style: WWType.caption.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}
