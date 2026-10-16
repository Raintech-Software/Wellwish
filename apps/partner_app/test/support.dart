import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:partner_app/app.dart';
import 'package:partner_app/features/jobs/visit_outbox.dart';
import 'package:partner_app/features/registration/device_tools.dart';
import 'package:partner_app/features/session/rooted_warning.dart';
import 'package:partner_app/providers.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';

/// A fake backend and the app pumped against it (shared by the partner app tests).

class Backend implements HttpClientAdapter {
  Backend(this.routes);

  final Map<String, (int, Object) Function()> routes;
  final calls = <String>[];
  final bodies = <String, Object?>{};

  /// Every request with a body, in order ("METHOD /path", body).
  final sent = <(String, String)>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    calls.add(key);
    if (requestStream != null) {
      final bytes = await requestStream.fold<List<int>>([], (all, chunk) => all..addAll(chunk));
      bodies[key] = utf8.decode(bytes, allowMalformed: true);
      sent.add((key, bodies[key]! as String));
    }
    final (status, body) =
        routes[key]?.call() ??
        (
          404,
          {
            'error': {'code': 'NOT_FOUND', 'message': key, 'details': {}},
          },
        );
    if (status == 0) {
      // no network
      throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
    }
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

class FakeSocket implements PartnerSocket {
  final messages = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> connect(String accessToken) => messages.stream;

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

class FakePicker implements FilePickerService {
  @override
  Future<PickedFile?> pick(PickSource source) async =>
      PickedFile(bytes: Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]), mime: 'image/jpeg');
}

final appConfigJson = {
  'minVersions': {'patientAndroid': '0.1.0', 'patientIos': '0.1.0', 'partnerAndroid': '0.1.0'},
  'storeUrls': {'patientAndroid': 'x', 'patientIos': 'x', 'partnerAndroid': 'x'},
  'supportPhone': '+919000000000',
  'refundPercent': 50,
  'accountDeletionDays': 10,
  'legalUrls': {
    'terms': 'http://10.0.2.2:8000/legal/terms',
    'privacy': 'http://10.0.2.2:8000/legal/privacy',
    'refunds': 'http://10.0.2.2:8000/legal/refunds',
    'partnerTerms': 'http://10.0.2.2:8000/legal/partner-terms',
    'deleteAccount': 'http://10.0.2.2:8000/delete-account',
  },
};

Map<String, dynamic> meJson(String? status) => {
  'id': 'u-1',
  'phone': '+919876543210',
  'language': 'en',
  'partnerStatus': status,
  'role': status == null ? null : 'COMPANION',
};

/// Live location in tests: points are pushed by hand.
class FakeTracker implements LocationTracker {
  final points = StreamController<TrackPoint>.broadcast();
  bool running = false;

  /// The notification text of the last start.
  String? notificationText;

  @override
  Stream<TrackPoint> start({required String notificationTitle, required String notificationText}) {
    running = true;
    this.notificationText = notificationText;
    return points.stream;
  }

  @override
  Future<void> stop() async => running = false;
}

class FakeLocation implements LocationService {
  FakeLocation({this.mock = false});

  /// A "mock location" app is on (Android marks the position as fake).
  final bool mock;

  @override
  Future<LocationResult> current() async => (position: (20.2961, 85.8245), problem: null, mock: mock);
}

