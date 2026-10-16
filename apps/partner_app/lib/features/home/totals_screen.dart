import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../jobs/job_format.dart';
import '../registration/partner_errors.dart';

final partnerStatsProvider = FutureProvider.autoDispose<PartnerStatsOut>(
  (ref) async => (await ref.watch(partnerApiProvider).partnerTotals()).data!,
);

/// R15 Totals (§6.13): jobs done, the balance collected (as the partner recorded it, cash /
/// UPI), offers answered, the rating and recent reviews, upcoming jobs.
class TotalsScreen extends ConsumerWidget {
  const TotalsScreen({super.key});

  static const path = '/totals';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final stats = ref.watch(partnerStatsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.totalsTitle)),
      body: stats.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(partnerStatsProvider),
        ),
        data: (s) => RefreshIndicator(
          onRefresh: () => ref.refresh(partnerStatsProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Text(l10n.jobsDoneTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              Row(
                children: [
                  _Number(label: l10n.totalsDoneToday, value: '${s.jobs.today}'),
                  const SizedBox(width: WWSpacing.sm),
                  _Number(label: l10n.totalsThisWeek, value: '${s.jobs.thisWeek}'),
                  const SizedBox(width: WWSpacing.sm),
                  _Number(label: l10n.totalsThisMonth, value: '${s.jobs.thisMonth}'),
                  const SizedBox(width: WWSpacing.sm),
                  _Number(label: l10n.totalsAllTime, value: '${s.jobs.allTime}'),
                ],
              ),
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.balanceCollectedTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              WWCard(
                child: Column(
                  children: [
                    for (final (label, sum) in [
                      (l10n.totalsThisWeek, s.balanceWeek),
                      (l10n.totalsThisMonth, s.balanceMonth),
                      (l10n.totalsAllTime, s.balanceAll),
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
                        child: Row(
                          children: [
                            Expanded(child: Text(label, style: WWType.body)),
                            Text(inr(sum.cashPaise + sum.upiPaise), style: WWType.cardTitle),
                          ],
                        ),
                      ),
                    Text(l10n.cashUpi(inr(s.balanceAll.cashPaise), inr(s.balanceAll.upiPaise)), style: WWType.caption),
                  ],
                ),
              ),
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.offersTitleTotals, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              WWCard(
                child: Text(
                  l10n.offersLine(s.offersReceived, s.offersAccepted, s.offersDeclined, s.offersNotAnswered),
                  style: WWType.body,
                ),
              ),
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.ratingTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              if (s.ratingCount == 0)
                WWCard(child: Text(l10n.noReviewsYet, style: WWType.caption))
              else ...[
                Row(
                  children: [
                    const Icon(Icons.star, color: WWColors.warning),
                    const SizedBox(width: WWSpacing.xs),
                    Text(l10n.ratingCount(s.ratingAvg ?? '', s.ratingCount), style: WWType.cardTitle),
                  ],
                ),
                const SizedBox(height: WWSpacing.sm),
                for (final r in s.recentReviews) ...[
                  WWCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('★' * r.stars, style: WWType.cardTitle.copyWith(color: WWColors.warning)),
                        // what the family picked: On time, Kind… (PHASES 9.11)
                        if (r.tags.isNotEmpty) ...[
                          const SizedBox(height: WWSpacing.xs),
                          Wrap(
                            spacing: WWSpacing.xs,
                            runSpacing: WWSpacing.xs,
                            children: [
                              for (final tag in r.tags)
                                WWBadge(
                                  label: _tagLabel(l10n, tag),
                                  color: _badTags.contains(tag) ? WWColors.danger : WWColors.brandGreen,
                                  background: _badTags.contains(tag)
                                      ? WWColors.danger.withValues(alpha: 0.08)
                                      : WWColors.greenTint,
                                ),
                            ],
                          ),
                          const SizedBox(height: WWSpacing.xs),
                        ],
                        if (r.comment.isNotEmpty) Text(r.comment, style: WWType.body),
                        Text(
                          '${_reviewService(context, r)} · ${istDateTime(context, r.createdAt)}',
                          style: WWType.caption,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: WWSpacing.sm),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: WWCard(
      child: Column(
        children: [
          Text(value, style: WWType.screenTitle.copyWith(color: WWColors.primary)),
          Text(label, style: WWType.caption, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

/// The reviewed visit's service in the app's language (Phase 9.1).
const _badTags = {'LATE', 'RUDE', 'UNHELPFUL'};

/// The review tags (§6.15), as the family saw them.
String _tagLabel(WWLocalizations l10n, String tag) => switch (tag) {
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

String _reviewService(BuildContext context, PartnerReviewOut r) {
  final translated = switch (Localizations.localeOf(context).languageCode) {
    'hi' => r.serviceNameHi,
    'or' => r.serviceNameOr,
    _ => null,
  };
  return (translated ?? '').isNotEmpty ? translated! : r.serviceName;
}
