import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// One point of the partner's route during a job (ARCHITECTURE §6.11).
class TrackPoint {
  const TrackPoint({
    required this.lat,
    required this.lng,
    required this.accuracy,
    required this.mock,
    required this.at,
  });

  final double lat;
  final double lng;
  final double accuracy;

  /// Android said it's a fake (mock) location: the server refuses it and tells the admin.
  final bool mock;
  final DateTime at;

  Map<String, dynamic> toJson() => {
    'lat': lat.toStringAsFixed(6),
    'lng': lng.toStringAsFixed(6),
    'accuracy': accuracy,
    'mock': mock,
    'at': at.toUtc().toIso8601String(),
  };

  static TrackPoint fromJson(Map<String, dynamic> json) => TrackPoint(
    lat: double.parse(json['lat'] as String),
    lng: double.parse(json['lng'] as String),
    accuracy: (json['accuracy'] as num).toDouble(),
    mock: json['mock'] == true,
    at: DateTime.parse(json['at'] as String),
  );
}

/// Live location during a job: only from "On the way" until "Completed", with a visible
/// notification ("Sharing your location with the patient for this visit"). Android runs it as
/// a foreground service, so it keeps going with the screen off.
abstract class LocationTracker {
  /// Starts sharing (asks for the location permission first). Points come every 10 s.
  Stream<TrackPoint> start({required String notificationTitle, required String notificationText});

  Future<void> stop();
}

class DeviceLocationTracker implements LocationTracker {
  StreamController<TrackPoint>? _out;
  StreamSubscription<Position>? _positions;

  @override
  Stream<TrackPoint> start({required String notificationTitle, required String notificationText}) {
    _out?.close();
    final out = StreamController<TrackPoint>.broadcast();
    _out = out;
    unawaited(_listen(out, notificationTitle, notificationText));
    return out.stream;
  }

  /// [out] is still the one to feed: not stopped or started again meanwhile (e.g. during the
  /// permission dialog). Otherwise nothing more is started, so no service is left running.
  bool _current(StreamController<TrackPoint> out) => identical(_out, out) && !out.isClosed;

  Future<void> _listen(StreamController<TrackPoint> out, String title, String text) async {
    var permission = await Geolocator.checkPermission();
    if (!_current(out)) return;
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (!_current(out)) return;
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      out.addError(StateError('location permission denied'));
      return;
    }
    final before = _positions;
    _positions = null;
    await before?.cancel();
    if (!_current(out)) return;
    _follow(out, title, text, fused: true);
  }

  /// The fused location failed: GPS only, once. Not from inside the failing stream's own error
  /// event: geolocator_android keeps one position stream until its last listener has gone, and
  /// a listener cancelled while that event is delivered only goes after it, so asking at once
  /// would get the same failed fused stream back. Hence: cancel, wait a turn, then ask.
  Future<void> _gpsOnly(StreamController<TrackPoint> out, String title, String text) async {
    final fused = _positions;
    _positions = null;
    await fused?.cancel();
    await Future<void>.delayed(Duration.zero);
    if (!_current(out) || _positions != null) return;
    _follow(out, title, text, fused: false);
  }

  /// [fused]: Android's fused location (GPS + Wi-Fi + mobile towers): GPS alone stops indoors,
  /// where partners wait at hospitals (Phase 8 phone test: 2.5 min without a point). If it
  /// fails (e.g. the user said no to "Location Accuracy"), the phone's own GPS takes over.
  /// Every 10 s, as a foreground service with its notification while the job runs (§6.11).
  /// The server still drops points less accurate than 50 m and fake (mock) ones.
  void _follow(StreamController<TrackPoint> out, String title, String text, {required bool fused}) {
    _positions =
        Geolocator.getPositionStream(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.high,
            forceLocationManager: !fused,
            intervalDuration: const Duration(seconds: 10),
            foregroundNotificationConfig: ForegroundNotificationConfig(
              notificationTitle: title,
              notificationText: text,
              enableWakeLock: true,
              setOngoing: true,
            ),
          ),
        ).listen(
          (p) {
            if (out.isClosed) return;
            out.add(
              TrackPoint(
                lat: p.latitude,
                lng: p.longitude,
                accuracy: p.accuracy,
                mock: p.isMocked,
                at: p.timestamp.toUtc(),
              ),
            );
          },
          onError: (Object e) {
            if (!_current(out)) return;
            if (fused) {
              unawaited(_gpsOnly(out, title, text));
            } else {
              out.addError(e); // GPS failed too: the app shows "Try again"
            }
          },
        );
  }

  @override
  Future<void> stop() async {
    // taken first: a start() while this one waits isn't stopped by it
    final positions = _positions;
    final out = _out;
    _positions = null;
    _out = null;
    await positions?.cancel();
    await out?.close();
  }
}
