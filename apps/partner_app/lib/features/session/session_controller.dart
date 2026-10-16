import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../jobs/jobs_providers.dart';
import '../jobs/visit_controller.dart';

enum SessionStatus { starting, startupFailed, updateRequired, loggedOut, loggedIn }

class SessionState {
  const SessionState({
    required this.status,
    this.me,
    this.endReason,
    this.jobOver = false,
    this.storeUrl,
    this.supportPhone,
  });

  final SessionStatus status;

  /// The logged-in partner (GET /v1/partner/me). `partnerStatus` is null until they register.
  final PartnerMeOut? me;
  final SessionEndReason? endReason;

  /// The session ended because a temporary partner's job is over (§6.19, revoke reason
  /// `JOB_OVER`): the login screen thanks them.
  final bool jobOver;
  final String? storeUrl;

  /// WellWish support number (from app-config), for the status screen's call button.
  final String? supportPhone;

  SessionState copyWith({PartnerMeOut? me}) => SessionState(
    status: status,
    me: me ?? this.me,
    endReason: endReason,
    jobOver: jobOver,
    storeUrl: storeUrl,
    supportPhone: supportPhone,
  );
}

/// §6.19: a temporary partner, for one booking only (their home is that job).
bool isTemporary(String? partnerStatus) => partnerStatus == 'TEMPORARY';

/// Not registered: no role chosen yet, a temporary partner whose job is over (§6.19), or someone
/// who deleted their partner account and still has the number as a patient (§6.20): the app
/// shows them the "choose a role" start, like anyone who isn't registered.
bool isUnregistered(String? partnerStatus) =>
    partnerStatus == null || partnerStatus == 'TEMP_ENDED' || partnerStatus == 'DELETED';

/// Login state of the partner app. Partners keep ONE active device (ARCHITECTURE §6.4): when the
/// same number logs in elsewhere, the server pushes `session.revoked` over the socket and this
/// phone goes back to the login screen at once. If the socket was down, the next API call
/// fails to refresh and does the same.
class SessionController extends Notifier<SessionState> {
  StreamSubscription<SessionEndReason>? _ended;
  String? _supportPhone;
  StreamSubscription<Map<String, dynamic>>? _socket;
  Timer? _reconnect;
  int _retries = 0;
  bool _connecting = false;

  @override
  SessionState build() {
    _ended = ref.watch(sessionManagerProvider).sessionEnded.listen((reason) {
      // the socket and a refused refresh may both report the same end
      final endedForJob = state.status == SessionStatus.loggedOut && state.jobOver;
      _closeSocket();
      // logged out or ended (also a temporary partner's job being over): no more location
      // sharing or retries (what's kept waits for this partner's next login; another partner
      // on this phone never sends or sees it)
      unawaited(ref.container.read(visitControllerProvider.notifier).sessionEnded());
      state = SessionState(
        status: SessionStatus.loggedOut,
        endReason: reason,
        jobOver: reason == SessionEndReason.jobOver || endedForJob,
      );
    });
    ref.onDispose(() {
      _ended?.cancel();
      _reconnect?.cancel();
      _socket?.cancel(); // the socket itself is closed by partnerSocketProvider
    });
    return const SessionState(status: SessionStatus.starting);
  }

  Future<void> start() async {
    state = const SessionState(status: SessionStatus.starting);
    try {
      final config = (await ref.read(publicApiProvider).publicAppConfig()).data!;
      _supportPhone = config.supportPhone;
      final version = await ref.read(appVersionProvider.future);
      if (isOlderVersion(version, config.minVersions.partnerAndroid)) {
        state = SessionState(status: SessionStatus.updateRequired, storeUrl: config.storeUrls.partnerAndroid);
        return;
      }
      if (!await ref.read(sessionManagerProvider).hasSession()) {
        state = const SessionState(status: SessionStatus.loggedOut);
        return;
      }
      await _loadMe();
    } catch (e) {
      if (state.status == SessionStatus.loggedOut) return; // refresh failed: reason kept
      final error = toApiException(e);
      state = SessionState(status: error.isUnauthorized ? SessionStatus.loggedOut : SessionStatus.startupFailed);
    }
  }

  /// After a successful OTP login. The tokens are saved already: if loading the profile fails
  /// (network), show "try again" (splash), which picks the session up again.
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

  /// The app came back to the foreground: make sure this phone is still the active one.
  Future<void> resumed() async {
    if (state.status != SessionStatus.loggedIn) return;
    jobsChanged(ref.invalidate); // offers may have changed meanwhile
    unawaited(ref.read(visitControllerProvider.notifier).online()); // steps kept offline
    try {
      await _loadMe(); // also reconnects the socket if it was lost
    } catch (_) {
      // Offline: try again next time. A revoked session is handled by the token refresh.
    }
  }

  Future<void> _loadMe() async {
    final me = (await ref.read(partnerApiProvider).partnerMeGet()).data!;
    ref.read(visitControllerProvider.notifier).signedIn(me.id); // this partner's kept steps
    state = SessionState(status: SessionStatus.loggedIn, me: me, supportPhone: _supportPhone);
    await _connectSocket();
  }

