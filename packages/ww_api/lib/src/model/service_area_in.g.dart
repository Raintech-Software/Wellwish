// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceAreaInCWProxy {
  ServiceAreaIn city(String city);

  ServiceAreaIn name(String name);

  ServiceAreaIn lat(String lat);

  ServiceAreaIn lng(String lng);

  ServiceAreaIn radiusKm(String radiusKm);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaIn call({
    String city,
    String name,
    String lat,
    String lng,
    String radiusKm,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceAreaIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceAreaIn.copyWith.fieldName(...)`
class _$ServiceAreaInCWProxyImpl implements _$ServiceAreaInCWProxy {
  const _$ServiceAreaInCWProxyImpl(this._value);

  final ServiceAreaIn _value;

  @override
  ServiceAreaIn city(String city) => this(city: city);

  @override
  ServiceAreaIn name(String name) => this(name: name);

  @override
  ServiceAreaIn lat(String lat) => this(lat: lat);

  @override
  ServiceAreaIn lng(String lng) => this(lng: lng);

  @override
  ServiceAreaIn radiusKm(String radiusKm) => this(radiusKm: radiusKm);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaIn call({
    Object? city = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? radiusKm = const $CopyWithPlaceholder(),
  }) {
    return ServiceAreaIn(
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String,
      radiusKm: radiusKm == const $CopyWithPlaceholder()
          ? _value.radiusKm
          // ignore: cast_nullable_to_non_nullable
          : radiusKm as String,
    );
  }
}

extension $ServiceAreaInCopyWith on ServiceAreaIn {
  /// Returns a callable class that can be used as follows: `instanceOfServiceAreaIn.copyWith(...)` or like so:`instanceOfServiceAreaIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceAreaInCWProxy get copyWith => _$ServiceAreaInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAreaIn _$ServiceAreaInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ServiceAreaIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['city', 'name', 'lat', 'lng', 'radiusKm'],
      );
      final val = ServiceAreaIn(
        city: $checkedConvert('city', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        radiusKm: $checkedConvert('radiusKm', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ServiceAreaInToJson(ServiceAreaIn instance) =>
    <String, dynamic>{
      'city': instance.city,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'radiusKm': instance.radiusKm,
    };
