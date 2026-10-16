import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../registration/partner_errors.dart';
import 'active_job_panel.dart';
import 'collect_balance_screen.dart';
import 'job_format.dart';
import 'jobs_providers.dart';
import 'visit_controller.dart';

/// R11 Booking detail (§8.1): the member (photo, age, health notes), the full address with
/// "Navigate", hospital and doctor, the times, call the member / the person who booked, the
/// attached documents (the server sends them until 24 h after the job), the balance to collect.
class JobScreen extends ConsumerWidget {
  const JobScreen({super.key, required this.bookingId});

  static const path = '/job/:id';
  static String pathFor(String id) => '/job/$id';

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final code = ref.watch(jobProvider(bookingId).select((job) => job.value?.code));
    return Scaffold(
      appBar: AppBar(title: Text(code == null ? '' : l10n.jobTitle(code))),
      body: JobDetails(bookingId: bookingId),
    );
  }
}

/// The job screen's content: R11 with the active-job panel (R12) on top while the job is on.
/// Also a temporary partner's home (§6.19), with their welcome line as the [header].
class JobDetails extends ConsumerWidget {
  const JobDetails({super.key, required this.bookingId, this.header});

  final String bookingId;

  /// Shown above the job once it's loaded.
  final List<Widget> Function(PartnerJobOut job)? header;

  /// The call attempt is kept (§6.11: needed before "patient not available").
  Future<void> _call(BuildContext context, WidgetRef ref, CallInToEnum to, String phone) async {
    if (phone.isEmpty) return;
    unawaited(ref.read(visitControllerProvider.notifier).logCall(bookingId, to));
    await launchUrl(Uri(scheme: 'tel', path: phone.replaceAll(' ', '')));
  }

