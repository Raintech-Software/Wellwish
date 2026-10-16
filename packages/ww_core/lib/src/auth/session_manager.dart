import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ww_api/ww_api.dart';

import '../api/api_exception.dart';
import '../storage/token_storage.dart';

/// Why the user is no longer logged in. Screens pick the message from this.
enum SessionEndReason {
  /// The user tapped Log out.
  loggedOut,

  /// The refresh token expired or is unknown: just log in again.
  expired,

  /// Partner app: the same account logged in on another phone (ARCHITECTURE §6.4).
  loggedInElsewhere,

  /// Revoked for another reason (refresh token reused…).
  revoked,

  /// Patient app: the user asked to delete their account (ARCHITECTURE §12). Logging in again
  /// within the grace period keeps it.
  accountDeleted,

  /// Partner app: a login with nothing saved (no role chosen) was deleted at once (§6.20).
  accountErased,

  /// Blocked by WellWish: a patient blocked for abuse (§9.1), a partner suspended or closed.
  accountBlocked,

  /// Partner app: a temporary partner's one job is over (§6.19); the login screen thanks them.
  jobOver,
}

/// Owns the tokens: saves them after login, refreshes the access token when it expires
/// (one refresh at a time, however many requests failed), and tells the app when the
/// session is over.
class SessionManager {
  SessionManager({required this.tokens, required Dio refreshDio}) : _authApi = AuthApi(refreshDio);

  final TokenStorage tokens;
  final AuthApi _authApi;
  final _ended = StreamController<SessionEndReason>.broadcast();
  Future<bool>? _refreshing;

  /// Fires once each time a session ends (logout, expiry, logged in elsewhere).
  Stream<SessionEndReason> get sessionEnded => _ended.stream;

  Future<String?> accessToken() => tokens.readAccessToken();

  Future<bool> hasSession() async => (await tokens.readRefreshToken())?.isNotEmpty ?? false;

  Future<void> save(TokenOut pair) => tokens.save(accessToken: pair.accessToken, refreshToken: pair.refreshToken);

  /// Gets a new access token. Returns false if there's no session any more (the app has been
  /// told through [sessionEnded]) or the server couldn't be reached (the session is kept).
  Future<bool> refresh() {
    return _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);
  }

  Future<bool> _doRefresh() async {
    final refreshToken = await tokens.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;
    try {
      final response = await _authApi.authRefresh(refreshIn: RefreshIn(refreshToken: refreshToken));
      await save(response.data!);
      return true;
    } on DioException catch (e) {
      final error = ApiException.fromDio(e);
      // offline, the server down, too many requests or a timeout: the session is still good
      final status = error.statusCode ?? 0;
      if (error.isConnectivity || status >= 500 || status == 429 || status == 408) return false;
      await end(_reasonFor(error));
      return false;
    }
  }

  static SessionEndReason _reasonFor(ApiException error) {
    if (error.code == 'ACCOUNT_BLOCKED') return SessionEndReason.accountBlocked;
    if (error.code == 'SESSION_REVOKED') return revokedReason(error.details);
    return SessionEndReason.expired;
  }

  /// Forget the tokens and tell the app (which then shows the login screen).
  Future<void> end(SessionEndReason reason) async {
    await tokens.clear();
    _ended.add(reason);
  }

  Future<void> dispose() => _ended.close();
}

/// The server's reason for ending a session (§6.4), from a live `session.revoked` message or a
/// refused refresh (401 SESSION_REVOKED {reason}).
SessionEndReason revokedReason(Object? data) {
  final reason = data is Map ? data['reason'] : null;
  return switch (reason) {
    'LOGGED_IN_ELSEWHERE' => SessionEndReason.loggedInElsewhere,
    'LOGOUT' => SessionEndReason.loggedOut,
    'ACCOUNT_BLOCKED' => SessionEndReason.accountBlocked,
    'ACCOUNT_DELETED' => SessionEndReason.accountDeleted,
    'JOB_OVER' => SessionEndReason.jobOver,
    _ => SessionEndReason.revoked,
  };
}
