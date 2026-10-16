import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for AuthApi
void main() {
  final instance = WwApi().getAuthApi();

  group(AuthApi, () {
    // Google
    //
    // Patient app only. PHONE_REQUIRED: verify a phone by OTP and send `googleLinkToken` along.
    //
    //Future<GoogleOut> authGoogle(GoogleIn googleIn) async
    test('test authGoogle', () async {
      // TODO
    });

    // Logout
    //
    //Future<OkOut> authLogout() async
    test('test authLogout', () async {
      // TODO
    });

    // Logout All
    //
    // Log out on every device for this app.
    //
    //Future<OkOut> authLogoutAll() async
    test('test authLogoutAll', () async {
      // TODO
    });

    // Otp Send
    //
    // Send a 6-digit login code by SMS (§6.2).
    //
    //Future<OtpSendOut> authOtpSend(OtpSendIn otpSendIn) async
    test('test authOtpSend', () async {
      // TODO
    });

    // Otp Verify
    //
    // Check the code and log in. Patients get a profile and a SELF member on first login.
    //
    //Future<TokenOut> authOtpVerify(OtpVerifyIn otpVerifyIn) async
    test('test authOtpVerify', () async {
      // TODO
    });

    // Refresh
    //
    // Swap a refresh token for new tokens. Each refresh token works once.
    //
    //Future<TokenOut> authRefresh(RefreshIn refreshIn) async
    test('test authRefresh', () async {
      // TODO
    });

  });
}
