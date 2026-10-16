import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/patient_ui.dart';
import '../documents/documents_screen.dart';
import '../family/family_controller.dart';
import 'booking_flow.dart';
import 'review_screen.dart';

/// P14 Attach documents: tick the member's saved documents or upload new ones (also saved to
/// the account). Injection and IV need a prescription (§6.8).
class DocumentsStepScreen extends ConsumerStatefulWidget {
  const DocumentsStepScreen({super.key});

  static const path = '/book-step/documents';

  @override
  ConsumerState<DocumentsStepScreen> createState() => _DocumentsStepScreenState();
}

class _DocumentsStepScreenState extends ConsumerState<DocumentsStepScreen> {
  bool _submitted = false;

  Future<void> _upload(String memberId) async {
    final before = (ref.read(memberDocumentsProvider(memberId)).value ?? const []).map((d) => d.id).toSet();
    await showUploadDocumentSheet(context, memberId: memberId);
    if (!mounted) return;
    final after = await ref.refresh(memberDocumentsProvider(memberId).future);
    if (!mounted) return;
    // What was just uploaded is ticked for this booking.
    final draft = ref.read(bookingDraftProvider.notifier);
    for (final d in after.where((d) => !before.contains(d.id))) {
      if (!ref.read(bookingDraftProvider).documentIds.contains(d.id)) draft.toggleDocument(d.id);
    }
  }

  bool _hasPrescription(List<PatientDocumentOut> docs, Set<String> ticked) =>
      docs.any((d) => ticked.contains(d.id) && d.type == 'PRESCRIPTION');

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final memberId = draft.memberId;
    final service = draft.service;
    if (memberId == null || service == null) return const Scaffold(body: WWLoading());
    final docs = ref.watch(memberDocumentsProvider(memberId));
    final members = ref.watch(membersProvider).value ?? const <MemberOut>[];
    final member = members.where((m) => m.id == memberId).firstOrNull;
    final noDocuments = member == null || member.isSelf
        ? l10n.youHaveNoDocuments
        : l10n.noDocumentsForName(member.fullName.split(' ').first);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.attachDocumentsTitle)),
      body: docs.unwrapPrevious().when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(memberDocumentsProvider(memberId)),
        ),
        data: (list) {
          final missing = service.docsRequired && !_hasPrescription(list, draft.documentIds);
          return ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Text(l10n.attachDocumentsHelp, style: WWType.caption),
              if (service.docsRequired) ...[
                const SizedBox(height: WWSpacing.sm),
                WWMessageBox(message: l10n.prescriptionRequiredHelp, icon: Icons.medication_outlined),
              ],
              const SizedBox(height: WWSpacing.md),
              if (list.isEmpty) WWCard(child: Text(noDocuments, style: WWType.caption)),
              for (final d in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: WWSpacing.sm),
                  child: WWCard(
                    padding: EdgeInsets.zero,
                    child: CheckboxListTile(
                      key: Key('attach-${d.id}'),
                      value: draft.documentIds.contains(d.id),
                      onChanged: (_) => ref.read(bookingDraftProvider.notifier).toggleDocument(d.id),
                      title: Text(d.title, style: WWType.cardTitle),
                      subtitle: Text(
                        [documentTypeLabel(l10n, d.type), if (d.date != null) formatDate(context, d.date!)].join(' · '),
                        style: WWType.caption,
                      ),
                    ),
                  ),
                ),
              WWSecondaryButton(
                key: const Key('booking-upload'),
                label: l10n.uploadNew,
                icon: const Icon(Icons.upload_file, color: WWColors.primary),
                onPressed: () => _upload(memberId),
              ),
              if (_submitted && missing) ...[
                const SizedBox(height: WWSpacing.md),
                WWMessageBox(message: l10n.attachPrescription, isError: true),
              ],
              const SizedBox(height: WWSpacing.lg),
              WWPrimaryButton(
                key: const Key('documents-next'),
                label: l10n.nextLabel,
                onPressed: () {
                  setState(() => _submitted = true);
                  if (!missing) pushStep(context, ReviewScreen.path);
                },
              ),
              const SizedBox(height: WWSpacing.lg),
            ],
          );
        },
      ),
    );
  }
}
