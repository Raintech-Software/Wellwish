import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../booking/booking_flow.dart';
import '../common/booking_format.dart';
import '../common/patient_ui.dart';

/// The visit code (§6.11): the family gives it to the partner at pickup / start. Shown until
/// that step is done.
class VisitCodeCard extends StatelessWidget {
  const VisitCodeCard({super.key, required this.code, required this.partnerName});

  final String code;
  final String partnerName;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      key: const Key('visit-code'),
      child: Row(
        children: [
          const Icon(Icons.pin_outlined, color: WWColors.primary, size: 32),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.visitCodeTitle, style: WWType.caption),
                Text(code, style: WWType.screenTitle.copyWith(color: WWColors.primary, letterSpacing: 8)),
                Text(l10n.visitCodeHelp(partnerName), style: WWType.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// P20 Completed: "Pay ₹400 to Rashmita" (the balance goes to the partner directly); once the
/// partner has recorded it, "Paid ₹400 to Rashmita" (PHASES 9.11).
class CompletedCard extends StatelessWidget {
  const CompletedCard({super.key, required this.booking});

  final BookingDetailOut booking;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final balance = booking.service.balancePaise;
    final collected = booking.visit?.balanceCollectedPaise;
    final name = booking.partner?.fullName.split(' ').first ?? '';
    return WWCard(
      key: const Key('visit-completed'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: WWColors.brandGreen),
              const SizedBox(width: WWSpacing.sm),
              Flexible(
                child: Text(l10n.visitCompleted, style: WWType.cardTitle.copyWith(color: WWColors.brandGreen)),
              ),
            ],
          ),
          if (collected != null && collected > 0) ...[
            const SizedBox(height: WWSpacing.sm),
            Text(l10n.paidPartner(inr(collected), name), key: const Key('balance-paid'), style: WWType.section),
          ] else if (balance > 0) ...[
            const SizedBox(height: WWSpacing.sm),
            Text(l10n.payPartner(inr(balance), name), style: WWType.section),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.payPartnerHelp, style: WWType.caption),
          ],
        ],
      ),
    );
  }
}

String reviewTagLabel(WWLocalizations l10n, String tag) => switch (tag) {
  'ON_TIME' => l10n.tagOnTime,
  'KIND' => l10n.tagKind,
  'HELPFUL' => l10n.tagHelpful,
  'PROFESSIONAL' => l10n.tagProfessional,
  'GOOD_COMMUNICATION' => l10n.tagGoodCommunication,
  'LATE' => l10n.tagLate,
  'RUDE' => l10n.tagRude,
  'UNHELPFUL' => l10n.tagUnhelpful,
  _ => tag,
};

const _goodTags = [
  ReviewInTagsEnum.ON_TIME,
  ReviewInTagsEnum.KIND,
  ReviewInTagsEnum.HELPFUL,
  ReviewInTagsEnum.PROFESSIONAL,
  ReviewInTagsEnum.GOOD_COMMUNICATION,
];
const _badTags = [ReviewInTagsEnum.LATE, ReviewInTagsEnum.RUDE, ReviewInTagsEnum.UNHELPFUL];

