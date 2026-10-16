import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'job_format.dart';
import 'offer_screen.dart';

/// "1:42 left to answer", then "Please answer: WellWish is waiting" (§6.10: the offer stays
/// open after 2 minutes, a late accept still wins). Counts with the server's clock (the phone's
/// may be off) and starts again when the offer gets a new time.
class OfferCountdown extends StatefulWidget {
  const OfferCountdown({super.key, required this.timeoutAt});

  final DateTime timeoutAt;

  @override
  State<OfferCountdown> createState() => _OfferCountdownState();
}

class _OfferCountdownState extends State<OfferCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(OfferCountdown old) {
    super.didUpdateWidget(old);
    if (old.timeoutAt != widget.timeoutAt) _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final left = widget.timeoutAt.difference(ServerClock.now()).inSeconds;
    if (left <= 0) _timer?.cancel();
    final late = left <= 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          late ? Icons.notifications_active : Icons.timer_outlined,
          size: 18,
          color: late ? WWColors.danger : WWColors.warning,
        ),
        const SizedBox(width: WWSpacing.xs),
        Flexible(
          child: Text(
            late ? l10n.offerWaiting : l10n.offerTimeLeft(clock(left)),
            style: WWType.caption.copyWith(
              color: late ? WWColors.danger : WWColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// R08 "new assignment card": service, when, area and distance, the countdown. Opens R09.
class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});

  final OfferSummaryOut offer;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final reconfirm = offer.kind == 'RECONFIRM';
    return WWCard(
      key: Key('offer-${offer.assignmentId}'),
      onTap: () => context.push(OfferScreen.pathFor(offer.assignmentId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reconfirm) ...[
            WWBadge(
              label: l10n.offerReconfirm,
              icon: Icons.update,
              color: WWColors.warning,
              background: WWColors.warningTint,
            ),
            const SizedBox(height: WWSpacing.xs),
          ],
          Row(
            children: [
              Expanded(child: Text(serviceName(context, offer.service), style: WWType.cardTitle)),
              if (offer.balancePaise > 0)
                Text(inr(offer.balancePaise), style: WWType.cardTitle.copyWith(color: WWColors.brandGreen)),
            ],
          ),
          const SizedBox(height: 2),
          Text(istDateTime(context, offer.pickupAt), style: WWType.body),
          Text(
            [
              if (offer.area.isNotEmpty) offer.area,
              if (offer.distanceKm != null) l10n.offerDistance(offer.distanceKm!.toStringAsFixed(1)),
            ].join(' · '),
            style: WWType.caption,
          ),
          const SizedBox(height: WWSpacing.sm),
          OfferCountdown(timeoutAt: offer.timeoutAt),
        ],
      ),
    );
  }
}
