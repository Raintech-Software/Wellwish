import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for PartnerMeOut
void main() {
  final PartnerMeOut? instance = /* PartnerMeOut(...) */ null;
  // TODO add properties to the entity

  group(PartnerMeOut, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String phone
    test('to test the property `phone`', () async {
      // TODO
    });

    // String language
    test('to test the property `language`', () async {
      // TODO
    });

    // null until the partner registers (Phase 3)
    // String partnerStatus
    test('to test the property `partnerStatus`', () async {
      // TODO
    });

    // String role
    test('to test the property `role`', () async {
      // TODO
    });

    // §6.19: a TEMPORARY partner's one booking (the app opens only this job)
    // String temporaryBookingId
    test('to test the property `temporaryBookingId`', () async {
      // TODO
    });

    // Today's selfie is taken (India date): a TEMPORARY partner's app asks first
    // bool selfieToday (default value: false)
    test('to test the property `selfieToday`', () async {
      // TODO
    });

    // Partner Terms and Privacy Policy not accepted in their current version (§6.20): the app shows the consent screen first
    // List<ConsentNeededOut> consentsNeeded
    test('to test the property `consentsNeeded`', () async {
      // TODO
    });

  });
}
