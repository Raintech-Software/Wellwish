import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';

import 'features/auth/google_sign_in_service.dart';

/// Set per flavor in bootstrap().
final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError('appConfigProvider is overridden in bootstrap()'),
);

final tokenStorageProvider = Provider<TokenStorage>((ref) => SecureTokenStorage());

final deviceIdStoreProvider = Provider<DeviceIdStore>((ref) => SecureDeviceIdStore());

/// Plain client used only for refreshing tokens (tests swap its adapter).
final refreshDioProvider = Provider<Dio>((ref) => createRefreshClient(ref.watch(appConfigProvider)));

final sessionManagerProvider = Provider<SessionManager>((ref) {
  final manager = SessionManager(tokens: ref.watch(tokenStorageProvider), refreshDio: ref.watch(refreshDioProvider));
  ref.onDispose(manager.dispose);
  return manager;
});

/// The Dio every API call goes through (auth header, token refresh, error mapping).
final apiClientProvider = Provider<Dio>(
  (ref) => createApiClient(ref.watch(appConfigProvider), session: ref.watch(sessionManagerProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    dio: ref.watch(apiClientProvider),
    session: ref.watch(sessionManagerProvider),
    deviceIds: ref.watch(deviceIdStoreProvider),
    app: LoginApp.patient,
  ),
);

final patientApiProvider = Provider<PatientApi>((ref) => PatientApi(ref.watch(apiClientProvider)));

final publicApiProvider = Provider<PublicApi>((ref) => PublicApi(ref.watch(apiClientProvider)));

/// The public pages' links (legal pages, account deletion; ARCHITECTURE §6.20), from the
/// app-config. Asked once per app start.
final legalUrlsProvider = FutureProvider<LegalUrlsOut>(
  (ref) async => (await ref.watch(publicApiProvider).publicAppConfig()).data!.legalUrls,
);

/// Opens a public page in the phone's browser (swapped in tests).
final openPublicPageProvider = Provider<Future<bool> Function(String url, String language)>((ref) => openPublicPage);

/// This app's version, e.g. "0.1.0" (for the force-update check).
final appVersionProvider = FutureProvider<String>((ref) async => (await PackageInfo.fromPlatform()).version);

/// "android" / "ios", as the server expects it.
final platformNameProvider = Provider<String>((ref) => !kIsWeb && Platform.isIOS ? 'ios' : 'android');

/// Reads the login code from the SMS on Android (ARCHITECTURE §6.2).
final smsCodeReaderProvider = Provider<SmsCodeReader>((ref) => SmartAuthSmsCodeReader());

final googleSignInServiceProvider = Provider<GoogleSignInService>(
  (ref) => PluginGoogleSignInService(ref.watch(appConfigProvider)),
);

/// Camera, gallery and PDF picker (swapped for a fake in tests).
final filePickerProvider = Provider<FilePickerService>((ref) => DeviceFilePicker());

/// The phone's location ("use my current location" on the address screen).
final locationServiceProvider = Provider<LocationService>((ref) => DeviceLocation());

/// Plain client for uploads: no auth header, the upload URL itself is signed (§6.8).
final uploadHttpProvider = Provider<Dio>((ref) => Dio());

/// The patient socket (/ws/patient/): `booking.updated` when a partner accepts, the time or
/// status changes (§10.4). Swapped for a fake in tests.
abstract class PatientSocket {
  Stream<Map<String, dynamic>> connect(String accessToken);

  /// Why the last connection ended: [WWSocketClient.closeUnauthorized] (refresh the token,
  /// then reconnect) or [WWSocketClient.closeSessionRevoked] (don't). Null if unknown.
  int? get closeCode;

  Future<void> close();
}

class WWPatientSocket implements PatientSocket {
  WWPatientSocket(this._client);

  final WWSocketClient _client;

  @override
  Stream<Map<String, dynamic>> connect(String accessToken) => _client.connect(audience: 'patient', token: accessToken);

  @override
  int? get closeCode => _client.closeCode;

  @override
  Future<void> close() => _client.close();
}

final patientSocketProvider = Provider<PatientSocket>((ref) {
  final socket = WWPatientSocket(WWSocketClient(ref.watch(appConfigProvider)));
  ref.onDispose(socket.close);
  return socket;
});