Future<void> pumpPartnerApp(
  WidgetTester tester,
  Backend backend, {
  FakeSocket? socket,
  FilePickerService? picker,
  FakeTracker? tracker,
  FakeLocation? location,
  bool rooted = false,
  VisitOutbox? outbox,
  Map<String, VisitOutbox>? outboxes,
  List<String>? openedPages,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  // PHASES 9.8: `flutter test --dart-define=WW_TEXT_SCALE=2` runs every screen with the phone's
  // largest text (Android goes up to 200 %)
  final textScale = double.tryParse(const String.fromEnvironment('WW_TEXT_SCALE'));
  if (textScale != null) {
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  }
  final config = AppConfig.forFlavor(Flavor.dev);
  final storage = InMemoryTokenStorage();
  await storage.save(accessToken: 'access', refreshToken: 'refresh');
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
        uploadHttpProvider.overrideWith((ref) => Dio()..httpClientAdapter = backend),
        appVersionProvider.overrideWith((ref) async => '0.1.0'),
        smsCodeReaderProvider.overrideWithValue(const NoSmsCodeReader()),
        partnerSocketProvider.overrideWithValue(socket ?? FakeSocket()),
        filePickerProvider.overrideWithValue(picker ?? FakePicker()),
        locationTrackerProvider.overrideWithValue(tracker ?? FakeTracker()),
        stepLocationProvider.overrideWithValue(location ?? FakeLocation()),
        looksRootedProvider.overrideWith((ref) async => rooted),
        // one per partner ([outboxes] by user id), or [outbox] for all
        visitOutboxProvider.overrideWith((ref, partnerId) => outboxes?[partnerId] ?? outbox ?? MemoryVisitOutbox()),
        notificationPermissionProvider.overrideWithValue(() async {}),
        // §6.20: the legal pages open in the browser; here they are only written down
        openPublicPageProvider.overrideWithValue((url, language) async {
          openedPages?.add('$url?l=$language');
          return true;
        }),
      ],
      child: const PartnerApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Map<String, (int, Object) Function()> baseRoutes(String? status, Map<String, dynamic> Function() kycNow) => {
  'GET /v1/public/app-config': () => (200, appConfigJson),
  'GET /v1/partner/me': () => (200, meJson(status)),
  'PUT /v1/partner/me/device': () => (200, {'ok': true}),
  'GET /v1/partner/kyc/status': () => (200, kycNow()),
};

Map<String, dynamic> serviceJson({String name = 'Doctor visit companion'}) => {
  'name': name,
  'nameHi': '',
  'nameOr': '',
  'partnerType': 'COMPANION',
  'visitType': 'HOSPITAL_VISIT',
  'durationMin': 240,
  'docsRequired': false,
  'pricePaise': 50000,
  'bookingFeePaise': 10000,
  'balancePaise': 40000,
};

/// An open offer; `timeoutAt` [secondsLeft] from now.
Map<String, dynamic> offerJson({
  String id = 'a-1',
  String kind = 'NEW',
  int secondsLeft = 100,
  String response = 'OPEN',
}) => {
  'assignmentId': id,
  'kind': kind,
  'response': response,
  'bookingId': 'b-1',
  'code': 'WW-10001',
  'service': serviceJson(),
  'pickupAt': DateTime.now().toUtc().add(const Duration(days: 1)).toIso8601String(),
  'appointmentAt': null,
  'area': 'Saheed Nagar, Bhubaneswar 751007',
  'distanceKm': 2.4,
  'hospitalName': 'Capital Hospital',
  'memberAge': 72,
  'memberGender': 'FEMALE',
  'language': 'Odia',
  'mobility': 'NEEDS_SUPPORT',
  'documentsAttached': 1,
  'hasPrescription': true,
  'balancePaise': 40000,
  'sentAt': DateTime.now().toUtc().subtract(const Duration(seconds: 20)).toIso8601String(),
  'timeoutAt': DateTime.now().toUtc().add(Duration(seconds: secondsLeft)).toIso8601String(),
};

Map<String, dynamic> jobRowJson({String status = 'ACCEPTED'}) => {
  'id': 'b-1',
  'code': 'WW-10001',
  'status': status,
  'service': serviceJson(),
  'pickupAt': DateTime.now().toUtc().add(const Duration(hours: 3)).toIso8601String(),
  'appointmentAt': null,
  'memberName': 'Sabitri Gouda',
  'hospitalName': 'Capital Hospital',
  'area': 'Saheed Nagar, Bhubaneswar 751007',
  'reconfirmNeeded': false,
};

Map<String, dynamic> visitJson({
  String type = 'HOSPITAL_VISIT',
  List<String> done = const [],
  String? otpRetryAt,
  String? noShowReadyAt,
  int? balance,
  String mode = '',
}) {
  final steps = type == 'HOME_VISIT'
      ? ['ON_THE_WAY', 'REACHED_HOME', 'STARTED', 'CARE_DONE', 'COMPLETED']
      : ['ON_THE_WAY', 'REACHED_PATIENT', 'PICKED_UP', 'REACHED_HOSPITAL', 'VISIT_DONE', 'DROPPED_HOME', 'COMPLETED'];
  return {
    'steps': steps,
    'done': [
      for (final s in done) {'step': s, 'at': '2026-10-11T04:00:00Z', 'by': 'PARTNER', 'far': false},
    ],
    'currentStep': done.isEmpty ? '' : done.last,
    'nextStep': done.length < steps.length ? steps[done.length] : null,
    'otpStep': type == 'HOME_VISIT' ? 'STARTED' : 'PICKED_UP',
    'otpRetryAt': otpRetryAt,
    'noShowReadyAt': noShowReadyAt,
    'balanceCollectedPaise': balance,
    'balanceMode': mode,
  };
}

Map<String, dynamic> jobJson({String status = 'ACCEPTED', Map<String, dynamic>? visit}) => {
  ...jobRowJson(),
  'status': status,
  'visit': visit ?? visitJson(),
  'member': {
    'fullName': 'Sabitri Gouda',
    'relation': 'MOTHER',
    'gender': 'FEMALE',
    'age': 72,
    'language': 'Odia',
    'phone': '+919876500011',
    'photoUrl': null,
    'mobility': 'NEEDS_SUPPORT',
    'conditions': 'BP, diabetes',
    'allergies': 'Penicillin',
    'sensoryNotes': 'Hard of hearing',
  },
  'bookerName': 'Asha Das',
  'bookerPhone': '+919000000001',
  'address': {
    'label': 'Home',
    'line1': 'Plot 12, Saheed Nagar, Bhubaneswar 751007',
    'landmark': 'Near the temple',
    'notes': '',
    'lat': '20.296100',
    'lng': '85.824500',
  },
  'hospitalText': '',
  'doctorName': 'Dr. Ananya Mishra',
  'notes': 'Wheelchair at the gate',
  'documents': [
    {'id': 'bd-1', 'documentId': 'd-9', 'type': 'PRESCRIPTION', 'title': 'Dr. Rath BP tablets', 'removed': false},
  ],
  'balancePaise': 40000,
};

Map<String, dynamic> homeJson({
  bool available = false,
  bool selfie = false,
  List<Map<String, dynamic>> offers = const [],
  List<Map<String, dynamic>> today = const [],
}) => {
  'availableToday': available,
  'selfieToday': selfie,
  'offers': offers,
  'today': today,
  'totals': {'today': 1, 'thisWeek': 4, 'upcoming': 2},
};