  Future<void> _navigate(String destination) async {
    final uri = Uri.https('www.google.com', '/maps/dir/', {'api': '1', 'destination': destination});
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final job = ref.watch(jobProvider(bookingId));
    // a job that's over (also when WellWish ended or took it away) stops sharing the location
    ref.listen(jobProvider(bookingId), (_, next) {
      final controller = ref.read(visitControllerProvider.notifier)
        ..notificationTitle = l10n.fgsTitle
        ..notificationText = l10n.fgsText;
      if (next.hasError) {
        if (toApiException(next.error!).statusCode == 404) controller.jobLoaded(bookingId, null);
      } else if (next.hasValue) {
        controller.jobLoaded(bookingId, next.value);
      }
    });
    return job.when(
      loading: () => const WWLoading(),
      error: (e, _) => toApiException(e).statusCode == 404
          // cancelled, unassigned or moved to someone else meanwhile
          ? WWEmptyState(icon: Icons.event_busy, title: l10n.errOfferNotOpen)
          : WWErrorState(
              message: partnerErrorMessage(l10n, e),
              retryLabel: l10n.tryAgain,
              onRetry: () => ref.invalidate(jobProvider(bookingId)),
            ),
      data: (j) {
        final m = j.member;
        final health = [
          if (m.mobility.isNotEmpty) (l10n.mobility, mobilityLabel(l10n, m.mobility)),
          if (m.conditions.isNotEmpty) (l10n.conditions, m.conditions),
          if (m.allergies.isNotEmpty) (l10n.allergies, m.allergies),
          if (m.sensoryNotes.isNotEmpty) (l10n.sensoryNotes, m.sensoryNotes),
        ];
        final active = j.status == 'ACCEPTED' || j.status == 'IN_PROGRESS';
        final pickedUp = j.visit?.done.any((d) => d.step == 'PICKED_UP') ?? false;
        final hospital = j.hospitalName.isNotEmpty ? j.hospitalName : j.hospitalText;
        final config = ref.watch(appConfigProvider);
        return RefreshIndicator(
          onRefresh: () => ref.refresh(jobProvider(bookingId).future),
          child: ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              ...?header?.call(j),
              if (j.reconfirmNeeded) ...[
                WWMessageBox(message: l10n.reconfirmPending, icon: Icons.update),
                const SizedBox(height: WWSpacing.md),
              ],
              if (active && j.visit != null) ...[ActiveJobPanel(job: j), const SizedBox(height: WWSpacing.md)],
              WWCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: WWColors.tint,
                      backgroundImage: m.photoUrl == null ? null : NetworkImage(fileUrl(config, m.photoUrl!)),
                      child: m.photoUrl == null ? const Icon(Icons.person, color: WWColors.primary) : null,
                    ),
                    const SizedBox(width: WWSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.fullName, style: WWType.section),
                          Text(personLine(l10n, m.gender, m.age), style: WWType.caption),
                          if (m.language.isNotEmpty) Text(spokenLanguage(l10n, m.language), style: WWType.caption),
                          // under the name: long statuses ("Patient not available") fit
                          const SizedBox(height: WWSpacing.xs),
                          WWBadge(
                            label: jobStatusLabel(l10n, j.status),
                            color: WWColors.brandGreen,
                            background: WWColors.greenTint,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: WWSpacing.md),
              Row(
                children: [
                  if (m.phone.isNotEmpty)
                    Expanded(
                      child: WWSecondaryButton(
                        key: const Key('call-member'),
                        icon: const Icon(Icons.phone),
                        label: l10n.callPatient,
                        onPressed: () => _call(context, ref, CallInToEnum.MEMBER, m.phone),
                      ),
                    ),
                  if (m.phone.isNotEmpty && j.bookerPhone.isNotEmpty) const SizedBox(width: WWSpacing.sm),
                  if (j.bookerPhone.isNotEmpty)
                    Expanded(
                      child: WWSecondaryButton(
                        key: const Key('call-booker'),
                        icon: const Icon(Icons.phone_forwarded),
                        label: l10n.callBooker(j.bookerName.split(' ').first),
                        onPressed: () => _call(context, ref, CallInToEnum.BOOKER, j.bookerPhone),
                      ),
                    ),
                ],
              ),
              if (health.isNotEmpty) ...[
                const SizedBox(height: WWSpacing.lg),
                Text(l10n.healthNotes, style: WWType.section),
                const SizedBox(height: WWSpacing.sm),
                WWCard(
                  child: Column(
                    children: [for (final (label, value) in health) _Line(label: label, value: value)],
                  ),
                ),
              ],
              const SizedBox(height: WWSpacing.lg),
              WWCard(
                child: Column(
                  children: [
                    _Line(
                      label: l10n.whenLabel,
                      value: [
                        istDateTime(context, j.pickupAt),
                        if (j.appointmentAt != null) l10n.appointmentAt(istTime(context, j.appointmentAt!)),
                      ].join('\n'),
                    ),
                    _Line(label: l10n.hospitalLabel, value: j.hospitalName),
                    _Line(label: l10n.doctorLabel, value: j.doctorName),
                    _Line(
                      label: l10n.jobAddress,
                      value: [
                        '${j.address.label}: ${j.address.line1}',
                        if (j.address.landmark.isNotEmpty) j.address.landmark,
                        if (j.address.notes.isNotEmpty) j.address.notes,
                      ].join('\n'),
                    ),
                    if (j.notes.isNotEmpty) _Line(label: l10n.notesTitle, value: j.notes),
                  ],
                ),
              ),
              if (j.address.lat.isNotEmpty && active && !pickedUp) ...[
                const SizedBox(height: WWSpacing.sm),
                WWSecondaryButton(
                  key: const Key('navigate'),
                  icon: const Icon(Icons.directions),
                  label: l10n.navigate,
                  onPressed: () => _navigate('${j.address.lat},${j.address.lng}'),
                ),
              ],
              // after the pickup: to the hospital (by its name; Maps finds it)
              if (pickedUp && hospital.isNotEmpty && j.status == 'IN_PROGRESS') ...[
                const SizedBox(height: WWSpacing.sm),
                WWSecondaryButton(
                  key: const Key('navigate-hospital'),
                  icon: const Icon(Icons.local_hospital_outlined),
                  label: l10n.navigateHospital,
                  onPressed: () => _navigate('$hospital, Odisha'),
                ),
              ],
              if (j.documents.isNotEmpty) ...[
                const SizedBox(height: WWSpacing.lg),
                Text(l10n.documentsLabel, style: WWType.section),
                const SizedBox(height: WWSpacing.sm),
                for (final doc in j.documents) _DocumentTile(bookingId: bookingId, doc: doc),
              ],
              const SizedBox(height: WWSpacing.lg),
              // nothing to collect when the family paid the whole price in the app
              if (j.balancePaise > 0 || j.visit?.balanceCollectedPaise != null)
                if (j.status == 'COMPLETED')
                  _BalanceCard(job: j)
                else
                  WWMessageBox(message: l10n.collectBalance(inr(j.balancePaise)), icon: Icons.currency_rupee),
              const SizedBox(height: WWSpacing.lg),
            ],
          ),
        );
      },
    );
  }
}

