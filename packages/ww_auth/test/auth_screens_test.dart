import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

/// path → responses in order (the last one repeats). Records request bodies.
class _FakeServer implements HttpClientAdapter {
  _FakeServer(this.script);

  final Map<String, List<(int, Object)>> script;
  final bodies = <String, List<Map<String, dynamic>>>{};

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream,
      Future<void>? cancelFuture) async {
    final data = options.data;
    bodies.putIfAbsent(options.path, () => []).add(
          data is String ? jsonDecode(data) as Map<String, dynamic> : <String, dynamic>{},
        );
    final queue = script[options.path]!;
    final (status, body) = queue.length > 1 ? queue.removeAt(0) : queue.first;
    return ResponseBody.fromString(jsonEncode(body), status, headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    });
  }

  @override
  void close({bool force = false}) {}
}

class _FakeSms implements SmsCodeReader {
  final code = Completer<String?>();

  @override
  Future<String> appHash() async => 'AbCdEfGhIjK';

  @override
  Future<String?> waitForCode() => code.future;

  @override
  Future<void> stop() async {}
}

const _tokens = {'accessToken': 'a', 'refreshToken': 'r', 'expiresIn': 900, 'isNewUser': true};

(AuthRepository, _FakeServer, InMemoryTokenStorage) _repo(
  Map<String, List<(int, Object)>> script, {
  LoginApp app = LoginApp.patient,
}) {
  final config = AppConfig.forFlavor(Flavor.dev);
  final server = _FakeServer(script);
  final tokens = InMemoryTokenStorage();
  final session = SessionManager(tokens: tokens, refreshDio: createRefreshClient(config));
  final dio = createApiClient(config, session: session)..httpClientAdapter = server;
  return (
    AuthRepository(
      dio: dio,
      session: session,
      deviceIds: const FixedDeviceIdStore('device-0001'),
      app: app,
    ),
    server,
    tokens,
  );
}

Widget _app(Widget child) => MaterialApp(
      theme: WWTheme.light(),
      localizationsDelegates: WWLocalizations.localizationsDelegates,
      supportedLocales: WWLocalizations.supportedLocales,
      home: child,
    );

