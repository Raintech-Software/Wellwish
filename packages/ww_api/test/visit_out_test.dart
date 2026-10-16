import 'package:test/test.dart';
import 'package:ww_api/ww_api.dart';

// tests for VisitOut
void main() {
  final VisitOut? instance = /* VisitOut(...) */ null;
  // TODO add properties to the entity

  group(VisitOut, () {
    // Every step of this visit type, in order
    // List<String> steps
    test('to test the property `steps`', () async {
      // TODO
    });

    // List<StepDoneOut> done
    test('to test the property `done`', () async {
      // TODO
    });

    // String currentStep
    test('to test the property `currentStep`', () async {
      // TODO
    });

    // String nextStep
    test('to test the property `nextStep`', () async {
      // TODO
    });

    // The step that needs the job OTP
    // String otpStep
    test('to test the property `otpStep`', () async {
      // TODO
    });

    // After 4 wrong codes: the next try from then (5, 10, 20 min…)
    // DateTime otpRetryAt
    test('to test the property `otpRetryAt`', () async {
      // TODO
    });

    // From then, 'patient not available' (after a call attempt)
    // DateTime noShowReadyAt
    test('to test the property `noShowReadyAt`', () async {
      // TODO
    });

    // int balanceCollectedPaise
    test('to test the property `balanceCollectedPaise`', () async {
      // TODO
    });

    // String balanceMode
    test('to test the property `balanceMode`', () async {
      // TODO
    });

  });
}
