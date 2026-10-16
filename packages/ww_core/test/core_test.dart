import 'dart:async';
import 'dart:io' show HttpDate;
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart'
    show AndroidSettings, GeolocatorPlatform, LocationPermission, LocationSettings, Position;
import 'package:ww_core/ww_core.dart';

/// Answers requests from a script (path → list of (status, body), used in order) and records
/// every request.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.script);

  final Map<String, List<(int, Object)>> script;
  final requests = <RequestOptions>[];

  RequestOptions get lastRequest => requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final queue = script[options.path] ?? [];
    final (status, body) = queue.length > 1 ? queue.removeAt(0) : queue.first;
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

Map<String, Object> _err(String code, [Map<String, Object> details = const {}]) => {
  'error': {'code': code, 'message': 'msg', 'details': details},
};

const _tokens = {'accessToken': 'new-access', 'refreshToken': 'new-refresh', 'expiresIn': 900};

/// A logged-in client wired like the apps do it.
Future<(Dio, SessionManager, InMemoryTokenStorage, _FakeAdapter)> _client(
  Map<String, List<(int, Object)>> script,
) async {
  final config = AppConfig.forFlavor(Flavor.dev);
  final tokens = InMemoryTokenStorage();
  await tokens.save(accessToken: 'old-access', refreshToken: 'old-refresh');
  final adapter = _FakeAdapter(script);
  final refreshDio = createRefreshClient(config)..httpClientAdapter = adapter;
  final session = SessionManager(tokens: tokens, refreshDio: refreshDio);
  final dio = createApiClient(config, session: session)..httpClientAdapter = adapter;
  return (dio, session, tokens, adapter);
}

