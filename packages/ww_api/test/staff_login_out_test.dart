import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for StaffLoginOut
void main() {
  final StaffLoginOut? instance = /* StaffLoginOut(...) */ null;
  // TODO add properties to the entity

  group(StaffLoginOut, () {
    // TOTP_SETUP: first login, show the QR code. TOTP: ask for the code. SIGNED_IN: a trusted browser (v2.16), the tokens below.
    // String step
    test('to test the property `step`', () async {
      // TODO
    });

    // Empty when SIGNED_IN
    // String challengeToken (default value: '')
    test('to test the property `challengeToken`', () async {
      // TODO
    });

    // Only for TOTP_SETUP: encode as QR code
    // String otpauthUri
    test('to test the property `otpauthUri`', () async {
      // TODO
    });

    // Only for TOTP_SETUP: for typing in by hand
    // String secret
    test('to test the property `secret`', () async {
      // TODO
    });

    // Only for SIGNED_IN
    // StaffTokenOut signedIn
    test('to test the property `signedIn`', () async {
      // TODO
    });

  });
}
