import 'package:dio/dio.dart';
import 'package:ww_api/ww_api.dart';

import '../api/api_client.dart';
import '../storage/device_id_store.dart';
import 'session_manager.dart';

/// Which app is logging in: patient app (`login`) or partner app (`partner_primary`).
enum LoginApp { patient, partner }

/// Phone OTP login, Google sign-in (patients) and logout, on top of the generated client.
/// Every failure is thrown as an `ApiException` (see `toApiException`).
class AuthRepository {
  AuthRepository({required Dio dio, required this.session, required this.deviceIds, required this.app})
    : _api = AuthApi(dio);

  final AuthApi _api;
  final SessionManager session;
  final DeviceIdStore deviceIds;
  final LoginApp app;

  OtpSendInPurposeEnum get _sendPurpose =>
      app == LoginApp.patient ? OtpSendInPurposeEnum.login : OtpSendInPurposeEnum.partnerPrimary;

  OtpVerifyInPurposeEnum get _verifyPurpose =>
      app == LoginApp.patient ? OtpVerifyInPurposeEnum.login : OtpVerifyInPurposeEnum.partnerPrimary;

  /// Sends the SMS code. [phone] is the 10-digit number (the server adds +91).
  /// [appHash] is the Android SMS Retriever hash so the app can read the SMS by itself.
  Future<OtpSendOut> sendOtp(String phone, {String appHash = ''}) async {
    try {
      final response = await _api.authOtpSend(
        otpSendIn: OtpSendIn(
          phone: phone,
          purpose: _sendPurpose,
          deviceId: await deviceIds.deviceId(),
          appHash: appHash,
        ),
      );
      return response.data!;
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Checks the code and saves the tokens. Returns true for a brand-new account, which starts
  /// in [language] (the app's language at login: the phone's, when it's English, Hindi or Odia).
  Future<bool> verifyOtp(String phone, String code, {String? googleLinkToken, String? language}) async {
    try {
      final response = await _api.authOtpVerify(
        otpVerifyIn: OtpVerifyIn(
          phone: phone,
          otp: code,
          purpose: _verifyPurpose,
          deviceId: await deviceIds.deviceId(),
          googleLinkToken: googleLinkToken,
          language: OtpVerifyInLanguageEnum.values.where((l) => l.value == language).firstOrNull,
        ),
      );
      final tokens = response.data!;
      await session.save(tokens);
      return tokens.isNewUser ?? false;
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Patient app only. Returns null when logged in, or a link token when the phone still has
  /// to be verified by OTP (pass it to [verifyOtp]).
  Future<String?> signInWithGoogle(String idToken) async {
    try {
      final response = await _api.authGoogle(
        googleIn: GoogleIn(idToken: idToken, deviceId: await deviceIds.deviceId()),
      );
      final body = response.data!;
      if (body.status == GoogleOutStatusEnum.LOGGED_IN && body.tokens != null) {
        await session.save(body.tokens!);
        return null;
      }
      return body.googleLinkToken;
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Ends the session on the server (best effort) and on the phone.
  Future<void> logout({bool everywhere = false}) async {
    try {
      if (everywhere) {
        await _api.authLogoutAll();
      } else {
        await _api.authLogout();
      }
    } catch (_) {
      // Offline or already logged out: forget the tokens anyway.
    }
    await session.end(SessionEndReason.loggedOut);
  }
}