  /// The live socket: `session.revoked`, and from Phase 7 `offer.new`, `offer.withdrawn` and
  /// `booking.updated` (the offers and jobs reload); `location.rejected` (Phase 8: a job that's
  /// over stops sharing). Reconnects after 1 s, 2 s, 5 s, then every
  /// 10 s; after a reconnect the screens reload, in case a message was missed meanwhile.
  Future<void> _connectSocket() async {
    if (_socket != null || _connecting) return;
    _connecting = true;
    try {
      final token = await ref.read(sessionManagerProvider).accessToken();
      if (token == null || state.status != SessionStatus.loggedIn) return;
      final reconnected = _retries > 0;
      _socket = ref
          .read(partnerSocketProvider)
          .connect(token)
          .listen(
            (message) {
              switch (message['type']) {
                case 'auth.ok':
                  _retries = 0;
                  ref.read(socketReadyProvider.notifier).set(true);
                  if (reconnected) jobsChanged(ref.invalidate);
                  // steps and points kept while offline go up now
                  unawaited(ref.read(visitControllerProvider.notifier).online());
                case 'session.revoked':
                  _socketEnded = true;
                  ref.read(sessionManagerProvider).end(revokedReason(message['data']));
                case 'offer.new' || 'offer.withdrawn' || 'offer.reminder' || 'booking.updated':
                  jobsChanged(ref.invalidate);
                  // §6.19: not approved, so this may be a temporary job given to them just now
                  // (on the role choice after an earlier one): load who they are again
                  if (state.me?.partnerStatus != 'APPROVED') unawaited(reloadMe());
                case 'location.rejected':
                  final data = message['data'];
                  if (data is Map) {
                    ref
                        .read(visitControllerProvider.notifier)
                        .pointRefused('${data['bookingId']}', '${data['reason']}');
                  }
              }
            },
            onError: (_) => _socketLost(),
            onDone: () => _socketLost(ref.read(partnerSocketProvider).closeCode),
            cancelOnError: true,
          );
    } catch (_) {
      _socketLost();
    } finally {
      _connecting = false;
    }
  }

  bool _socketEnded = false;

  /// Lost: reconnect after 1 s, 2 s, 5 s, then every 10 s. A refused token (4001: it ran out
  /// after 15 minutes) is refreshed first; an ended session (4003) never reconnects.
  Future<void> _socketLost([int? closeCode]) async {
    _socket = null;
    ref.read(socketReadyProvider.notifier).set(false);
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
    ref.read(socketReadyProvider.notifier).set(false);
    _socketEnded = false;
    _reconnect?.cancel();
    _retries = 0;
    _socket?.cancel();
    _socket = null;
    ref.read(partnerSocketProvider).close();
  }

  Future<void> _registerDevice() async {
    try {
      await ref
          .read(partnerApiProvider)
          .partnerDeviceRegister(
            deviceIn: DeviceIn(
              deviceId: await ref.read(deviceIdStoreProvider).deviceId(),
              platform: DeviceInPlatformEnum.android, // Android only at launch (§17 #12)
              appVersion: await ref.read(appVersionProvider.future),
            ),
          );
    } catch (_) {
      // Not critical: tried again at the next login.
    }
  }

  /// The partner's status or role changed (registration step, submit): the router follows.
  void partnerChanged(String status, String role) {
    final me = state.me;
    if (me == null || (me.partnerStatus == status && me.role == role)) return;
    state = state.copyWith(
      me: me.copyWith(partnerStatus: status, role: role),
    );
  }

  /// The app's language (§5): English, Hindi or Odia, for the app and the messages the partner
  /// gets (inbox, push, email; SMS stay English). The app switches at once.
  Future<void> setLanguage(String code) async {
    final language = LanguageInLanguageEnum.values.firstWhere((l) => l.value == code);
    final me = (await ref.read(partnerApiProvider).partnerLanguageSet(languageIn: LanguageIn(language: language)))
        .data!;
    if (state.status == SessionStatus.loggedIn) state = state.copyWith(me: me);
  }

  /// Reload /me (pull to refresh on the status screen: maybe approved meanwhile).
  Future<void> reloadMe() async {
    if (state.status != SessionStatus.loggedIn) return;
    final me = (await ref.read(partnerApiProvider).partnerMeGet()).data!;
    state = state.copyWith(me: me);
  }

  Future<void> logout() => ref.read(authRepositoryProvider).logout();

  /// The Partner Terms and the Privacy Policy are accepted (§6.20): the router moves on.
  Future<void> acceptConsents(List<ConsentNeededOut> needed) async {
    final me =
        (await ref
                .read(partnerApiProvider)
                .partnerConsentsAccept(
                  consentsIn: ConsentsIn(
                    items: [
                      for (final c in needed)
                        ConsentItemIn(type: ConsentItemInTypeEnum.values.byName(c.type.value), version: c.version),
                    ],
                  ),
                ))
            .data!;
    if (state.status == SessionStatus.loggedIn) state = state.copyWith(me: me);
  }

  /// "Delete my account" (§6.20): logged out on every phone at once; the personal data goes
  /// after the waiting time unless they log in again. 409 ACTIVE_JOBS while a job is theirs.
  Future<void> deleteAccount() async {
    final out = (await ref.read(partnerApiProvider).partnerDeleteAccount()).data!;
    // nothing was saved for this login (no role chosen): it is gone already, nothing to undo
    await ref.read(sessionManagerProvider).end(out.done ? SessionEndReason.accountErased : SessionEndReason.accountDeleted);
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionState>(SessionController.new);
