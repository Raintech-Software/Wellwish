// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceAreaOutCWProxy {
  ServiceAreaOut id(String id);

  ServiceAreaOut city(String city);

  ServiceAreaOut name(String name);

  ServiceAreaOut lat(String lat);

  ServiceAreaOut lng(String lng);

  ServiceAreaOut radiusKm(String radiusKm);

  ServiceAreaOut isActive(bool isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaOut call({
    String id,
    String city,
    String name,
    String lat,
    String lng,
    String radiusKm,
    bool isActive,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceAreaOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceAreaOut.copyWith.fieldName(...)`
class _$ServiceAreaOutCWProxyImpl implements _$ServiceAreaOutCWProxy {
  const _$ServiceAreaOutCWProxyImpl(this._value);

  final ServiceAreaOut _value;

  @override
  ServiceAreaOut id(String id) => this(id: id);

  @override
  ServiceAreaOut city(String city) => this(city: city);

  @override
  ServiceAreaOut name(String name) => this(name: name);

  @override
  ServiceAreaOut lat(String lat) => this(lat: lat);

  @override
  ServiceAreaOut lng(String lng) => this(lng: lng);

  @override
  ServiceAreaOut radiusKm(String radiusKm) => this(radiusKm: radiusKm);

  @override
  ServiceAreaOut isActive(bool isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAreaOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAreaOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAreaOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? radiusKm = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return ServiceAreaOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
    );
  }
}

extension $ServiceAreaOutCopyWith on ServiceAreaOut {
  /// Returns a callable class that can be used as follows: `instanceOfServiceAreaOut.copyWith(...)` or like so:`instanceOfServiceAreaOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceAreaOutCWProxy get copyWith => _$ServiceAreaOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAreaOut _$ServiceAreaOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ServiceAreaOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'city',
          'name',
          'lat',
          'lng',
          'radiusKm',
          'isActive',
        ],
      );
      final val = ServiceAreaOut(
        id: $checkedConvert('id', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        radiusKm: $checkedConvert('radiusKm', (v) => v as String),
        isActive: $checkedConvert('isActive', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$ServiceAreaOutToJson(ServiceAreaOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
      'radiusKm': instance.radiusKm,
      'isActive': instance.isActive,
    };
