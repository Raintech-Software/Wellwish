import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'device_tools.dart';
import 'partner_errors.dart';
import 'registration_controller.dart';
import 'widgets.dart';

/// R06 Documents (and R16's documents part): the checklist for the partner's role, a status
/// chip per document, the reason when one needs a change, and upload / upload again.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  static const path = '/documents';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final status = ref.watch(registrationProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stepDocuments)),
      body: SafeArea(
        child: status.when(
          loading: () => const WWLoading(),
          error: (e, _) => WWErrorState(
            message: partnerErrorMessage(l10n, e),
            retryLabel: l10n.tryAgain,
            onRetry: () => ref.invalidate(registrationProvider),
          ),
          data: (data) => data == null
              ? const WWLoading()
              : RefreshIndicator(
                  onRefresh: () => ref.read(registrationProvider.notifier).refresh(),
                  child: ListView(
                    padding: const EdgeInsets.all(WWSpacing.screen),
                    children: [
                      Text(l10n.documentsSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
                      const SizedBox(height: WWSpacing.lg),
                      DocumentList(status: data),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

/// The document cards (also used on the approved partner's profile, R16).
class DocumentList extends StatelessWidget {
  const DocumentList({super.key, required this.status});

  final KycStatusOut status;

  @override
  Widget build(BuildContext context) {
    final uploadAllowed = const {
      'REGISTERING',
      'REGISTERED',
      'CHANGES_REQUESTED',
      'APPROVED',
      'SUSPENDED',
    }.contains(status.profile.status);
    return Column(
      children: [
        for (final doc in status.documents) ...[
          _DocumentCard(state: doc, uploadAllowed: uploadAllowed),
          const SizedBox(height: WWSpacing.sm),
        ],
      ],
    );
  }
}

class _DocumentCard extends ConsumerWidget {
  const _DocumentCard({required this.state, required this.uploadAllowed});

  final DocStateOut state;
  final bool uploadAllowed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final required = state.required_;
    final doc = state.document;
    final replacement = state.replacement;
    final String? action = switch (state.status) {
      'MISSING' => l10n.upload,
      'REJECTED' => l10n.uploadAgain,
      'EXPIRED' => l10n.uploadNew,
      'APPROVED' when required.hasExpiry => l10n.uploadNew,
      _ => null,
    };
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(docLabel(context, required), style: WWType.cardTitle),
        const SizedBox(height: 2),
        Text(
          [
            required.mandatory ? l10n.docRequired : l10n.docOptional,
            if (!required.mandatory && required.condition.isNotEmpty) docCondition(context, required),
          ].join(' · '),
          style: WWType.caption,
        ),
      ],
    );
    return WWCard(
      key: Key('doc-${required.docType}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // large text (PHASES 9.8): the status goes under the name instead of squeezing it
          if (MediaQuery.textScalerOf(context).scale(1) > 1.3) ...[
            title,
            const SizedBox(height: WWSpacing.xs),
            DocStatusChip(status: state.status),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: title),
                const SizedBox(width: WWSpacing.sm),
                DocStatusChip(status: state.status),
              ],
            ),
          if (required.help.isNotEmpty && state.status == 'MISSING') ...[
            const SizedBox(height: WWSpacing.xs),
            Text(docHelp(context, required), style: WWType.caption),
          ],
          if (doc != null && (doc.numberMasked.isNotEmpty || doc.expiresOn != null)) ...[
            const SizedBox(height: WWSpacing.xs),
            Text(
              [
                if (doc.numberMasked.isNotEmpty) doc.numberMasked,
                if (doc.expiresOn != null) l10n.validTillDate(formatDate(context, doc.expiresOn!)),
              ].join(' · '),
              style: WWType.caption,
            ),
          ],
          if (doc != null && doc.rejectReason.isNotEmpty && state.status == 'REJECTED') ...[
            const SizedBox(height: WWSpacing.sm),
            WWMessageBox(message: doc.rejectReason, isError: true),
          ],
          if (replacement != null) ...[
            const SizedBox(height: WWSpacing.sm),
            replacement.status == 'REJECTED'
                ? WWMessageBox(message: l10n.renewalRejected(replacement.rejectReason), isError: true)
                : WWMessageBox(message: l10n.renewalPending, icon: Icons.hourglass_top),
          ],
          if (uploadAllowed && action != null && replacement?.status != 'PENDING') ...[
            const SizedBox(height: WWSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                key: Key('upload-${required.docType}'),
                icon: const Icon(Icons.upload_file),
                label: Text(action),
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (_) => UploadSheet(required: required),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Pick the file (camera, gallery or PDF), add the number and valid-till date, upload.
class UploadSheet extends ConsumerStatefulWidget {
  const UploadSheet({super.key, required this.required});

  final RequiredDocumentOut required;

  @override
  ConsumerState<UploadSheet> createState() => _UploadSheetState();
}

class _UploadSheetState extends ConsumerState<UploadSheet> {
  final _number = TextEditingController();
  PickedFile? _file;
  DateTime? _expires;
  bool _busy = false;
  bool _submitted = false;
  String? _error;

  RequiredDocumentOut get _req => widget.required;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  Future<void> _pick(PickSource source) async {
    final file = await ref.read(filePickerProvider).pick(source);
    if (file != null) setState(() => _file = file);
  }

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expires ?? DateTime(now.year + 1, now.month, now.day),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 30),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _expires = picked);
  }

  bool get _needsNumber => _req.numberRule != 'NONE';

  Future<void> _upload() async {
    setState(() => _submitted = true);
    if (_file == null || (_needsNumber && _number.text.trim().isEmpty) || (_req.hasExpiry && _expires == null)) {
      return;
    }
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(registrationProvider.notifier)
          .addDocument(
            docType: _req.docType,
            file: _file!,
            number: _number.text.trim(),
            expiresOn: _expires == null ? null : DateTime(_expires!.year, _expires!.month, _expires!.day),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final numberHelp = switch (_req.numberRule) {
      'AADHAAR' => l10n.aadhaarNumberHelp,
      'PAN' => l10n.panNumberHelp,
      _ => null,
    };
    return Padding(
      padding: EdgeInsets.only(
        left: WWSpacing.screen,
        right: WWSpacing.screen,
        bottom: MediaQuery.viewInsetsOf(context).bottom + WWSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(docLabel(context, _req), style: WWType.section),
            if (_req.cameraOnly) ...[
              const SizedBox(height: WWSpacing.xs),
              Text(l10n.cameraOnlyHelp, style: WWType.caption),
            ] else if (_req.help.isNotEmpty) ...[
              const SizedBox(height: WWSpacing.xs),
              Text(docHelp(context, _req), style: WWType.caption),
            ],
            const SizedBox(height: WWSpacing.md),
            if (_file != null)
              WWMessageBox(
                message: l10n.stepDone,
                icon: _file!.mime == 'application/pdf' ? Icons.picture_as_pdf : Icons.check_circle,
              ),
            const SizedBox(height: WWSpacing.sm),
            Wrap(
              spacing: WWSpacing.sm,
              runSpacing: WWSpacing.sm,
              children: [
                WWSecondaryButton(
                  label: l10n.takePhoto,
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: () => _pick(_req.cameraOnly ? PickSource.frontCamera : PickSource.camera),
                ),
                if (!_req.cameraOnly) ...[
                  WWSecondaryButton(
                    label: l10n.chooseFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    onPressed: () => _pick(PickSource.gallery),
                  ),
                  WWSecondaryButton(
                    label: l10n.choosePdf,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    onPressed: () => _pick(PickSource.pdf),
                  ),
                ],
              ],
            ),
            if (_submitted && _file == null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(l10n.errInvalidFile, style: WWType.caption.copyWith(color: WWColors.danger)),
              ),
            if (_needsNumber) ...[
              const SizedBox(height: WWSpacing.lg),
              WWTextField(
                key: const Key('doc-number'),
                controller: _number,
                label: l10n.documentNumber,
                hint: numberHelp,
                keyboardType: _req.numberRule == 'AADHAAR' ? TextInputType.number : TextInputType.text,
                errorText: _submitted && _number.text.trim().isEmpty ? l10n.numberRequired : null,
                onChanged: (_) => setState(() {}),
              ),
              if (numberHelp != null) ...[const SizedBox(height: 4), Text(numberHelp, style: WWType.caption)],
            ],
            if (_req.hasExpiry) ...[
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.validTill),
              WWDateField(
                key: const Key('doc-expiry'),
                text: _expires == null ? null : formatDate(context, _expires!),
                placeholder: l10n.selectDate,
                onTap: _pickExpiry,
                errorText: _submitted && _expires == null ? l10n.expiryRequired : null,
              ),
            ],
            ErrorNote(_error),
            const SizedBox(height: WWSpacing.lg),
            WWPrimaryButton(label: _busy ? l10n.uploading : l10n.upload, loading: _busy, onPressed: _upload),
          ],
        ),
      ),
    );
  }
}
