import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../session/session_controller.dart';
import 'device_tools.dart';

/// The partner's registration and verification state (GET /v1/partner/kyc/status): profile,
/// steps, documents and the review. Every action returns the new state; the partner status in
/// the session is updated too, so the router moves to the right screen (§6.3).
class RegistrationController extends AsyncNotifier<KycStatusOut?> {
  PartnerApi get _api => ref.read(partnerApiProvider);

  @override
  Future<KycStatusOut?> build() async {
    // a temporary partner (§6.19) has no registration to load; one whose job is over hasn't
    // chosen a role yet, like anyone who isn't registered
    final registered = ref.watch(
      sessionProvider.select((s) => !isUnregistered(s.me?.partnerStatus) && !isTemporary(s.me?.partnerStatus)),
    );
    if (!registered) return null; // no role chosen yet: nothing to load
    return (await _api.partnerKycStatus()).data;
  }

  KycStatusOut? get current => state.value;

  Future<void> refresh() async {
    final fresh = (await _api.partnerKycStatus()).data!;
    _apply(fresh);
  }

  void _apply(KycStatusOut status) {
    state = AsyncData(status);
    ref.read(sessionProvider.notifier).partnerChanged(status.profile.status, status.profile.role);
  }

  Future<void> start(StartInRoleEnum role) async {
    _apply((await _api.partnerRegisterStart(startIn: StartIn(role: role))).data!);
  }

  Future<OtpSendOut> sendAlternate(String phone) async =>
      (await _api.partnerAlternatePhoneSend(phoneIn: PhoneIn(phone: phone))).data!;

  Future<void> verifyAlternate(String code) async {
    _apply((await _api.partnerAlternatePhoneVerify(codeIn: CodeIn(code: code))).data!);
  }

  Future<EmailSentOut> sendEmail(String email) async =>
      (await _api.partnerEmailSend(emailIn: EmailIn(email: email))).data!;

  Future<void> verifyEmail(String code) async {
    _apply((await _api.partnerEmailVerify(codeIn: CodeIn(code: code))).data!);
  }

  Future<void> saveProfile(ProfileIn profile) async {
    _apply((await _api.partnerProfileSave(profileIn: profile)).data!);
  }

  Future<String> uploadPhoto(PickedFile file) =>
      ref.read(uploaderProvider).upload(PartnerUploadUrlInPurposeEnum.partnerPhoto, file);

  /// Upload a document file, then attach it with its number and expiry date.
  Future<void> addDocument({
    required String docType,
    required PickedFile file,
    String number = '',
    DateTime? expiresOn,
  }) async {
    final key = await ref.read(uploaderProvider).upload(PartnerUploadUrlInPurposeEnum.kycDocument, file);
    final status = (await _api.partnerKycDocumentAdd(
      documentIn: DocumentIn(docType: docType, fileKey: key, number: number, expiresOn: expiresOn),
    )).data!;
    _apply(status);
  }

  Future<void> submit() async {
    _apply((await _api.partnerKycSubmit()).data!);
  }
}

final registrationProvider = AsyncNotifierProvider<RegistrationController, KycStatusOut?>(RegistrationController.new);