void main() {
  group('AppConfig', () {
    test('dev points at the emulator address of the PC', () {
      final c = AppConfig.forFlavor(Flavor.dev);
      expect(c.apiBaseUrl, 'http://10.0.2.2:8000');
      expect(c.apiV1, 'http://10.0.2.2:8000/v1');
      expect(c.wsBaseUrl, 'ws://10.0.2.2:8000');
      expect(c.isProd, isFalse);
      expect(c.googleSignInEnabled, isFalse); // no GOOGLE_SERVER_CLIENT_ID given
    });

    test('prod uses https and wss', () {
      final c = AppConfig.forFlavor(Flavor.prod);
      expect(c.apiBaseUrl, startsWith('https://'));
      expect(c.wsBaseUrl, startsWith('wss://'));
      expect(c.isProd, isTrue);
    });
  });

  group('ApiException.fromDio', () {
    final req = RequestOptions(path: '/x');

    test('reads the WellWish error format', () {
      final e = DioException(
        requestOptions: req,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: req,
          statusCode: 409,
          data: {
            'error': {
              'code': 'SLOT_TAKEN',
              'message': 'Just taken — pick another time',
              'details': {'slot': '10:15'},
            },
          },
        ),
      );
      final api = ApiException.fromDio(e);
      expect(api.code, 'SLOT_TAKEN');
      expect(api.statusCode, 409);
      expect(api.message, contains('pick another time'));
      expect(api.details['slot'], '10:15');
    });

    test('maps offline and timeouts to connectivity codes', () {
      final offline = ApiException.fromDio(DioException(requestOptions: req, type: DioExceptionType.connectionError));
      final slow = ApiException.fromDio(DioException(requestOptions: req, type: DioExceptionType.receiveTimeout));
      expect(offline.code, ApiException.networkError);
      expect(slow.code, ApiException.timeout);
      expect(offline.isConnectivity && slow.isConnectivity, isTrue);
    });

    test('unknown body becomes UNKNOWN with the status code', () {
      final api = ApiException.fromDio(
        DioException(
          requestOptions: req,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: req, statusCode: 502, data: '<html>'),
        ),
      );
      expect(api.code, ApiException.unknown);
      expect(api.statusCode, 502);
    });
  });

  group('createApiClient', () {
    test('sends the bearer token, but never to the login endpoints', () async {
      final (dio, _, _, adapter) = await _client({
        '/v1/patient/me': [
          (200, {'ok': true}),
        ],
        '/v1/auth/otp/send': [
          (200, {'ok': true}),
        ],
      });
      await dio.get<Object>('/v1/patient/me');
      expect(adapter.lastRequest.headers['Authorization'], 'Bearer old-access');
      expect(adapter.lastRequest.uri.toString(), 'http://10.0.2.2:8000/v1/patient/me');
      await dio.post<Object>('/v1/auth/otp/send');
      expect(adapter.lastRequest.headers.containsKey('Authorization'), isFalse);
    });

    test('on 401 refreshes once and retries with the new token', () async {
      final (dio, _, tokens, adapter) = await _client({
        '/v1/patient/me': [
          (401, _err('UNAUTHORIZED')),
          (200, {'ok': true}),
        ],
        '/v1/auth/refresh': [(200, _tokens)],
      });
      final res = await dio.get<Map<String, dynamic>>('/v1/patient/me');
      expect(res.data!['ok'], true);
      expect(adapter.requests.map((r) => r.path).toList(), ['/v1/patient/me', '/v1/auth/refresh', '/v1/patient/me']);
      expect(adapter.lastRequest.headers['Authorization'], 'Bearer new-access');
      expect(await tokens.readRefreshToken(), 'new-refresh');
    });

    test('many 401s at once share one refresh', () async {
      final (dio, _, _, adapter) = await _client({
        '/v1/a': [(401, _err('UNAUTHORIZED')), (200, {})],
        '/v1/b': [(401, _err('UNAUTHORIZED')), (200, {})],
        '/v1/auth/refresh': [(200, _tokens)],
      });
      await Future.wait([dio.get<Object>('/v1/a'), dio.get<Object>('/v1/b')]);
      expect(adapter.requests.where((r) => r.path == '/v1/auth/refresh').length, 1);
    });

    test('a revoked session ends with the right reason', () async {
      final (dio, session, tokens, _) = await _client({
        '/v1/partner/me': [(401, _err('UNAUTHORIZED'))],
        '/v1/auth/refresh': [
          (401, _err('SESSION_REVOKED', {'reason': 'LOGGED_IN_ELSEWHERE'})),
        ],
      });
      final ended = session.sessionEnded.first;
      await expectLater(dio.get<Object>('/v1/partner/me'), throwsA(isA<DioException>()));
      expect(await ended, SessionEndReason.loggedInElsewhere);
      expect(await tokens.readRefreshToken(), isNull);
    });

    test('a refresh refused for a block, or a job that is over, says so (9.10, 9.11)', () async {
      for (final (status, error, reason) in [
        (403, _err('ACCOUNT_BLOCKED'), SessionEndReason.accountBlocked),
        (401, _err('SESSION_REVOKED', {'reason': 'ACCOUNT_BLOCKED'}), SessionEndReason.accountBlocked),
        (401, _err('SESSION_REVOKED', {'reason': 'JOB_OVER'}), SessionEndReason.jobOver),
      ]) {
        final (dio, session, _, _) = await _client({
          '/v1/partner/me': [(401, _err('UNAUTHORIZED'))],
          '/v1/auth/refresh': [(status, error)],
        });
        final ended = session.sessionEnded.first;
        await expectLater(dio.get<Object>('/v1/partner/me'), throwsA(isA<DioException>()));
        expect(await ended, reason);
      }
    });

    test('too many requests or a timeout on refresh keeps the session (deep check)', () async {
      for (final status in [429, 408]) {
        final (_, session, tokens, _) = await _client({
          '/v1/auth/refresh': [(status, _err('TOO_MANY_REQUESTS'))],
        });
        expect(await session.refresh(), isFalse);
        expect(await tokens.readRefreshToken(), 'old-refresh');
      }
    });

    test('offline during refresh keeps the session', () async {
      final config = AppConfig.forFlavor(Flavor.dev);
      final tokens = InMemoryTokenStorage();
      await tokens.save(accessToken: 'a', refreshToken: 'r');
      final refreshDio = createRefreshClient(config)..httpClientAdapter = _ThrowingAdapter();
      final session = SessionManager(tokens: tokens, refreshDio: refreshDio);
      expect(await session.refresh(), isFalse);
      expect(await tokens.readRefreshToken(), 'r');
    });

    test('failed calls surface as ApiException', () async {
      final (dio, _, _, _) = await _client({
        '/v1/patient/members/x': [(404, _err('NOT_FOUND'))],
      });
      try {
        await dio.get<Object>('/v1/patient/members/x');
        fail('expected an error');
      } catch (e) {
        final api = toApiException(e);
        expect(api.code, 'NOT_FOUND');
        expect(api.statusCode, 404);
      }
    });
  });

  group('AuthRepository', () {
    test('verifyOtp saves the tokens and sends the device id', () async {
      final (dio, session, tokens, adapter) = await _client({
        '/v1/auth/otp/verify': [
          (200, {..._tokens, 'isNewUser': true}),
        ],
      });
      final repo = AuthRepository(
        dio: dio,
        session: session,
        deviceIds: const FixedDeviceIdStore('device-0001'),
        app: LoginApp.partner,
      );
      expect(await repo.verifyOtp('9876543210', '123456', language: 'or'), isTrue);
      expect(await tokens.readAccessToken(), 'new-access');
      final sent = jsonDecode(adapter.lastRequest.data as String) as Map<String, dynamic>;
      expect(sent['purpose'], 'partner_primary');
      expect(sent['deviceId'], 'device-0001');
      expect(sent['language'], 'or'); // a new account starts in the app's language (§5)
    });

    test('server errors come back as ApiException', () async {
      final (dio, session, _, _) = await _client({
        '/v1/auth/otp/send': [
          (429, _err('OTP_RESEND_TOO_SOON', {'retryAfterSeconds': 12})),
        ],
      });
      final repo = AuthRepository(
        dio: dio,
        session: session,
        deviceIds: const FixedDeviceIdStore('device-0001'),
        app: LoginApp.patient,
      );
      await expectLater(
        repo.sendOtp('9876543210'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.code, 'code', 'OTP_RESEND_TOO_SOON')
              .having((e) => e.details['retryAfterSeconds'], 'wait', 12),
        ),
      );
    });

    test('logout forgets the tokens even when offline', () async {
      final (dio, session, tokens, _) = await _client({
        '/v1/auth/logout': [(503, {})],
      });
      final repo = AuthRepository(
        dio: dio,
        session: session,
        deviceIds: const FixedDeviceIdStore('device-0001'),
        app: LoginApp.patient,
      );
      final ended = session.sessionEnded.first;
      await repo.logout();
      expect(await ended, SessionEndReason.loggedOut);
      expect(await tokens.readAccessToken(), isNull);
    });
  });

  test('device ids are random and valid for the server', () {
    final a = newDeviceId();
    expect(a, matches(RegExp(r'^[a-f0-9]{32}$')));
    expect(newDeviceId(), isNot(a));
  });

  test('version comparison for force update', () {
    expect(isOlderVersion('0.1.0', '0.2.0'), isTrue);
    expect(isOlderVersion('0.1.0+5', '0.1.0'), isFalse);
    expect(isOlderVersion('1.10.0', '1.9.9'), isFalse);
    expect(isOlderVersion('1.0', '1.0.1'), isTrue);
  });

  test('token storage saves and clears', () async {
    final tokens = InMemoryTokenStorage();
    await tokens.save(accessToken: 'a', refreshToken: 'b');
    expect(await tokens.readAccessToken(), 'a');
    await tokens.clear();
    expect(await tokens.readRefreshToken(), isNull);
  });

  test('server clock: a phone 3 minutes slow still counts down with the server', () {
    final phoneNow = DateTime.now();
    final serverNow = phoneNow.add(const Duration(minutes: 3));
    ServerClock.sync(HttpDate.format(serverNow), receivedAt: phoneNow);
    expect(ServerClock.now().difference(DateTime.now()).inSeconds, inInclusiveRange(178, 181));
    ServerClock.sync('not a date');
    expect(ServerClock.now().difference(DateTime.now()).inSeconds, inInclusiveRange(178, 181));
    ServerClock.reset();
  });

  test('live session.revoked reasons', () {
    expect(revokedReason({'reason': 'LOGGED_IN_ELSEWHERE'}), SessionEndReason.loggedInElsewhere);
    expect(revokedReason({'reason': 'LOGOUT'}), SessionEndReason.loggedOut);
    expect(revokedReason({'reason': 'ACCOUNT_BLOCKED'}), SessionEndReason.accountBlocked);
    expect(revokedReason({'reason': 'ACCOUNT_DELETED'}), SessionEndReason.accountDeleted);
    expect(revokedReason({'reason': 'JOB_OVER'}), SessionEndReason.jobOver);
    expect(revokedReason({'reason': 'REUSE_DETECTED'}), SessionEndReason.revoked);
    expect(revokedReason(null), SessionEndReason.revoked);
  });

  test('socket endpoint per audience, never with the token in the URL', () {
    final client = WWSocketClient(AppConfig.forFlavor(Flavor.dev));
    final uri = client.endpoint('patient');
    expect(uri.toString(), 'ws://10.0.2.2:8000/ws/patient/');
    expect(uri.query, isEmpty);
  });

  group('DeviceLocationTracker', () {
    late _FakeGeolocator platform;
    setUp(() => GeolocatorPlatform.instance = platform = _FakeGeolocator());

    Future<void> settle() async {
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    test('the fused location fails: a new GPS-only stream takes over, once', () async {
      final tracker = DeviceLocationTracker();
      final points = <TrackPoint>[];
      final errors = <Object>[];
      tracker.start(notificationTitle: 't', notificationText: 'x').listen(points.add, onError: errors.add);
      await settle();
      expect(platform.natives.map((n) => n.$1), [false]); // fused first
      platform.natives.single.$2.addError(Exception('Location Accuracy refused'));
      await settle();
      expect(platform.natives.map((n) => n.$1), [false, true]); // not the failed fused one again
      expect(platform.natives.first.$2.hasListener, isFalse);
      platform.natives.last.$2.add(_position());
      await settle();
      expect(points, hasLength(1));
      expect(errors, isEmpty);
      // GPS fails too: the app is told, no going back to fused
      platform.natives.last.$2.addError(Exception('GPS off'));
      await settle();
      expect(errors, hasLength(1));
      expect(platform.natives, hasLength(2));
      await tracker.stop();
      expect(platform.natives.last.$2.hasListener, isFalse);
    });

    test('stopped during the permission dialog: nothing is started', () async {
      platform.asking = Completer();
      final tracker = DeviceLocationTracker();
      var closed = false;
      tracker.start(notificationTitle: 't', notificationText: 'x').listen(null, onDone: () => closed = true);
      await settle();
      await tracker.stop();
      platform.asking!.complete(LocationPermission.whileInUse);
      await settle();
      expect(closed, isTrue);
      expect(platform.natives, isEmpty); // no location stream, so no foreground service
    });
  });
}

