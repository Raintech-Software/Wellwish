import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../registration/partner_errors.dart';
import 'job_format.dart';
import 'job_screen.dart';
import 'jobs_providers.dart';
import 'offer_card.dart';

/// R10 My bookings: New (open offers) · Upcoming (accepted) · Completed.
class JobsTab extends StatelessWidget {
  const JobsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(key: const Key('jobs-new'), text: l10n.jobsNew),
              Tab(key: const Key('jobs-upcoming'), text: l10n.jobsUpcoming),
              Tab(key: const Key('jobs-completed'), text: l10n.jobsCompleted),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _OffersList(),
                _JobsList(bucket: 'upcoming'),
                _JobsList(bucket: 'completed'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OffersList extends ConsumerWidget {
  const _OffersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final offers = ref.watch(openOffersProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(openOffersProvider.future),
      child: offers.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(openOffersProvider),
        ),
        data: (items) => items.isEmpty
            ? ListView(
                children: [WWEmptyState(icon: Icons.inbox_outlined, title: l10n.noOffers)],
              )
            : ListView(
                padding: const EdgeInsets.all(WWSpacing.screen),
                children: [
                  for (final o in items) ...[OfferCard(offer: o), const SizedBox(height: WWSpacing.sm)],
                ],
              ),
      ),
    );
  }
}

class _JobsList extends ConsumerWidget {
  const _JobsList({required this.bucket});

  final String bucket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final jobs = ref.watch(jobsProvider(bucket));
    return RefreshIndicator(
      onRefresh: () => ref.refresh(jobsProvider(bucket).future),
      child: jobs.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(jobsProvider(bucket)),
        ),
        data: (items) => items.isEmpty
            ? ListView(
                children: [
                  WWEmptyState(
                    icon: Icons.work_outline,
                    title: bucket == 'upcoming' ? l10n.noUpcomingJobs : l10n.noCompletedJobs,
                  ),
                ],
              )
            : ListView(
                padding: const EdgeInsets.all(WWSpacing.screen),
                children: [
                  for (final j in items) ...[JobRowCard(job: j), const SizedBox(height: WWSpacing.sm)],
                ],
              ),
      ),
    );
  }
}

/// A job in a list: service, member, when, area, status.
class JobRowCard extends StatelessWidget {
  const JobRowCard({super.key, required this.job});

  final PartnerJobRowOut job;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      key: Key('job-${job.code}'),
      onTap: () => context.push(JobScreen.pathFor(job.id)),
      child: Row(
        children: [
          const Icon(Icons.event_note_outlined, color: WWColors.primary, size: 32),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceName(context, job.service), style: WWType.cardTitle),
                Text('${job.memberName} · ${istDateTime(context, job.pickupAt)}', style: WWType.caption),
                if (job.hospitalName.isNotEmpty || job.area.isNotEmpty)
                  Text(job.hospitalName.isNotEmpty ? job.hospitalName : job.area, style: WWType.caption),
                Text(
                  job.reconfirmNeeded ? l10n.offerReconfirm : jobStatusLabel(l10n, job.status),
                  style: WWType.caption.copyWith(
                    color: job.reconfirmNeeded ? WWColors.warning : WWColors.brandGreen,
                    fontWeight: FontWeight.w600,
                  ),
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
