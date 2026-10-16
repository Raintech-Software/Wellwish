import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../session/session_controller.dart';

/// You and your family members (P22), yourself first (ARCHITECTURE §6.18).
class MembersController extends AsyncNotifier<List<MemberOut>> {
  PatientApi get _api => ref.read(patientApiProvider);

  @override
  Future<List<MemberOut>> build() async {
    // Another account logged in (or none): start again, never show the last person's family.
    ref.watch(sessionProvider.select((s) => s.me?.id));
    return (await ref.watch(patientApiProvider).patientMemberList()).data!;
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(() async => (await _api.patientMemberList()).data!);
  }

  Future<MemberOut> add(MemberIn member) async {
    final saved = (await _api.patientMemberAdd(memberIn: member)).data!;
    await reload();
    return saved;
  }

  Future<MemberOut> save(String id, MemberIn member) async {
    final saved = (await _api.patientMemberUpdate(memberId: id, memberIn: member)).data!;
    ref.invalidate(memberDetailProvider(id));
    // Your own name, date of birth and gender are also the profile: the greeting, the profile
    // header and the language setting must use the new ones.
    if (saved.isSelf) await ref.read(sessionProvider.notifier).reloadMe();
    await reload();
    return saved;
  }

  /// [deleteDocuments]: also delete their medical documents (§6.18).
  Future<void> remove(String id, {bool deleteDocuments = false}) async {
    await _api.patientMemberRemove(memberId: id, deleteDocuments: deleteDocuments);
    await reload();
  }

  /// Photo for a member: upload first, then save the member with the returned key.
  Future<String> uploadPhoto(PickedFile file) async {
    final ticket = (await _api.patientMemberPhotoUploadUrl(
      memberPhotoUrlIn: MemberPhotoUrlIn(mime: file.mime, sizeBytes: file.bytes.length),
    )).data!;
    await sendUpload(
      ref.read(uploadHttpProvider),
      ref.read(appConfigProvider),
      ticket.uploadUrl,
      ticket.uploadFields,
      file,
    );
    return ticket.fileKey;
  }
}

final membersProvider = AsyncNotifierProvider<MembersController, List<MemberOut>>(MembersController.new);

/// One member with their addresses and latest documents (P29).
final memberDetailProvider = FutureProvider.autoDispose.family<MemberDetailOut, String>(
  (ref, id) async => (await ref.watch(patientApiProvider).patientMemberGet(memberId: id)).data!,
);
