import 'dart:io' show HttpDate;

/// The server's time as best we know it (ARCHITECTURE §6.10): offer countdowns compare the
/// server's `timeoutAt` with this, not with the phone's own clock, which may be minutes off.
/// Every API answer's `Date` header updates the offset (whole seconds, good enough here).
class ServerClock {
  ServerClock._();

  static Duration _offset = Duration.zero;

  /// Now, corrected for the phone's clock being fast or slow.
  static DateTime now() => DateTime.now().add(_offset);

  /// From an HTTP `Date` header ("Sat, 10 Oct 2026 06:28:10 GMT"). Bad values are ignored.
  static void sync(String? dateHeader, {DateTime? receivedAt}) {
    if (dateHeader == null || dateHeader.isEmpty) return;
    try {
      final server = HttpDate.parse(dateHeader);
      _offset = server.difference(receivedAt ?? DateTime.now());
    } catch (_) {
      // not a valid date: keep the last offset
    }
  }

  /// Tests: back to the phone's clock.
  static void reset() => _offset = Duration.zero;
}
