import 'package:geolocator/geolocator.dart';

/// Why the location couldn't be read.
enum LocationProblem { denied, off, unavailable }

/// The phone's location: (lat, lng) or the problem. `mock`: Android said the position is fake
/// (a "mock location" app); the server doesn't keep it and tells the admin (§12).
typedef LocationResult = ({(double, double)? position, LocationProblem? problem, bool mock});

abstract class LocationService {
  Future<LocationResult> current();
}

class DeviceLocation implements LocationService {
  @override
  Future<LocationResult> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return (position: null, problem: LocationProblem.off, mock: false);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return (position: null, problem: LocationProblem.denied, mock: false);
      }
      // The phone's own GPS (LocationManager), not Google's fused provider: that one asks the
      // user to switch on "Location Accuracy" and fails if they say no.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          timeLimit: const Duration(seconds: 20),
        ),
      );
      return (position: (position.latitude, position.longitude), problem: null, mock: position.isMocked);
    } catch (_) {
      final last = await Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
          .catchError((Object _) => null);
      if (last != null) return (position: (last.latitude, last.longitude), problem: null, mock: last.isMocked);
      return (position: null, problem: LocationProblem.unavailable, mock: false);
    }
  }
}
