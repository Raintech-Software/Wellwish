import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

/// Reads the login code from the SMS on Android (SMS Retriever API, ARCHITECTURE §6.2), so
/// the user doesn't have to type it. iOS fills it from the keyboard (one-time-code autofill).
abstract class SmsCodeReader {
  /// The hash the server appends to the SMS so Android hands it to this app. '' if unknown.
  Future<String> appHash();

  /// Waits for the SMS (up to 5 minutes) and returns the 6-digit code, or null.
  Future<String?> waitForCode();

  Future<void> stop();
}

class SmartAuthSmsCodeReader implements SmsCodeReader {
  bool get _android => !kIsWeb && Platform.isAndroid;

  @override
  Future<String> appHash() async {
    if (!_android) return '';
    final result = await SmartAuth.instance.getAppSignature();
    return result.data ?? '';
  }

  @override
  Future<String?> waitForCode() async {
    if (!_android) return null;
    final result = await SmartAuth.instance.getSmsWithRetrieverApi(matcher: r'\d{6}');
    return result.data?.code;
  }

  @override
  Future<void> stop() async {
    if (!_android) return;
    await SmartAuth.instance.removeSmsRetrieverApiListener();
  }
}

/// For tests: never reads anything.
class NoSmsCodeReader implements SmsCodeReader {
  const NoSmsCodeReader();

  @override
  Future<String> appHash() async => '';

  @override
  Future<String?> waitForCode() async => null;

  @override
  Future<void> stop() async {}
}
