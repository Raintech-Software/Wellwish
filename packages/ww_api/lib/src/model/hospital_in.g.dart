// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HospitalInCWProxy {
  HospitalIn name(String name);

  HospitalIn type(HospitalInTypeEnum type);

  HospitalIn address(String address);

  HospitalIn city(String? city);

  HospitalIn lat(String lat);

  HospitalIn lng(String lng);

  HospitalIn phone(String? phone);

  HospitalIn opdHours(String? opdHours);

  HospitalIn departments(List<String>? departments);

  HospitalIn photoKey(String? photoKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalIn(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalIn call({
    String name,
    HospitalInTypeEnum type,
    String address,
    String? city,
    String lat,
    String lng,
    String? phone,
    String? opdHours,
    List<String>? departments,
    String? photoKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHospitalIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHospitalIn.copyWith.fieldName(...)`
class _$HospitalInCWProxyImpl implements _$HospitalInCWProxy {
  const _$HospitalInCWProxyImpl(this._value);

  final HospitalIn _value;

  @override
  HospitalIn name(String name) => this(name: name);

  @override
  HospitalIn type(HospitalInTypeEnum type) => this(type: type);

  @override
  HospitalIn address(String address) => this(address: address);

  @override
  HospitalIn city(String? city) => this(city: city);

  @override
  HospitalIn lat(String lat) => this(lat: lat);

  @override
  HospitalIn lng(String lng) => this(lng: lng);

  @override
  HospitalIn phone(String? phone) => this(phone: phone);

  @override
  HospitalIn opdHours(String? opdHours) => this(opdHours: opdHours);

  @override
  HospitalIn departments(List<String>? departments) =>
      this(departments: departments);

  @override
  HospitalIn photoKey(String? photoKey) => this(photoKey: photoKey);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalIn(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalIn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? opdHours = const $CopyWithPlaceholder(),
    Object? departments = const $CopyWithPlaceholder(),
    Object? photoKey = const $CopyWithPlaceholder(),
  }) {
    return HospitalIn(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as HospitalInTypeEnum,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String?,
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      opdHours: opdHours == const $CopyWithPlaceholder()
          ? _value.opdHours
          // ignore: cast_nullable_to_non_nullable
          : opdHours as String?,
      departments: departments == const $CopyWithPlaceholder()
          ? _value.departments
          // ignore: cast_nullable_to_non_nullable
          : departments as List<String>?,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String?,
    );
  }
}

extension $HospitalInCopyWith on HospitalIn {
  /// Returns a callable class that can be used as follows: `instanceOfHospitalIn.copyWith(...)` or like so:`instanceOfHospitalIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HospitalInCWProxy get copyWith => _$HospitalInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalIn _$HospitalInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HospitalIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['name', 'type', 'address', 'lat', 'lng'],
      );
      final val = HospitalIn(
        name: $checkedConvert('name', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$HospitalInTypeEnumEnumMap, v),
        ),
        address: $checkedConvert('address', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String? ?? ''),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String? ?? ''),
        opdHours: $checkedConvert('opdHours', (v) => v as String? ?? ''),
        departments: $checkedConvert(
          'departments',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        photoKey: $checkedConvert('photoKey', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$HospitalInToJson(HospitalIn instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$HospitalInTypeEnumEnumMap[instance.type]!,
      'address': instance.address,
      'city': ?instance.city,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': ?instance.phone,
      'opdHours': ?instance.opdHours,
      'departments': ?instance.departments,
      'photoKey': ?instance.photoKey,
    };

const _$HospitalInTypeEnumEnumMap = {
  HospitalInTypeEnum.HOSPITAL: 'HOSPITAL',
  HospitalInTypeEnum.CLINIC: 'CLINIC',
  HospitalInTypeEnum.DIAGNOSTIC: 'DIAGNOSTIC',
};
