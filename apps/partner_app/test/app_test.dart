import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partner_app/app.dart';
import 'package:partner_app/providers.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_ui/ww_ui.dart';

import 'fixtures.dart';

class _FakeBackend implements HttpClientAdapter {
  _FakeBackend(this.routes);

  final Map<String, (int, Object) Function()> routes;
  final calls = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    calls.add(key);
    final (status, body) =
        routes[key]?.call() ??
        (
          404,
          {
            'error': {'code': 'NOT_FOUND', 'message': key, 'details': {}},
          },
        );
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class _FakeSocket implements PartnerSocket {
  final messages = StreamController<Map<String, dynamic>>.broadcast();
  String? token;

  @override
  Stream<Map<String, dynamic>> connect(String accessToken) {
    token = accessToken;
    return messages.stream;
  }

  @override
  int? closeCode;

  /// What the app sent (live location during a job).
  final sent = <Map<String, dynamic>>[];

  @override
  bool send(String type, Map<String, dynamic> data) {
    sent.add({'type': type, ...data});
    return true;
  }

  @override
  Future<void> close() async {}
}

final _config = {
  'minVersions': {'patientAndroid': '0.1.0', 'patientIos': '0.1.0', 'partnerAndroid': '0.1.0'},
  'storeUrls': {'patientAndroid': 'x', 'patientIos': 'x', 'partnerAndroid': 'https://play.google.com'},
  'supportPhone': '+919000000000',
  'refundPercent': 50,
  'accountDeletionDays': 7,
  'legalUrls': {
    'terms': 'http://10.0.2.2:8000/legal/terms',
    'privacy': 'http://10.0.2.2:8000/legal/privacy',
    'refunds': 'http://10.0.2.2:8000/legal/refunds',
    'partnerTerms': 'http://10.0.2.2:8000/legal/partner-terms',
    'deleteAccount': 'http://10.0.2.2:8000/delete-account',
  },
};

final _me = {'id': 'u-1', 'phone': '+919876543210', 'language': 'en', 'partnerStatus': null, 'role': null};

Future<(InMemoryTokenStorage, _FakeSocket)> _pump(
  WidgetTester tester,
  _FakeBackend backend, {
  bool loggedIn = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final config = AppConfig.forFlavor(Flavor.dev);
  final storage = InMemoryTokenStorage();
  if (loggedIn) await storage.save(accessToken: 'access', refreshToken: 'refresh');
  final socket = _FakeSocket();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        tokenStorageProvider.overrideWithValue(storage),
        deviceIdStoreProvider.overrideWithValue(const FixedDeviceIdStore('partner-phone-a')),
        refreshDioProvider.overrideWith((ref) => createRefreshClient(config)..httpClientAdapter = backend),
        apiClientProvider.overrideWith(
          (ref) => createApiClient(config, session: ref.watch(sessionManagerProvider))..httpClientAdapter = backend,
        ),
        appVersionProvider.overrideWith((ref) async => '0.1.0'),
        smsCodeReaderProvider.overrideWithValue(const NoSmsCodeReader()),
        partnerSocketProvider.overrideWithValue(socket),
      ],
      child: const PartnerApp(),
    ),
  );
  await tester.pumpAndSettle();
  return (storage, socket);
}

void main() {
  testWidgets('partner app opens on the splash with the Partner badge', (tester) async {
    final backend = _FakeBackend({});
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(AppConfig.forFlavor(Flavor.dev)),
          apiClientProvider.overrideWith((ref) => Dio()..httpClientAdapter = backend),
        ],
        child: const PartnerApp(),
      ),
    );
    await tester.pump();
    expect(find.byType(WWSplash), findsOneWidget);
    expect(find.byKey(const Key('ww-splash-badge')), findsOneWidget);
    expect(find.text('Partner'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('login with OTP, then choose the role', (tester) async {
    final backend = _FakeBackend({
      'GET /v1/public/app-config': () => (200, _config),
      'POST /v1/auth/otp/send': () => (200, {'expiresInSeconds': 300, 'resendAfterSeconds': 30, 'length': 6}),
      'POST /v1/auth/otp/verify': () => (200, {'accessToken': 'access', 'refreshToken': 'refresh', 'expiresIn': 900}),
      'GET /v1/partner/me': () => (200, _me),
      'PUT /v1/partner/me/device': () => (200, {'ok': true}),
    });
    final (storage, socket) = await _pump(tester, backend);
    expect(find.text('Log in, or join as a companion or nurse, with your mobile number'), findsOneWidget);
    expect(find.text('Partner'), findsOneWidget);
    expect(find.text('Google'), findsNothing);

    await tester.enterText(find.byType(TextField), '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('ww-otp-input')), '123456');
    await tester.pumpAndSettle();

    // not registered yet: choose Companion or Nurse (R03)
    expect(find.text('What work will you do?'), findsOneWidget);
    expect(await storage.readAccessToken(), 'access');
    expect(socket.token, 'access'); // socket opened with the access token
    expect(backend.calls, contains('PUT /v1/partner/me/device'));
  });

  testWidgets('a login on another phone logs this one out at once', (tester) async {
    final backend = _FakeBackend({
      'GET /v1/public/app-config': () => (200, _config),
      'GET /v1/partner/me': () => (200, _me),
    });
    final (storage, socket) = await _pump(tester, backend, loggedIn: true);
    expect(find.text('What work will you do?'), findsOneWidget);

    socket.messages.add({
      'type': 'session.revoked',
      'data': {'reason': 'LOGGED_IN_ELSEWHERE'},
    });
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('You logged in on another phone, so you were logged out here.'), findsOneWidget);
    expect(await storage.readAccessToken(), isNull);
  });

  testWidgets('without the socket, the next call finds out and logs out', (tester) async {
    var revoked = false;
    final backend = _FakeBackend({
      'GET /v1/public/app-config': () => (200, _config),
      'GET /v1/partner/me': () => revoked
          ? (
              401,
              {
                'error': {'code': 'UNAUTHORIZED', 'message': '', 'details': {}},
              },
            )
          : (200, _me),
      'POST /v1/auth/refresh': () => (
        401,
        {
          'error': {
            'code': 'SESSION_REVOKED',
            'message': '',
            'details': {'reason': 'LOGGED_IN_ELSEWHERE'},
          },
        },
      ),
    });
    await _pump(tester, backend, loggedIn: true);
    revoked = true;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(find.textContaining('another phone'), findsOneWidget);
  });

  testWidgets('logout', (tester) async {
    final backend = _FakeBackend({
      'GET /v1/public/app-config': () => (200, _config),
      'GET /v1/partner/me': () => (200, {..._me, 'partnerStatus': 'REGISTERING', 'role': 'COMPANION'}),
      'GET /v1/partner/kyc/status': () => (200, kyc()),
      'POST /v1/auth/logout': () => (200, {'ok': true}),
    });
    final (storage, _) = await _pump(tester, backend, loggedIn: true);
    await tester.scrollUntilVisible(find.text('Logout'), 200);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome'), findsOneWidget);
    expect(await storage.readRefreshToken(), isNull);
  });
}