/// The phone's location like geolocator_android 5.1.1 `getPositionStream`: one position stream
/// at a time, kept until its last listener has gone (then the native one is cancelled).
class _FakeGeolocator extends GeolocatorPlatform {
  Completer<LocationPermission>? asking;

  /// Every native stream opened: (GPS only, the stream).
  final natives = <(bool, StreamController<Position>)>[];
  Stream<Position>? _positionStream;

  @override
  Future<LocationPermission> checkPermission() => asking?.future ?? Future.value(LocationPermission.whileInUse);

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    if (_positionStream != null) return _positionStream!;
    final native = StreamController<Position>.broadcast();
    natives.add(((locationSettings! as AndroidSettings).forceLocationManager, native));
    return _positionStream = native.stream
        .asBroadcastStream(
          onCancel: (subscription) {
            subscription.cancel();
            _positionStream = null;
          },
        )
        .map((p) => p);
  }
}

Position _position() => Position(
  latitude: 20.29,
  longitude: 85.84,
  timestamp: DateTime.utc(2026, 10, 12),
  accuracy: 9,
  altitude: 0,
  altitudeAccuracy: 0,
  heading: 0,
  headingAccuracy: 0,
  speed: 0,
  speedAccuracy: 0,
);

class _ThrowingAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
  }

  @override
  void close({bool force = false}) {}
}