void main() {
  group('PhoneLoginScreen', () {
    testWidgets('rejects a number that is not an Indian mobile', (tester) async {
      final (repo, server, _) = _repo({});
      OtpArgs? sent;
      await tester.pumpWidget(_app(PhoneLoginScreen(
        auth: repo,
        smsReader: _FakeSms(),
        onCodeSent: (args) => sent = args,
      )));
      await tester.enterText(find.byType(TextField), '12345');
      await tester.tap(find.text('Send OTP'));
      await tester.pump();
      expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
      expect(sent, isNull);
      expect(server.bodies, isEmpty);
    });

    testWidgets('sends the code with the SMS hash and opens the OTP step', (tester) async {
      final (repo, server, _) = _repo({
        '/v1/auth/otp/send': [
          (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
        ],
      });
      OtpArgs? sent;
      await tester.pumpWidget(_app(PhoneLoginScreen(
        auth: repo,
        smsReader: _FakeSms(),
        onCodeSent: (args) => sent = args,
      )));
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Google'), findsNothing); // no Google without the callback
      await tester.enterText(find.byType(TextField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();
      expect(sent!.phone, '9876543210');
      expect(sent!.resendAfterSeconds, 30);
      final body = server.bodies['/v1/auth/otp/send']!.single;
      expect(body['purpose'], 'login');
      expect(body['appHash'], 'AbCdEfGhIjK');
    });

    testWidgets('shows the server error in the user\'s language', (tester) async {
      final (repo, _, _) = _repo({
        '/v1/auth/otp/send': [
          (429, {
            'error': {'code': 'OTP_RATE_LIMITED', 'message': 'x', 'details': {}},
          }),
        ],
      });
      await tester.pumpWidget(_app(PhoneLoginScreen(
        auth: repo,
        smsReader: _FakeSms(),
        onCodeSent: (_) {},
      )));
      await tester.enterText(find.byType(TextField), '9876543210');
      await tester.tap(find.text('Send OTP'));
      await tester.pumpAndSettle();
      expect(find.text('Too many code requests. Please try again later.'), findsOneWidget);
    });

    testWidgets('patient: Create Account switches the title; Google appears when on',
        (tester) async {
      final (repo, _, _) = _repo({});
      await tester.pumpWidget(_app(PhoneLoginScreen(
        auth: repo,
        smsReader: _FakeSms(),
        onCodeSent: (_) {},
        onGoogle: () async => const GoogleResult.phoneRequired('link-token'),
      )));
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();
      expect(find.text('Create your account'), findsOneWidget);

      await tester.ensureVisible(find.text('Google'));
      await tester.tap(find.text('Google'));
      await tester.pumpAndSettle();
      expect(
        find.text('Verify your mobile number once to finish signing in with Google.'),
        findsOneWidget,
      );
    });

    testWidgets('partner: badge, no Create Account', (tester) async {
      final (repo, _, _) = _repo({}, app: LoginApp.partner);
      await tester.pumpWidget(_app(PhoneLoginScreen(
        auth: repo,
        smsReader: _FakeSms(),
        onCodeSent: (_) {},
        partner: true,
        notice: 'You logged in on another phone, so you were logged out here.',
      )));
      expect(find.text('Partner'), findsOneWidget);
      expect(find.text('Create Account'), findsNothing);
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Log in, or join as a companion or nurse, with your mobile number'), findsOneWidget);
      expect(find.text('New partner? Enter your number to start your application.'), findsOneWidget);
      expect(find.textContaining('another phone'), findsOneWidget);
    });
  });

  group('OtpScreen', () {
    Future<(_FakeServer, InMemoryTokenStorage, List<bool>)> pumpOtp(
      WidgetTester tester,
      Map<String, List<(int, Object)>> script, {
      _FakeSms? sms,
    }) async {
      final (repo, server, tokens) = _repo(script);
      final verified = <bool>[];
      await tester.pumpWidget(_app(OtpScreen(
        auth: repo,
        smsReader: sms ?? _FakeSms(),
        args: const OtpArgs(phone: '9876543210', resendAfterSeconds: 30),
        onVerified: (isNew) async => verified.add(isNew),
        onChangeNumber: () {},
      )));
      return (server, tokens, verified);
    }

    testWidgets('right code logs in and saves the tokens', (tester) async {
      final (server, tokens, verified) = await pumpOtp(tester, {
        '/v1/auth/otp/verify': [(200, _tokens)],
      });
      expect(find.text('Enter the 6-digit code sent to +91 98765 43210'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
      await tester.pumpAndSettle();
      expect(verified, [true]);
      expect(await tokens.readAccessToken(), 'a');
      expect(server.bodies['/v1/auth/otp/verify']!.single['otp'], '123456');
    });

    testWidgets('wrong code shows the tries left and clears the boxes', (tester) async {
      await pumpOtp(tester, {
        '/v1/auth/otp/verify': [
          (400, {
            'error': {'code': 'OTP_INVALID', 'message': 'x', 'details': {'attemptsLeft': 3}},
          }),
        ],
      });
      await tester.enterText(find.byKey(const Key('ww-otp-input')), '000000');
      await tester.pumpAndSettle();
      expect(find.text("That code isn't right. 3 tries left."), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('resend countdown, then resend', (tester) async {
      final (server, _, _) = await pumpOtp(tester, {
        '/v1/auth/otp/send': [
          (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 60, 'length': 6}),
        ],
      });
      expect(find.text('Resend code in 30s'), findsOneWidget);
      await tester.pump(const Duration(seconds: 30));
      expect(find.text('Resend code'), findsOneWidget);
      await tester.tap(find.text('Resend code'));
      await tester.pumpAndSettle();
      expect(find.text('A new code was sent'), findsOneWidget);
      expect(find.text('Resend code in 60s'), findsOneWidget);
      expect(server.bodies['/v1/auth/otp/send'], hasLength(1));
      await tester.pump(const Duration(seconds: 61)); // let the timer finish
    });

    testWidgets('a code read from the SMS is checked by itself', (tester) async {
      final sms = _FakeSms();
      final (_, _, verified) = await pumpOtp(
        tester,
        {'/v1/auth/otp/verify': [(200, _tokens)]},
        sms: sms,
      );
      sms.code.complete('482910');
      await tester.pumpAndSettle();
      expect(verified, [true]);
      expect(find.text('4'), findsOneWidget);
    });
  });
}
