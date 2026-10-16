import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../booking/booking_flow.dart';
import '../notifications/notifications_screen.dart';
import '../visit/live_tracking_screen.dart';

enum SessionStatus {
  /// Splash: checking the app version and the saved login.
  starting,

  /// Splash couldn't reach the server (shows "try again").
  startupFailed,

  /// This app version is too old (force-update screen).
  updateRequired,
  loggedOut,
  loggedIn,
}

class SessionState {
  const SessionState({
    required this.status,
    this.me,
    this.endReason,
    this.storeUrl,
    this.askLocation = false,
    this.deletionDueAt,
  });

  final SessionStatus status;

  /// The logged-in patient (GET /v1/patient/me).
  final PatientMeOut? me;

  /// Why the last session ended, so the login screen can say so.
  final SessionEndReason? endReason;

  /// Store link for the force-update screen.
  final String? storeUrl;

  /// Sign-up just finished: show the location permission step once (W-P1).
  final bool askLocation;

  /// After "delete my account": when the data goes (the login screen shows the date).
  final DateTime? deletionDueAt;

  bool get needsProfile => me != null && !me!.profileComplete;

  bool get needsConsent => me != null && me!.consentsNeeded.isNotEmpty;

  SessionState copyWith({PatientMeOut? me, bool? askLocation}) => SessionState(
    status: status,
    me: me ?? this.me,
    endReason: endReason,
    storeUrl: storeUrl,
    askLocation: askLocation ?? this.askLocation,
  );
}

/// Who is logged in, and the app-wide startup (P01 Splash: version check, token refresh).
/// The router listens to this and sends the user to the right screen.
class SessionController extends Notifier<SessionState> {
  StreamSubscription<SessionEndReason>? _ended;
  DateTime? _deletionDueAt;
  StreamSubscription<Map<String, dynamic>>? _socket;
  Timer? _reconnect;
  int _retries = 0;
  bool _connecting = false;

  @override
  SessionState build() {
    _ended = ref.watch(sessionManagerProvider).sessionEnded.listen((reason) {
      _closeSocket();
      // the next person on this phone never sees this one's bell (review, 16 Oct 2026)
      ref.container.invalidate(unreadCountProvider);
      ref.container.invalidate(notificationsProvider);
      state = SessionState(
        status: SessionStatus.loggedOut,
        endReason: reason,
        deletionDueAt: reason == SessionEndReason.accountDeleted ? _deletionDueAt : null,
      );
    });
    ref.onDispose(() {
      _ended?.cancel();
      _reconnect?.cancel();
      _socket?.cancel(); // the socket itself is closed by patientSocketProvider
    });
    return const SessionState(status: SessionStatus.starting);
  }

  PatientApi get _patientApi => ref.read(patientApiProvider);

  /// Splash: force-update check, then the saved session (refreshing the token if needed).
  Future<void> start() async {
    state = const SessionState(status: SessionStatus.starting);
    try {
      final config = (await ref.read(publicApiProvider).publicAppConfig()).data!;
      final version = await ref.read(appVersionProvider.future);
      final ios = ref.read(platformNameProvider) == 'ios';
      final minimum = ios ? config.minVersions.patientIos : config.minVersions.patientAndroid;
      if (isOlderVersion(version, minimum)) {
        state = SessionState(
          status: SessionStatus.updateRequired,
          storeUrl: ios ? config.storeUrls.patientIos : config.storeUrls.patientAndroid,
        );
        return;
      }
      if (!await ref.read(sessionManagerProvider).hasSession()) {
        state = const SessionState(status: SessionStatus.loggedOut);
        return;
      }
      await _loadMe();
    } catch (e) {
      // A failed refresh has already logged out (with the reason): keep that.
      if (state.status == SessionStatus.loggedOut) return;
      final error = toApiException(e);
      state = SessionState(status: error.isUnauthorized ? SessionStatus.loggedOut : SessionStatus.startupFailed);
    }
  }

  /// After a successful OTP or Google login. The tokens are saved already: if loading the
  /// profile fails (network), show "try again" (splash), which picks the session up again.
  Future<void> loggedIn() async {
    try {
      await _loadMe();
    } catch (_) {
      // Tokens gone = the session was ended (the login screen says why). Otherwise retry.
      if (await ref.read(sessionManagerProvider).hasSession()) {
        state = const SessionState(status: SessionStatus.startupFailed);
      }
      return;
    }
    unawaited(_registerDevice());
  }

  Future<void> _loadMe() async {
    final me = (await _patientApi.patientMeGet()).data!;
    ref.container.invalidate(unreadCountProvider); // this person's count
    state = SessionState(status: SessionStatus.loggedIn, me: me);
    unawaited(_connectSocket());
  }