/// P20 rating: 1–5 stars, a few tags (good ones for 4–5 stars, problems for 1–3), a comment.
/// Once per booking.
class RatingCard extends ConsumerStatefulWidget {
  const RatingCard({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<RatingCard> createState() => _RatingCardState();
}

class _RatingCardState extends ConsumerState<RatingCard> {
  final _comment = TextEditingController();
  int _stars = 0;
  final _tags = <ReviewInTagsEnum>{};
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _setStars(int stars) => setState(() {
    if ((stars >= 4) != (_stars >= 4)) _tags.clear(); // the other group of tags
    _stars = stars;
    _error = null;
  });

  Future<void> _send() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    if (_stars == 0) {
      setState(() => _error = l10n.chooseStars);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(patientApiProvider)
          .patientReview(
            bookingId: widget.bookingId,
            reviewIn: ReviewIn(stars: _stars, tags: _tags.toList(), comment: _comment.text.trim()),
          );
      if (mounted) showSnack(context, l10n.ratingThanks);
      container.invalidate(bookingDetailProvider(widget.bookingId));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = patientErrorMessage(l10n, e);
      });
      if (toApiException(e).code == 'ALREADY_REVIEWED') container.invalidate(bookingDetailProvider(widget.bookingId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final tags = _stars == 0 ? const <ReviewInTagsEnum>[] : (_stars >= 4 ? _goodTags : _badTags);
    return WWCard(
      key: const Key('rate-visit'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.rateVisit, style: WWType.section),
          const SizedBox(height: WWSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  key: Key('star-$i'),
                  tooltip: l10n.starsSemantics(i),
                  iconSize: 36,
                  onPressed: _busy ? null : () => _setStars(i),
                  icon: Icon(i <= _stars ? Icons.star : Icons.star_border, color: WWColors.gold),
                ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: WWSpacing.sm),
            Wrap(
              spacing: WWSpacing.sm,
              runSpacing: WWSpacing.xs,
              children: [
                for (final t in tags)
                  FilterChip(
                    key: Key('tag-${t.value}'),
                    label: Text(reviewTagLabel(l10n, t.value)),
                    selected: _tags.contains(t),
                    onSelected: _busy ? null : (on) => setState(() => on ? _tags.add(t) : _tags.remove(t)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: WWSpacing.md),
          WWTextField(
            key: const Key('review-comment'),
            controller: _comment,
            label: l10n.reviewCommentHint,
            maxLines: 3,
            maxLength: 500,
          ),
          if (_error != null) ...[const SizedBox(height: WWSpacing.sm), WWMessageBox(message: _error!, isError: true)],
          const SizedBox(height: WWSpacing.sm),
          WWPrimaryButton(
            key: const Key('send-rating'),
            label: l10n.sendRating,
            loading: _busy,
            onPressed: _busy ? null : _send,
          ),
        ],
      ),
    );
  }
}

/// The rating already given.
class YourReviewCard extends StatelessWidget {
  const YourReviewCard({super.key, required this.review});

  final ReviewOut review;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      key: const Key('your-rating'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.yourRating, style: WWType.caption),
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(i <= review.stars ? Icons.star : Icons.star_border, color: WWColors.gold, size: 22),
            ],
          ),
          if (review.tags.isNotEmpty)
            Text(review.tags.map((t) => reviewTagLabel(l10n, t)).join(' · '), style: WWType.body),
          if (review.comment.isNotEmpty) Text(review.comment, style: WWType.body),
        ],
      ),
    );
  }
}

/// "Report a problem" (up to 24 h after the visit): a ticket for WellWish.
class ReportProblemButton extends StatelessWidget {
  const ReportProblemButton({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Center(
      child: TextButton.icon(
        key: const Key('report-problem'),
        icon: const Icon(Icons.flag_outlined),
        label: Text(l10n.reportProblem),
        onPressed: () async {
          final sent = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => _ReportSheet(bookingId: bookingId),
          );
          if (sent == true && context.mounted) showSnack(context, l10n.reportSent);
        },
      ),
    );
  }
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  final _text = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final text = _text.text.trim();
    if (text.length < 5) {
      setState(() => _error = l10n.reportTooShort);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(patientApiProvider)
          .patientReportProblem(
            bookingId: widget.bookingId,
            reportIn: ReportIn(text: text),
          );
      container.invalidate(bookingDetailProvider(widget.bookingId));
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = patientErrorMessage(l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: WWSpacing.screen,
        right: WWSpacing.screen,
        bottom: MediaQuery.viewInsetsOf(context).bottom + WWSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.reportProblem, style: WWType.screenTitle),
          const SizedBox(height: WWSpacing.md),
          WWTextField(
            key: const Key('report-text'),
            controller: _text,
            label: l10n.reportHint,
            maxLines: 4,
            maxLength: 1000,
          ),
          if (_error != null) ...[const SizedBox(height: WWSpacing.sm), WWMessageBox(message: _error!, isError: true)],
          const SizedBox(height: WWSpacing.md),
          WWPrimaryButton(
            key: const Key('send-report'),
            label: l10n.sendReport,
            loading: _busy,
            onPressed: _busy ? null : _send,
          ),
        ],
      ),
    );
  }
}

/// The problems reported for this booking and WellWish's replies.
class TicketsSection extends StatelessWidget {
  const TicketsSection({super.key, required this.tickets});

  final List<TicketOut> tickets;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.reportedProblems, style: WWType.section),
        const SizedBox(height: WWSpacing.sm),
        for (final t in tickets)
          WWCard(
            key: Key('ticket-${t.id}'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(istDateTime(context, t.createdAt), style: WWType.caption)),
                    WWBadge(
                      label: t.status == 'CLOSED' ? l10n.ticketClosed : l10n.ticketOpen,
                      color: t.status == 'CLOSED' ? WWColors.textSecondary : WWColors.warning,
                      background: t.status == 'CLOSED' ? WWColors.background : WWColors.warningTint,
                    ),
                  ],
                ),
                const SizedBox(height: WWSpacing.xs),
                Text(t.text, style: WWType.body),
                for (final r in t.replies) ...[
                  const SizedBox(height: WWSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(WWSpacing.sm),
                    decoration: BoxDecoration(
                      color: WWColors.tint,
                      borderRadius: BorderRadius.circular(WWRadius.button),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.wellwishReplied} · ${istDateTime(context, r.at)}',
                          style: WWType.caption.copyWith(color: WWColors.brandBlue),
                        ),
                        Text(r.text, style: WWType.body),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
