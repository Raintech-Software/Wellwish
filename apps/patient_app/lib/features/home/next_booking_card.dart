import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../booking/booking_flow.dart';
import '../booking/booking_screen.dart';
import '../booking/my_bookings_screen.dart';

/// Home: the job in progress, else the soonest upcoming booking (§7.1 P05). Hidden when there
/// is none (or it can't be loaded: the tiles still work). Home stays alive in its tab, so the
/// card reloads when the app comes back to the front and when an unpaid booking's time is up.
class NextBookingCard extends ConsumerStatefulWidget {
  const NextBookingCard({super.key});

  @override
  ConsumerState<NextBookingCard> createState() => _NextBookingCardState();
}

class _NextBookingCardState extends ConsumerState<NextBookingCard> {
  late final AppLifecycleListener _lifecycle;
  Timer? _expiry;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: () => ref.invalidate(nextBookingProvider));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _expiry?.cancel();
    super.dispose();
  }

  void _reloadAt(DateTime? payBy) {
    _expiry?.cancel();
    if (payBy == null) return;
    // The expiry task runs every 5 min. At least a minute apart: the server can still say
    // "unpaid" for a few minutes after the time is up.
    var wait = payBy.difference(DateTime.now()) + const Duration(minutes: 6);
    if (wait < const Duration(minutes: 1)) wait = const Duration(minutes: 1);
    _expiry = Timer(wait, () {
      if (mounted) ref.invalidate(nextBookingProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    ref.listen(nextBookingProvider, (_, next) => _reloadAt(next.value?.payBy));
    final booking = ref.watch(nextBookingProvider).value;
    if (booking == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: WWSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.nextBooking, style: WWType.section)),
              TextButton(
                key: const Key('all-bookings'),
                onPressed: () => context.push(MyBookingsScreen.path),
                child: Text(l10n.seeAll),
              ),
            ],
          ),
          KeyedSubtree(
            key: const Key('next-booking'),
            child: BookingRowCard(booking: booking, onTap: () => context.push(BookingScreen.pathFor(booking.id))),
          ),
        ],
      ),
    );
  }
}
