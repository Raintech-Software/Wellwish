import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

import '../config/app_config.dart';

/// Error reports to Sentry (ARCHITECTURE §12, §13; PHASES 9.5). Off unless the build has a DSN:
/// `--dart-define=SENTRY_DSN=https://…`. Errors only (no performance tracing), no user or device
/// ids, and every text is masked like the server's logs: phone numbers, tokens, codes, 12-digit
/// (Aadhaar) numbers. Obfuscated builds need their symbols uploaded to Sentry to show readable
/// stack traces (`build\symbols\…`, Phase 10).
///
/// The pure-Dart `sentry` package, not `sentry_flutter`: that one's Android part needs Android 8+
/// (minSdk 26, the apps support 7+). Every Flutter and Dart error is caught; a crash inside
/// native Android code is not.
const sentryDsn = String.fromEnvironment('SENTRY_DSN');

Future<void> runMonitored(Flavor flavor, void Function() appRunner) async {
  if (sentryDsn.isEmpty) {
    appRunner();
    return;
  }
  try {
    await _start(flavor);
  } catch (_) {
    // a bad DSN must never keep the app from starting: it just runs without error reports
  }
  appRunner();
}

Future<void> _start(Flavor flavor) async {
  await Sentry.init((options) {
    options
      ..dsn = sentryDsn
      ..environment = flavor.name
      ..sendDefaultPii = false
      ..tracesSampleRate = 0
      ..beforeSend = scrubEvent
      ..beforeBreadcrumb = scrubBreadcrumb;
  });
  final flutterErrors = FlutterError.onError;
  FlutterError.onError = (details) {
    unawaited(Sentry.captureException(details.exception, stackTrace: details.stack));
    flutterErrors?.call(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    unawaited(Sentry.captureException(error, stackTrace: stack));
    return false; // still printed as usual
  };
}

final _token = RegExp(r'eyJ[\w-]{4,}\.[\w-]{4,}\.[\w-]{4,}');
final _bearer = RegExp(r'bearer\s+[\w.~+/=-]{8,}', caseSensitive: false);
final _code = RegExp(r'\b(otp|code|pin)(\W{0,3})\d{4,8}\b', caseSensitive: false);
final _phone = RegExp(r'(?<![\w-])(?:\+?91[\s-]?|0)?[6-9]\d{4}[\s-]?\d{5}(?![\w-])');
final _aadhaar = RegExp(r'(?<![\d-])\d{4}[ -]?\d{4}[ -]?\d{4}(?![\d-])');

/// The same mask as the server's `common/redact.py`.
String redact(String text) => text
    .replaceAll(_token, '[token]')
    .replaceAll(_bearer, '[token]')
    .replaceAllMapped(_code, (m) => '${m[1]}${m[2]}[code]')
    // phones first: "+91 98765 43210" is 12 digits too
    .replaceAllMapped(_phone, (m) {
      final digits = m[0]!.replaceAll(RegExp(r'\D'), '');
      return '[phone …${digits.substring(digits.length - 4)}]';
    })
    .replaceAll(_aadhaar, '[number]');

FutureOr<SentryEvent?> scrubEvent(SentryEvent event, Hint hint) {
  event
    ..user = null
    ..request = null;
  final message = event.message;
  if (message != null) {
    message
      ..formatted = redact(message.formatted)
      ..template = message.template == null ? null : redact(message.template!)
      ..params = const [];
  }
  for (final e in event.exceptions ?? <SentryException>[]) {
    if (e.value != null) e.value = redact(e.value!);
  }
  for (final crumb in event.breadcrumbs ?? <Breadcrumb>[]) {
    scrubBreadcrumb(crumb, Hint());
  }
  return event;
}

Breadcrumb? scrubBreadcrumb(Breadcrumb? crumb, Hint hint) {
  if (crumb == null) return null;
  if (crumb.message != null) crumb.message = redact(crumb.message!);
  crumb.data = crumb.data?.map((k, v) => MapEntry(k, _redactAll(v)));
  return crumb;
}

/// Every text inside, however deep (lists, maps).
Object? _redactAll(Object? value) => switch (value) {
  String() => redact(value),
  List() => [for (final v in value) _redactAll(v)],
  Map() => {for (final e in value.entries) e.key: _redactAll(e.value)},
  _ => value,
};
