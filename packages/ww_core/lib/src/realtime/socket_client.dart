import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/app_config.dart';

/// Live updates over WebSocket (ARCHITECTURE §6.14).
///
/// Connects to `/ws/<audience>/`, sends the JWT as the FIRST message (never in the URL),
/// then exposes incoming `{"type": ..., "data": ...}` messages as a stream. A ping every 10 s
/// notices a dead mobile connection within about 20 s (it was 25 s: up to ~50 s of a partner's
/// live points went into a dead socket; PHASES 9.11). When the stream ends, [closeCode] says why: 4001 = the
/// token was refused (refresh it, then reconnect), 4003 = the session was ended (don't).
/// The apps reconnect with backoff (1 s, 2 s, 5 s, then every 10 s) and re-fetch over REST.
class WWSocketClient {
  WWSocketClient(this.config, {WebSocketChannel Function(Uri uri)? connect}) : _connect = connect ?? _withPing;

  static const closeUnauthorized = 4001;
  static const closeSessionRevoked = 4003;

  static WebSocketChannel _withPing(Uri uri) => IOWebSocketChannel.connect(uri, pingInterval: pingInterval);

  static const pingInterval = Duration(seconds: 10);

  final AppConfig config;
  final WebSocketChannel Function(Uri uri) _connect;
  WebSocketChannel? _channel;

  /// e.g. `ws://10.0.2.2:8000/ws/patient/`
  Uri endpoint(String audience) => Uri.parse('${config.wsBaseUrl}/ws/$audience/');

  Stream<Map<String, dynamic>> connect({required String audience, required String token}) {
    final channel = _connect(endpoint(audience));
    _channel = channel;
    // A refused connection also ends [channel.stream] with an error (the caller reconnects);
    // without this, `ready` would report it again as an unhandled error.
    unawaited(channel.ready.then((_) {}, onError: (Object _) {}));
    channel.sink.add(jsonEncode({'type': 'auth', 'token': token}));
    return channel.stream
        .map((raw) => jsonDecode(raw as String))
        .where((msg) => msg is Map<String, dynamic>)
        .cast<Map<String, dynamic>>();
  }

  /// Why the last connection ended (null while open or if unknown).
  int? get closeCode => _channel?.closeCode;

  /// Sends a message; false when there's no open connection (the caller keeps it for later).
  bool send(String type, Map<String, dynamic> data) {
    final channel = _channel;
    if (channel == null || channel.closeCode != null) return false;
    try {
      channel.sink.add(jsonEncode({'type': type, 'data': data}));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> close() async {
    await _channel?.sink.close();
    _channel = null;
  }
}
