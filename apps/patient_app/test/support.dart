import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_app/app.dart';
import 'package:patient_app/features/addresses/address_form_screen.dart';
import 'package:patient_app/features/auth/google_sign_in_service.dart';
import 'package:patient_app/features/documents/documents_controller.dart';
import 'package:patient_app/features/payments/payment_checkout.dart';
import 'package:patient_app/features/setup/location_screen.dart';
import 'package:patient_app/providers.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';

typedef Handler = (int, Object) Function(RequestOptions request);

/// A fake backend: "METHOD /path" → handler. Records every call.
class FakeBackend implements HttpClientAdapter {
  FakeBackend(this.routes);

  final Map<String, Handler> routes;
  final calls = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    calls.add(key);
    final handler = routes[key];
    final (status, body) = handler == null
        ? (
            404,
            {
              'error': {'code': 'NOT_FOUND', 'message': 'no fake for $key', 'details': {}},
            },
          )
        : handler(options);
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

Map<String, dynamic> bodyOf(RequestOptions request) => jsonDecode(request.data as String) as Map<String, dynamic>;

Map<String, Object> appConfig({String minVersion = '0.1.0'}) => {
  'minVersions': {'patientAndroid': minVersion, 'patientIos': minVersion, 'partnerAndroid': minVersion},
  'storeUrls': {
    'patientAndroid': 'https://play.google.com/store/apps/details?id=in.wellwish.patient',
    'patientIos': 'https://apps.apple.com',
    'partnerAndroid': 'https://play.google.com',
  },
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

Map<String, Object?> me({String fullName = '', bool complete = false, bool consents = true, String language = 'en'}) =>
    {
      'id': 'u-1',
      'phone': '+919876543210',
      'fullName': fullName,
      'dob': complete ? '1990-05-17' : null,
      'gender': complete ? 'FEMALE' : '',
      'language': language,
      'selfMemberId': 'm-1',
      'profileComplete': complete,
      'consentsNeeded': consents
          ? [
              {'type': 'TERMS', 'version': '2026-10'},
              {'type': 'PRIVACY', 'version': '2026-10'},
              {'type': 'HEALTH_DATA', 'version': '2026-10'},
            ]
          : <Object>[],
      'googleLinked': false,
    };

const tokens = {'accessToken': 'access', 'refreshToken': 'refresh', 'expiresIn': 900};

class _NoGoogle implements GoogleSignInService {
  @override
  bool get enabled => false;

  @override
  Future<String?> idToken() async => null;
}

/// A real 1×1 PNG (the upload sheet shows a preview of the picked photo).
const onePixelPng = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

/// Camera / gallery / PDF picker that returns a small PNG (or a PDF).
class FakePicker implements FilePickerService {
  final picked = <PickSource>[];

  @override
  Future<PickedFile?> pick(PickSource source) async {
    picked.add(source);
    return source == PickSource.pdf
        ? PickedFile(bytes: Uint8List.fromList(utf8.encode('%PDF-1.4 test')), mime: 'application/pdf')
        : PickedFile(bytes: base64Decode(onePixelPng), mime: 'image/png');
  }
}

/// Records PDFs the app asked the phone to open (no browser, no download in tests).
class FakeOpener implements DocumentOpener {
  final opened = <String>[];

  @override
  Future<bool> openPdf({required String url, required String documentId}) async {
    opened.add(documentId);
    return true;
  }
}

/// "Use my current location" answers with a point in Bhubaneswar.
class FakeLocation implements LocationService {
  @override
  Future<LocationResult> current() async => (position: (20.29, 85.84), problem: null, mock: false);
}

/// Razorpay Checkout in tests: answers with the next of [outcomes] (paid by default).
class FakeCheckout implements PaymentCheckout {
  FakeCheckout([List<CheckoutOutcome>? outcomes]) : outcomes = outcomes ?? [];

  final List<CheckoutOutcome> outcomes;
  final opened = <CheckoutOut>[];

  @override
  Future<CheckoutOutcome> open({
    required CheckoutOut checkout,
    required String description,
    String contact = '',
  }) async {
    opened.add(checkout);
    if (outcomes.isNotEmpty) return outcomes.removeAt(0);
    return CheckoutPaid(orderId: checkout.orderId, paymentId: 'pay_test_1', signature: 'sig');
  }
}

/// The live socket: tests push server messages into [messages].
class FakeSocket implements PatientSocket {
  final messages = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> connect(String accessToken) => messages.stream;

  @override
  int? closeCode;

  @override
  Future<void> close() async {}
}

/// Pumps the patient app against [backend]. [loggedIn] pre-saves tokens.
Future<InMemoryTokenStorage> pumpPatientApp(
  WidgetTester tester,
  FakeBackend backend, {
  bool loggedIn = false,
  String version = '0.1.0',
  FilePickerService? picker,
  FakeOpener? opener,
  PaymentCheckout? checkout,
  FakeSocket? socket,
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
  if (loggedIn) await storage.save(accessToken: 'access', refreshToken: 'refresh');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        tokenStorageProvider.overrideWithValue(storage),
        deviceIdStoreProvider.overrideWithValue(const FixedDeviceIdStore('device-0001')),
        refreshDioProvider.overrideWith((ref) => createRefreshClient(config)..httpClientAdapter = backend),
        apiClientProvider.overrideWith(
          (ref) => createApiClient(config, session: ref.watch(sessionManagerProvider))..httpClientAdapter = backend,
        ),
        appVersionProvider.overrideWith((ref) async => version),
        smsCodeReaderProvider.overrideWithValue(const NoSmsCodeReader()),
        googleSignInServiceProvider.overrideWithValue(_NoGoogle()),
        locationPermissionProvider.overrideWithValue(() async {}),
        filePickerProvider.overrideWithValue(picker ?? FakePicker()),
        locationServiceProvider.overrideWithValue(FakeLocation()),
        documentOpenerProvider.overrideWithValue(opener ?? FakeOpener()),
        uploadHttpProvider.overrideWith((ref) => Dio()..httpClientAdapter = backend),
        mapTilesEnabledProvider.overrideWithValue(false), // no network map tiles in tests
        paymentCheckoutProvider.overrideWithValue(checkout ?? FakeCheckout()),
        patientSocketProvider.overrideWithValue(socket ?? FakeSocket()),
        // §6.20: the legal pages open in the browser; here they are only written down
        openPublicPageProvider.overrideWithValue((url, language) async {
          openedPages?.add('$url?l=$language');
          return true;
        }),
      ],
      child: const PatientApp(),
    ),
  );
  await tester.pumpAndSettle();
  return storage;
}

/// Scrolls [finder] fully into view (inside the list on screen) before a tap. Lists build
/// lazily, so first scroll down until it exists.
Future<void> scrollTo(WidgetTester tester, Finder finder, {bool up = false}) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(finder, up ? -300 : 300, scrollable: find.byType(Scrollable).hitTestable().first);
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}
