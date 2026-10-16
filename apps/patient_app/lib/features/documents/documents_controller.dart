import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../family/family_controller.dart';

/// Which documents a list shows: the tab (`reports` / `prescriptions`, null = all) and the
/// family member (null = everyone).
typedef DocumentQuery = ({String? group, String? memberId});

class DocumentsPage {
  const DocumentsPage({required this.items, required this.count, required this.page});

  final List<PatientDocumentOut> items;
  final int count;
  final int page;

  bool get hasMore => items.length < count;
}

/// P21 list, newest first, 20 at a time.
class DocumentsController extends AsyncNotifier<DocumentsPage> {
  DocumentsController(this.query);

  final DocumentQuery query;
  static const pageSize = 20;

  Future<DocumentsPage> _load(int page) async {
    final data =
        (await ref
                .read(patientApiProvider)
                .patientDocumentList(memberId: query.memberId, group: query.group, page: page, pageSize: pageSize))
            .data!;
    return DocumentsPage(items: data.items, count: data.count, page: page);
  }

  @override
  Future<DocumentsPage> build() => _load(1);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) return;
    final next = await _load(current.page + 1);
    state = AsyncData(DocumentsPage(items: [...current.items, ...next.items], count: next.count, page: next.page));
  }
}

final documentsProvider = AsyncNotifierProvider.autoDispose.family<DocumentsController, DocumentsPage, DocumentQuery>(
  DocumentsController.new,
);

/// How much of the account's 200 MB is used.
final documentStorageProvider = FutureProvider.autoDispose<DocumentStorageOut>(
  (ref) async => (await ref.watch(patientApiProvider).patientDocumentStorage()).data!,
);

/// After an upload, a delete or a removed member: every list, the storage line and the member
/// counts change. Takes the container (not a WidgetRef), so it still works when the screen that
/// started the change has closed meanwhile.
void documentsChanged(ProviderContainer container, {String? memberId}) {
  container.invalidate(documentsProvider);
  container.invalidate(documentStorageProvider);
  if (memberId != null) container.invalidate(memberDetailProvider(memberId));
  container.read(membersProvider.notifier).reload();
}

final documentOpenerProvider = Provider<DocumentOpener>((ref) => DevicePdfOpener(ref.watch(uploadHttpProvider)));

/// Upload flow (§6.8): upload URL (checks the 200 MB), PUT the file, then save it.
Future<PatientDocumentOut> uploadDocument(
  Ref ref, {
  required PickedFile file,
  required String memberId,
  required PatientDocumentInTypeEnum type,
  required String title,
  DateTime? date,
  void Function(double progress)? onProgress,
}) async {
  final api = ref.read(patientApiProvider);
  final ticket = (await api.patientDocumentUploadUrl(
    documentUploadUrlIn: DocumentUploadUrlIn(
      type: DocumentUploadUrlInTypeEnum.values.firstWhere((t) => t.value == type.value),
      mime: file.mime,
      sizeBytes: file.bytes.length,
    ),
  )).data!;
  await sendUpload(
    ref.read(uploadHttpProvider),
    ref.read(appConfigProvider),
    ticket.uploadUrl,
    ticket.uploadFields,
    file,
    onProgress: onProgress,
  );
  return (await api.patientDocumentAdd(
    patientDocumentIn: PatientDocumentIn(
      fileKey: ticket.fileKey,
      memberId: memberId,
      type: type,
      title: title,
      date: date == null ? null : DateTime(date.year, date.month, date.day),
    ),
  )).data!;
}

final documentUploaderProvider = Provider<DocumentUploader>((ref) => DocumentUploader(ref));

class DocumentUploader {
  DocumentUploader(this._ref);

  final Ref _ref;

  Future<PatientDocumentOut> upload({
    required PickedFile file,
    required String memberId,
    required PatientDocumentInTypeEnum type,
    required String title,
    DateTime? date,
    void Function(double progress)? onProgress,
  }) => uploadDocument(
    _ref,
    file: file,
    memberId: memberId,
    type: type,
    title: title,
    date: date,
    onProgress: onProgress,
  );
}
