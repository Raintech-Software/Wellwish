// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoogleInCWProxy {
  GoogleIn idToken(String idToken);

  GoogleIn deviceId(String deviceId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoogleIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoogleIn(...).copyWith(id: 12, name: "My name")
  /// ````
  GoogleIn call({String idToken, String deviceId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoogleIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoogleIn.copyWith.fieldName(...)`
class _$GoogleInCWProxyImpl implements _$GoogleInCWProxy {
  const _$GoogleInCWProxyImpl(this._value);

  final GoogleIn _value;

  @override
  GoogleIn idToken(String idToken) => this(idToken: idToken);

  @override
  GoogleIn deviceId(String deviceId) => this(deviceId: deviceId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoogleIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoogleIn(...).copyWith(id: 12, name: "My name")
  /// ````
  GoogleIn call({
    Object? idToken = const $CopyWithPlaceholder(),
    Object? deviceId = const $CopyWithPlaceholder(),
  }) {
    return GoogleIn(
      idToken: idToken == const $CopyWithPlaceholder()
          ? _value.idToken
          // ignore: cast_nullable_to_non_nullable
          : idToken as String,
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
    );
  }
}

extension $GoogleInCopyWith on GoogleIn {
  /// Returns a callable class that can be used as follows: `instanceOfGoogleIn.copyWith(...)` or like so:`instanceOfGoogleIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoogleInCWProxy get copyWith => _$GoogleInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleIn _$GoogleInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GoogleIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['idToken', 'deviceId']);
      final val = GoogleIn(
        idToken: $checkedConvert('idToken', (v) => v as String),
        deviceId: $checkedConvert('deviceId', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$GoogleInToJson(GoogleIn instance) => <String, dynamic>{
  'idToken': instance.idToken,
  'deviceId': instance.deviceId,
};
