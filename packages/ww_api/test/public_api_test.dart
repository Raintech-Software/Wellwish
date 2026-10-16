import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for PublicApi
void main() {
  final instance = WwApi().getPublicApi();

  group(PublicApi, () {
    // App Config
    //
    // Minimum app versions (force update), store links, support number, refund %, account deletion waiting time, the legal pages and the account deletion page (§6.20).
    //
    //Future<AppConfigOut> publicAppConfig() async
    test('test publicAppConfig', () async {
      // TODO
    });

    // List Services
    //
    // Active services in display order, with the price, the booking fee paid online and the balance paid to the partner. `?partnerType=NURSE` for the Book a Nurse list.
    //
    //Future<List<ServiceOut>> publicServices({ String partnerType }) async
    test('test publicServices', () async {
      // TODO
    });

    // Shared Trip
    //
    // The secret comes in a header, never in the URL (so it isn't logged). 404 once the link expired or the visit ended.
    //
    //Future<PublicTrackOut> publicSharedTrip(String xShareToken) async
    test('test publicSharedTrip', () async {
      // TODO
    });

    // List Specialities
    //
    //Future<List<SpecialityOut>> publicSpecialities() async
    test('test publicSpecialities', () async {
      // TODO
    });

  });
}
