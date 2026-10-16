import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';

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
    app: LoginApp.partner,
  ),
);

final partnerApiProvider = Provider<PartnerApi>((ref) => PartnerApi(ref.watch(apiClientProvider)));

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

/// Reads the login code from the SMS on Android (ARCHITECTURE §6.2).
final smsCodeReaderProvider = Provider<SmsCodeReader>((ref) => SmartAuthSmsCodeReader());

/// The partner socket (/ws/partner/). The server pushes `session.revoked` here when the account
/// logs in on another phone.
abstract class PartnerSocket {
  Stream<Map<String, dynamic>> connect(String accessToken);

  /// Sends a message (live location during a job); false when not connected.
  bool send(String type, Map<String, dynamic> data);

  /// Why the last connection ended: [WWSocketClient.closeUnauthorized] (refresh the token,
  /// then reconnect) or [WWSocketClient.closeSessionRevoked] (don't). Null if unknown.
  int? get closeCode;

  Future<void> close();
}

class WWPartnerSocket implements PartnerSocket {
  WWPartnerSocket(this._client);

  final WWSocketClient _client;

  @override
  Stream<Map<String, dynamic>> connect(String accessToken) => _client.connect(audience: 'partner', token: accessToken);

  @override
  int? get closeCode => _client.closeCode;

  @override
  bool send(String type, Map<String, dynamic> data) => _client.send(type, data);

  @override
  Future<void> close() => _client.close();
}

final partnerSocketProvider = Provider<PartnerSocket>((ref) {
  final socket = WWPartnerSocket(WWSocketClient(ref.watch(appConfigProvider)));
  ref.onDispose(socket.close);
  return socket;
});

/// True once the live socket said `auth.ok`, false when it's down (live location then waits
/// on the phone and goes up in a batch).
class SocketReady extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool ready) => state = ready;
}

final socketReadyProvider = NotifierProvider<SocketReady, bool>(SocketReady.new);

/// Live location during a job (foreground service with its notification). Swapped in tests.
final locationTrackerProvider = Provider<LocationTracker>((ref) {
  final tracker = DeviceLocationTracker();
  ref.onDispose(tracker.stop);
  return tracker;
});

/// One-off location for a step tap.
final stepLocationProvider = Provider<LocationService>((ref) => DeviceLocation());

/// Android 13+: the location notification during a job needs this permission (the job still
/// works without it). Swapped in tests.
final notificationPermissionProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    try {
      await Permission.notification.request();
    } catch (_) {
      // not available here: carry on
    }
  },
);