/// One attached document: opens a 5-minute link (photos full screen, PDFs in the phone's PDF
/// app from the private cache). One download at a time; problems are shown.
class _DocumentTile extends ConsumerStatefulWidget {
  const _DocumentTile({required this.bookingId, required this.doc});

  final String bookingId;
  final BookingDocumentOut doc;

  @override
  ConsumerState<_DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends ConsumerState<_DocumentTile> {
  bool _opening = false;

  Future<void> _open() async {
    if (_opening) return;
    final l10n = WWLocalizations.of(context);
    final navigator = Navigator.of(context);
    setState(() => _opening = true);
    try {
      final link =
          (await ref.read(partnerApiProvider).partnerJobDocumentUrl(bookingId: widget.bookingId, linkId: widget.doc.id))
              .data!;
      final url = fileUrl(ref.read(appConfigProvider), link.url);
      if (link.mime.startsWith('image/')) {
        if (!mounted) return;
        await navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(widget.doc.title)),
              backgroundColor: Colors.black,
              body: InteractiveViewer(
                child: Center(
                  child: Image.network(
                    url,
                    loadingBuilder: (_, child, progress) => progress == null ? child : const WWLoading(),
                    errorBuilder: (_, _, _) => Text(l10n.cannotOpen, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        final opened = await ref.read(documentOpenerProvider).openPdf(url: url, documentId: widget.doc.id);
        if (!opened && mounted) showSnack(context, l10n.cannotOpen);
      }
    } catch (e) {
      if (mounted) showSnack(context, partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final doc = widget.doc;
    return WWCard(
      padding: EdgeInsets.zero,
      child: WWListTile(
        icon: doc.removed ? Icons.block : Icons.description_outlined,
        iconColor: doc.removed ? WWColors.textSecondary : WWColors.primary,
        title: doc.removed ? l10n.documentRemoved : doc.title,
        subtitle: doc.removed ? null : l10n.openDocument,
        trailing: _opening
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : null,
        onTap: doc.removed || _opening ? null : _open,
      ),
    );
  }
}

/// After Completed: the balance recorded, or "Record balance" (R14).
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.job});

  final PartnerJobOut job;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final paise = job.visit?.balanceCollectedPaise;
    final mode = job.visit?.balanceMode == 'UPI' ? l10n.payUpi : l10n.payCash;
    return WWCard(
      key: const Key('balance-card'),
      onTap: () => context.push(CollectBalanceScreen.pathFor(job.id)),
      child: Row(
        children: [
          const Icon(Icons.currency_rupee, color: WWColors.brandGreen),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Text(
              paise == null ? l10n.recordBalance : l10n.balanceRecorded(inr(paise), mode),
              style: WWType.cardTitle,
            ),
          ),
          const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 104, child: Text(label, style: WWType.caption)),
          Expanded(child: Text(value, style: WWType.body)),
        ],
      ),
    );
  }
}
