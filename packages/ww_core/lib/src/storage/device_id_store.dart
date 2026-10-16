import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A random id for this app install, sent with logins so the server can tell devices apart
/// (partners keep one active device, ARCHITECTURE §6.4). Not a hardware id.
abstract class DeviceIdStore {
  Future<String> deviceId();
}

class SecureDeviceIdStore implements DeviceIdStore {
  SecureDeviceIdStore({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'ww.device_id';
  final FlutterSecureStorage _storage;
  String? _cached;

  @override
  Future<String> deviceId() async {
    if (_cached != null) return _cached!;
    var id = await _storage.read(key: _key);
    if (id == null || id.isEmpty) {
      id = newDeviceId();
      await _storage.write(key: _key, value: id);
    }
    return _cached = id;
  }
}

/// For tests and previews.
class FixedDeviceIdStore implements DeviceIdStore {
  const FixedDeviceIdStore(this.id);

  final String id;

  @override
  Future<String> deviceId() async => id;
}

/// 32 random hex characters (matches the server's `^[A-Za-z0-9._-]{8,64}$`).
String newDeviceId() {
  final random = Random.secure();
  return List.generate(16, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}
