// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SosInCWProxy {
  SosIn lat(String? lat);

  SosIn lng(String? lng);

  SosIn mock(bool? mock);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SosIn call({String? lat, String? lng, bool? mock});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSosIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSosIn.copyWith.fieldName(...)`
class _$SosInCWProxyImpl implements _$SosInCWProxy {
  const _$SosInCWProxyImpl(this._value);

  final SosIn _value;

  @override
  SosIn lat(String? lat) => this(lat: lat);

  @override
  SosIn lng(String? lng) => this(lng: lng);

  @override
  SosIn mock(bool? mock) => this(mock: mock);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SosIn call({
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? mock = const $CopyWithPlaceholder(),
  }) {
    return SosIn(
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String?,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String?,
      mock: mock == const $CopyWithPlaceholder()
          ? _value.mock
          // ignore: cast_nullable_to_non_nullable
          : mock as bool?,
    );
  }
}

extension $SosInCopyWith on SosIn {
  /// Returns a callable class that can be used as follows: `instanceOfSosIn.copyWith(...)` or like so:`instanceOfSosIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SosInCWProxy get copyWith => _$SosInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosIn _$SosInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SosIn', json, ($checkedConvert) {
      final val = SosIn(
        lat: $checkedConvert('lat', (v) => v as String?),
        lng: $checkedConvert('lng', (v) => v as String?),
        mock: $checkedConvert('mock', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$SosInToJson(SosIn instance) => <String, dynamic>{
  'lat': ?instance.lat,
  'lng': ?instance.lng,
  'mock': ?instance.mock,
};
