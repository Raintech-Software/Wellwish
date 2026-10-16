import 'package:flutter_test/flutter_test.dart';
import 'package:sentry/sentry.dart';
import 'package:ww_core/ww_core.dart';

/// Sentry gets no phone numbers, tokens or codes (ARCHITECTURE §12; the same mask as the server).
void main() {
  test('the mask', () {
    expect(redact('login +91 98765 43210 ok'), 'login [phone …3210] ok');
    expect(redact('GET /v1/admin/patients?q=9876543210'), 'GET /v1/admin/patients?q=[phone …3210]');
    expect(redact('otp 123456 sent'), 'otp [code] sent');
    expect(redact('Authorization: Bearer abcdefghijklmnop'), 'Authorization: [token]');
    expect(redact('token eyJhbGciOi.eyJzdWIiOi.c2lnbmF0dXJl'), 'token [token]');
    expect(redact('aadhaar 2345 6789 1234'), 'aadhaar [number]');
    // left alone: ids, dates, amounts
    const id = 'booking e22a74ba-80e3-49c7-b0c2-fd0873dde871';
    expect(redact(id), id);
    expect(redact('paid 10000 paise at 2026-10-13 10:00:00'), 'paid 10000 paise at 2026-10-13 10:00:00');
  });

  test('events and breadcrumbs are masked before they leave the phone', () async {
    final event = SentryEvent(
      message: SentryMessage('No user +919876543210', params: ['+919876543210']),
      exceptions: [SentryException(type: 'ApiException', value: 'otp 123456 wrong for 9876543210')],
      breadcrumbs: [
        Breadcrumb(message: 'call 98765 43210', data: {'url': '/v1/x?phone=9876543210', 'n': 3}),
      ],
    );
    final out = (await scrubEvent(event, Hint()))!;
    final text = [
      out.message!.formatted,
      ...?out.message!.params,
      out.exceptions!.single.value,
      out.breadcrumbs!.single.message,
      out.breadcrumbs!.single.data.toString(),
    ].join(' ');
    expect(text, isNot(contains('9876543210')));
    expect(text, isNot(contains('43210 ')));
    expect(text, isNot(contains('123456')));
    expect(out.breadcrumbs!.single.data!['n'], 3);
  });

  test('without a DSN the app just runs (Sentry off)', () async {
    var ran = false;
    await runMonitored(Flavor.dev, () => ran = true);
    expect(sentryDsn, isEmpty);
    expect(ran, isTrue);
  });
}
