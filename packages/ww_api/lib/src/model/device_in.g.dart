// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeviceInCWProxy {
  DeviceIn deviceId(String deviceId);

  DeviceIn platform(DeviceInPlatformEnum platform);

  DeviceIn appVersion(String appVersion);

  DeviceIn fcmToken(String? fcmToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeviceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeviceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DeviceIn call({
    String deviceId,
    DeviceInPlatformEnum platform,
    String appVersion,
    String? fcmToken,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeviceIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeviceIn.copyWith.fieldName(...)`
class _$DeviceInCWProxyImpl implements _$DeviceInCWProxy {
  const _$DeviceInCWProxyImpl(this._value);

  final DeviceIn _value;

  @override
  DeviceIn deviceId(String deviceId) => this(deviceId: deviceId);

  @override
  DeviceIn platform(DeviceInPlatformEnum platform) => this(platform: platform);

  @override
  DeviceIn appVersion(String appVersion) => this(appVersion: appVersion);

  @override
  DeviceIn fcmToken(String? fcmToken) => this(fcmToken: fcmToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeviceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeviceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DeviceIn call({
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? platform = const $CopyWithPlaceholder(),
    Object? appVersion = const $CopyWithPlaceholder(),
    Object? fcmToken = const $CopyWithPlaceholder(),
  }) {
    return DeviceIn(
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
      platform: platform == const $CopyWithPlaceholder()
          ? _value.platform
          // ignore: cast_nullable_to_non_nullable
          : platform as DeviceInPlatformEnum,
      appVersion: appVersion == const $CopyWithPlaceholder()
          ? _value.appVersion
          // ignore: cast_nullable_to_non_nullable
          : appVersion as String,
      fcmToken: fcmToken == const $CopyWithPlaceholder()
          ? _value.fcmToken
          // ignore: cast_nullable_to_non_nullable
          : fcmToken as String?,
    );
  }
}

extension $DeviceInCopyWith on DeviceIn {
  /// Returns a callable class that can be used as follows: `instanceOfDeviceIn.copyWith(...)` or like so:`instanceOfDeviceIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeviceInCWProxy get copyWith => _$DeviceInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceIn _$DeviceInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeviceIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['deviceId', 'platform', 'appVersion'],
      );
      final val = DeviceIn(
        deviceId: $checkedConvert('deviceId', (v) => v as String),
        platform: $checkedConvert(
          'platform',
          (v) => $enumDecode(_$DeviceInPlatformEnumEnumMap, v),
        ),
        appVersion: $checkedConvert('appVersion', (v) => v as String),
        fcmToken: $checkedConvert('fcmToken', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$DeviceInToJson(DeviceIn instance) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'platform': _$DeviceInPlatformEnumEnumMap[instance.platform]!,
  'appVersion': instance.appVersion,
  'fcmToken': ?instance.fcmToken,
};

const _$DeviceInPlatformEnumEnumMap = {
  DeviceInPlatformEnum.android: 'android',
  DeviceInPlatformEnum.ios: 'ios',
};
