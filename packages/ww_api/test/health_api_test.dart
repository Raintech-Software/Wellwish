import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';


/// tests for HealthApi
void main() {
  final instance = WwApi().getHealthApi();

  group(HealthApi, () {
    // Service health
    //
    //Future<HealthOut> health() async
    test('test health', () async {
      // TODO
    });

  });
}
