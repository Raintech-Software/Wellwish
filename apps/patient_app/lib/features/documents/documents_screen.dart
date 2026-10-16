import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import '../family/family_controller.dart';
import 'documents_controller.dart';

/// P21 Medical documents (mockup 7): tabs All / Reports / Prescriptions, a family-member
/// filter, upload from the camera, gallery or a PDF (with progress), view and delete.
class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key, this.memberId});

  static const path = '/reports';

  /// One member's documents as a full page (from their profile's "See all"; back returns).
  static String memberPathFor(String memberId) => '/member/$memberId/documents';

  /// Start filtered to this member (from their profile's "See all").
  final String? memberId;

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  String? _group;
  String? _memberId;

  @override
  void initState() {
    super.initState();
    _memberId = widget.memberId;
  }

  @override
  void didUpdateWidget(DocumentsScreen old) {
    super.didUpdateWidget(old);
    if (widget.memberId != old.memberId) _memberId = widget.memberId;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final query = (group: _group, memberId: _memberId);
    final documents = ref.watch(documentsProvider(query));
    final members = ref.watch(membersProvider).unwrapPrevious().value ?? const <MemberOut>[];
    final storage = ref.watch(documentStorageProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tileMedicalReports)),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('document-upload'),
        backgroundColor: WWColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file),
        label: Text(l10n.uploadDocument),
        onPressed: () => showUploadDocumentSheet(context, memberId: _memberId),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(documentStorageProvider);
          return ref.refresh(documentsProvider(query).future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(WWSpacing.screen, WWSpacing.sm, WWSpacing.screen, 96),
          children: [
            WWChoicePills<String>(
              key: const Key('document-tabs'),
              choices: [
                WWChoice(value: 'all', label: l10n.tabAll),
                WWChoice(value: 'reports', label: l10n.tabReports),
                WWChoice(value: 'prescriptions', label: l10n.tabPrescriptions),
              ],
              selected: _group ?? 'all',
              onSelected: (g) => setState(() => _group = g == 'all' ? null : g),
            ),
            if (members.length > 1) ...[
              const SizedBox(height: WWSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final (id, label) in [
                      (null, l10n.everyone),
                      for (final m in members) (m.id, m.isSelf ? l10n.relationSelf : m.fullName.split(' ').first),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: WWSpacing.sm),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: _memberId == id,
                          onSelected: (_) => setState(() => _memberId = id),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            if (storage != null) ...[
              const SizedBox(height: WWSpacing.sm),
              Text(
                l10n.storageUsed(formatBytes(storage.usedBytes), formatBytes(storage.quotaBytes)),
                style: WWType.caption,
              ),
            ],
            const SizedBox(height: WWSpacing.md),
            ...documents.when(
              loading: () => [const Padding(padding: EdgeInsets.all(WWSpacing.xl), child: WWLoading())],
              error: (e, _) => [
                WWErrorState(
                  message: patientErrorMessage(l10n, e),
                  retryLabel: l10n.tryAgain,
                  onRetry: () => ref.invalidate(documentsProvider(query)),
                ),
              ],
              data: (page) => page.items.isEmpty
                  ? [
                      WWEmptyState(
                        icon: Icons.description_outlined,
                        title: l10n.noDocumentsYet,
                        message: l10n.noDocumentsBody,
                      ),
                    ]
                  : [
                      for (final d in page.items) ...[DocumentCard(document: d), const SizedBox(height: WWSpacing.sm)],
                      if (page.hasMore)
                        WWSecondaryButton(
                          label: l10n.loadMore,
                          onPressed: () => ref.read(documentsProvider(query).notifier).loadMore(),
                        ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One document: type icon, title, date and member, View; Delete from the menu.
class DocumentCard extends ConsumerWidget {
  const DocumentCard({super.key, required this.document, this.showMember = true});

  final PatientDocumentOut document;
  final bool showMember;

  Future<void> _view(BuildContext context, WidgetRef ref) async {
    final l10n = WWLocalizations.of(context);
    if (document.type == 'CARE_NOTE') {
      // the nurse's note: text and vitals, no file to open
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => CareNoteSheet(document: document),
      );
      return;
    }
    try {
      final link = (await ref.read(patientApiProvider).patientDocumentViewUrl(documentId: document.id)).data!;
      if (!context.mounted) return;
      final url = fileUrl(ref.read(appConfigProvider), link.url);
      if (link.mime.startsWith('image/')) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => DocumentImageScreen(title: document.title, url: url),
          ),
        );
      } else {
        showSnack(context, l10n.openInPhone);
        final opened = await ref.read(documentOpenerProvider).openPdf(url: url, documentId: document.id);
        if (!opened && context.mounted) showSnack(context, l10n.cannotOpen);
      }
    } catch (e) {
      if (context.mounted) showSnack(context, patientErrorMessage(l10n, e));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = WWLocalizations.of(context);
    final ok = await confirmDanger(
      context,
      title: l10n.deleteDocumentTitle,
      body: l10n.deleteDocumentBody,
      action: l10n.delete,
    );
    if (!ok || !context.mounted) return;
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container.read(patientApiProvider).patientDocumentDelete(documentId: document.id);
      documentsChanged(container, memberId: document.memberId);
    } catch (e) {
      if (context.mounted) showSnack(context, patientErrorMessage(l10n, e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final isPdf = document.mime == 'application/pdf';
    final isNote = document.type == 'CARE_NOTE';
    final details = [
      documentTypeLabel(l10n, document.type),
      if (document.date != null) formatDate(context, document.date!),
      if (showMember) document.memberName,
    ].join(' · ');
    return WWCard(
      key: Key('document-${document.id}'),
      onTap: () => _view(context, ref),
      padding: const EdgeInsets.symmetric(horizontal: WWSpacing.md, vertical: WWSpacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isPdf ? WWColors.danger : (isNote ? WWColors.brandGreen : WWColors.primary)).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(WWRadius.button),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_outlined : (isNote ? Icons.note_alt_outlined : Icons.image_outlined),
              color: isPdf ? WWColors.danger : (isNote ? WWColors.brandGreen : WWColors.primary),
            ),
          ),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(document.title, style: WWType.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(details, style: WWType.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          TextButton(onPressed: () => _view(context, ref), child: Text(l10n.view)),
          PopupMenuButton<String>(
            key: Key('document-menu-${document.id}'),
            onSelected: (_) => _delete(context, ref),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: Text(l10n.delete, style: const TextStyle(color: WWColors.danger)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A nurse's care note (§6.11): what was done, and the vitals if taken.
class CareNoteSheet extends StatelessWidget {
  const CareNoteSheet({super.key, required this.document});

  final PatientDocumentOut document;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final v = document.vitals ?? const <String, Object>{};
    final vitals = [
      if (v['bp'] != null && '${v['bp']}'.isNotEmpty) '${l10n.bpShort}: ${v['bp']}',
      if (v['pulse'] != null) '${l10n.pulseLabel}: ${v['pulse']}',
      if (v['temperature_f'] != null) '${l10n.temperatureLabel}: ${v['temperature_f']}',
      if (v['spo2'] != null) '${l10n.spo2Label}: ${v['spo2']}',
      if (v['sugar'] != null) '${l10n.sugarLabel}: ${v['sugar']}',
    ];
    return Padding(
      key: const Key('care-note-sheet'),
      padding: const EdgeInsets.fromLTRB(WWSpacing.screen, 0, WWSpacing.screen, WWSpacing.xl),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(document.title, style: WWType.screenTitle),
            Text(
              [
                if (document.date != null) formatDate(context, document.date!),
                document.memberName,
                l10n.careNoteBy,
              ].join(' · '),
              style: WWType.caption,
            ),
            const SizedBox(height: WWSpacing.md),
            Text(document.text ?? '', style: WWType.body),
            if (vitals.isNotEmpty) ...[
              const SizedBox(height: WWSpacing.lg),
              Text(l10n.vitalsLine, style: WWType.section),
              const SizedBox(height: WWSpacing.xs),
              for (final line in vitals) Text(line, style: WWType.body),
            ],
          ],
        ),
      ),
    );
  }
}

/// A photo document, full screen with pinch to zoom. The link works for 5 minutes.
class DocumentImageScreen extends StatelessWidget {
  const DocumentImageScreen({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: WWType.section.copyWith(color: Colors.white)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: Image.network(
            url,
            errorBuilder: (_, _, _) => Text(l10n.cannotOpen, style: const TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

/// Upload sheet: for whom, type, name, optional date, then camera / gallery / PDF.
Future<void> showUploadDocumentSheet(BuildContext context, {String? memberId}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => UploadDocumentSheet(memberId: memberId),
  );
}

/// The app's own size limit (the server checks too), so a too-big file is refused before it
/// is sent.
const maxDocumentBytes = 10 * 1024 * 1024;

class UploadDocumentSheet extends ConsumerStatefulWidget {
  const UploadDocumentSheet({super.key, this.memberId});

  final String? memberId;

  @override
  ConsumerState<UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends ConsumerState<UploadDocumentSheet> {
  final _title = TextEditingController();
  String? _memberId;
  PatientDocumentInTypeEnum? _type;
  DateTime? _date;
  PickedFile? _file;
  double? _progress;
  bool _submitted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _memberId = widget.memberId;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _pick(PickSource source) async {
    final l10n = WWLocalizations.of(context);
    final file = await ref.read(filePickerProvider).pick(source);
    if (file == null || !mounted) return;
    setState(() {
      final tooBig = file.bytes.length > maxDocumentBytes;
      _file = tooBig ? null : file;
      _error = tooBig ? l10n.errFileTooLarge : null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 50),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _upload(String memberId) async {
    final l10n = WWLocalizations.of(context);
    setState(() => _submitted = true);
    if (_type == null || _title.text.trim().isEmpty || _file == null) return;
    setState(() {
      _progress = 0;
      _error = null;
    });
    // Refresh through the container: the lists must update even if the sheet was closed.
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(documentUploaderProvider)
          .upload(
            file: _file!,
            memberId: memberId,
            type: _type!,
            title: _title.text.trim(),
            date: _date,
            onProgress: (p) {
              if (mounted) setState(() => _progress = p);
            },
          );
      documentsChanged(container, memberId: memberId);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _progress = null;
          _error = patientErrorMessage(l10n, e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final members = ref.watch(membersProvider).unwrapPrevious().value ?? const <MemberOut>[];
    final memberId = _memberId ?? members.firstOrNull?.id;
    final busy = _progress != null;
    final types = [
      (PatientDocumentInTypeEnum.PRESCRIPTION, l10n.docTypePrescription),
      (PatientDocumentInTypeEnum.LAB_REPORT, l10n.docTypeLabReport),
      (PatientDocumentInTypeEnum.SCAN, l10n.docTypeScan),
      (PatientDocumentInTypeEnum.DISCHARGE, l10n.docTypeDischarge),
      (PatientDocumentInTypeEnum.ID, l10n.docTypeId),
      (PatientDocumentInTypeEnum.OTHER, l10n.docTypeOther),
    ];
    // Not closed by back or a tap outside while the file is being sent.
    return PopScope(
      canPop: !busy,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.uploadDocument, style: WWType.section),
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.forWhom),
              WWChoicePills<String>(
                key: const Key('upload-member'),
                choices: [
                  for (final m in members)
                    WWChoice(value: m.id, label: m.isSelf ? l10n.relationSelf : m.fullName.split(' ').first),
                ],
                selected: memberId,
                onSelected: (id) => setState(() => _memberId = id),
              ),
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.documentType),
              WWChoicePills<PatientDocumentInTypeEnum>(
                key: const Key('upload-type'),
                choices: [for (final (value, label) in types) WWChoice(value: value, label: label)],
                selected: _type,
                onSelected: (t) => setState(() => _type = t),
                errorText: _submitted && _type == null ? l10n.fixMarkedFields : null,
              ),
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.documentTitle),
              WWTextField(
                key: const Key('upload-title'),
                controller: _title,
                hint: l10n.documentTitleHint,
                maxLength: 80,
                errorText: _submitted && _title.text.trim().isEmpty ? l10n.titleRequired : null,
                onChanged: (_) => setState(() {}),
              ),
              WWFieldLabel(l10n.documentDate),
              WWDateField(
                text: _date == null ? null : formatDate(context, _date!),
                placeholder: l10n.selectDate,
                onTap: _pickDate,
              ),
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.chooseFile),
              if (_file != null) ...[_FilePreview(file: _file!), const SizedBox(height: WWSpacing.sm)],
              Row(
                children: [
                  for (final (source, icon, label) in [
                    (PickSource.camera, Icons.photo_camera_outlined, l10n.takePhoto),
                    (PickSource.gallery, Icons.photo_library_outlined, l10n.chooseFromGallery),
                    (PickSource.pdf, Icons.picture_as_pdf_outlined, l10n.choosePdf),
                  ])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: OutlinedButton(
                          key: Key('upload-${source.name}'),
                          onPressed: busy ? null : () => _pick(source),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                          child: Column(
                            children: [
                              Icon(icon, color: WWColors.primary),
                              const SizedBox(height: 4),
                              Text(label, textAlign: TextAlign.center, style: WWType.caption),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (_submitted && _file == null)
                Padding(
                  padding: const EdgeInsets.only(top: WWSpacing.xs),
                  child: Text(l10n.fileRequired, style: WWType.caption.copyWith(color: WWColors.danger)),
                ),
              if (busy) ...[
                const SizedBox(height: WWSpacing.lg),
                LinearProgressIndicator(value: _progress == 0 ? null : _progress),
                const SizedBox(height: WWSpacing.xs),
                Text('${l10n.uploading} ${((_progress ?? 0) * 100).round()}%', style: WWType.caption),
              ],
              if (_error != null) ...[
                const SizedBox(height: WWSpacing.lg),
                WWMessageBox(message: _error!, isError: true),
              ],
              const SizedBox(height: WWSpacing.xl),
              WWPrimaryButton(
                key: const Key('upload-save'),
                label: l10n.upload,
                loading: busy,
                onPressed: memberId == null ? null : () => _upload(memberId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  const _FilePreview({required this.file});

  final PickedFile file;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final isPdf = file.mime == 'application/pdf';
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(WWRadius.button),
          child: isPdf
              ? Container(
                  width: 56,
                  height: 56,
                  color: WWColors.tint,
                  child: const Icon(Icons.picture_as_pdf_outlined, color: WWColors.danger),
                )
              : Image.memory(file.bytes, width: 56, height: 56, fit: BoxFit.cover),
        ),
        const SizedBox(width: WWSpacing.md),
        Expanded(child: Text('${l10n.fileChosen} · ${formatBytes(file.bytes.length)}', style: WWType.body)),
        const Icon(Icons.check_circle, color: WWColors.brandGreen),
      ],
    );
  }
}

/// Medical documents tab with an optional member filter from the URL (`?member=`).
class DocumentsTab extends StatelessWidget {
  const DocumentsTab({super.key, required this.state});

  final GoRouterState state;

  @override
  Widget build(BuildContext context) => DocumentsScreen(
    key: ValueKey(state.uri.queryParameters['member']),
    memberId: state.uri.queryParameters['member'],
  );
}