  /// The live socket (§10.4): `booking.updated` when a partner accepts or the booking's time,
  /// status or step changes; that booking, the Home card and My bookings reload.
  /// `booking.location`: the partner's point during the visit (the live map). Reconnects after 1 s,
  /// 2 s, 5 s, then every 10 s; after a reconnect the screens reload, in case a message was
  /// missed meanwhile.
  Future<void> _connectSocket() async {
    if (_socket != null || _connecting) return;
    _connecting = true;
    try {
      final token = await ref.read(sessionManagerProvider).accessToken();
      if (token == null || state.status != SessionStatus.loggedIn) return;
      final reconnected = _retries > 0;
      _socket = ref
          .read(patientSocketProvider)
          .connect(token)
          .listen(
            (message) {
              switch (message['type']) {
                case 'auth.ok':
                  _retries = 0;
                  if (reconnected) {
                    _bookingChanged(null);
                    ref.container.read(unreadCountProvider.notifier).reload();
                  }
                case 'notification.new':
                  // an inbox message was saved (v2.32): the bell's number, at once
                  final unread = message['data'] is Map ? message['data']['unread'] : null;
                  if (unread is int) ref.container.read(unreadCountProvider.notifier).set(unread);
                  ref.container.invalidate(notificationsProvider);
                case 'booking.updated':
                  final data = message['data'];
                  _bookingChanged(data is Map ? data['bookingId']?.toString() : null);
                case 'booking.location':
                  final data = message['data'];
                  if (data is Map) {
                    try {
                      ref.container
                          .read(bookingLocationsProvider)
                          .add(LiveLocationOut.fromJson(Map<String, dynamic>.from(data)));
                    } catch (_) {
                      // a message the app doesn't understand
                    }
                  }
                case 'session.revoked':
                  _socketEnded = true;
                  ref.read(sessionManagerProvider).end(revokedReason(message['data']));
              }
            },
            onError: (_) => _socketLost(),
            onDone: () => _socketLost(ref.read(patientSocketProvider).closeCode),
            cancelOnError: true,
          );
    } catch (_) {
      _socketLost();
    } finally {
      _connecting = false;
    }
  }

  bool _socketEnded = false;

  /// Through the container: the Home card watches this session, so this provider's own `ref`
  /// can't invalidate it.
  void _bookingChanged(String? bookingId) {
    final container = ref.container;
    bookingsChanged(container);
    if (bookingId == null) {
      container.invalidate(bookingDetailProvider);
    } else {
      container.invalidate(bookingDetailProvider(bookingId));
    }
  }

  /// Lost: reconnect after 1 s, 2 s, 5 s, then every 10 s. A refused token (4001: it ran out
  /// after 15 minutes) is refreshed first; an ended session (4003) never reconnects.
  Future<void> _socketLost([int? closeCode]) async {
    _socket = null;
    if (state.status != SessionStatus.loggedIn || _socketEnded) return;
    if (closeCode == WWSocketClient.closeSessionRevoked) return;
    if (closeCode == WWSocketClient.closeUnauthorized) {
      final manager = ref.read(sessionManagerProvider);
      if (!await manager.refresh() && !await manager.hasSession()) return; // logged out
    }
    if (state.status != SessionStatus.loggedIn) return;
    const waits = [1, 2, 5, 10];
    final seconds = waits[_retries < waits.length ? _retries : waits.length - 1];
    _retries++;
    _reconnect?.cancel();
    _reconnect = Timer(Duration(seconds: seconds), () => _connectSocket());
  }

  void _closeSocket() {
    _socketEnded = false;
    _reconnect?.cancel();
    _retries = 0;
    _socket?.cancel();
    _socket = null;
    ref.read(patientSocketProvider).close();
  }

  /// Profile setup returns the updated profile.
  void updateMe(PatientMeOut me) => state = state.copyWith(me: me);

  /// After editing yourself as a family member (P28): the profile changed on the server.
  Future<void> reloadMe() async {
    if (state.status != SessionStatus.loggedIn) return;
    state = state.copyWith(me: (await _patientApi.patientMeGet()).data!);
  }

  /// Consents accepted: reload; at the first sign-up the location step comes next.
  Future<void> consentsAccepted({bool askLocation = true}) async {
    final me = (await _patientApi.patientMeGet()).data!;
    state = state.copyWith(me: me, askLocation: askLocation);
  }

  void locationStepDone() => state = state.copyWith(askLocation: false);

  Future<void> _registerDevice() async {
    try {
      await _patientApi.patientDeviceRegister(
        deviceIn: DeviceIn(
          deviceId: await ref.read(deviceIdStoreProvider).deviceId(),
          platform: ref.read(platformNameProvider) == 'ios' ? DeviceInPlatformEnum.ios : DeviceInPlatformEnum.android,
          appVersion: await ref.read(appVersionProvider.future),
          // The push token is added with Firebase (notifications phase).
        ),
      );
    } catch (_) {
      // Not critical: tried again at the next login.
    }
  }

  Future<void> logout({bool everywhere = false}) => ref.read(authRepositoryProvider).logout(everywhere: everywhere);

  /// P27 "Delete my account": the server logs this account out everywhere and erases the data
  /// after 7 days (logging in again before then keeps it). Ends the session here too.
  Future<void> deleteAccount() async {
    _deletionDueAt = (await _patientApi.patientDeleteAccount()).data!.dueAt;
    await ref.read(sessionManagerProvider).end(SessionEndReason.accountDeleted);
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(SessionController.new);
