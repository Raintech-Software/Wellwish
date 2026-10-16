// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HospitalOutCWProxy {
  HospitalOut id(String id);

  HospitalOut name(String name);

  HospitalOut type(String type);

  HospitalOut address(String address);

  HospitalOut city(String city);

  HospitalOut lat(String lat);

  HospitalOut lng(String lng);

  HospitalOut phone(String phone);

  HospitalOut opdHours(String opdHours);

  HospitalOut departments(List<String> departments);

  HospitalOut photoKey(String photoKey);

  HospitalOut photoUrl(String? photoUrl);

  HospitalOut isActive(bool isActive);

  HospitalOut doctorCount(int? doctorCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalOut call({
    String id,
    String name,
    String type,
    String address,
    String city,
    String lat,
    String lng,
    String phone,
    String opdHours,
    List<String> departments,
    String photoKey,
    String? photoUrl,
    bool isActive,
    int? doctorCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHospitalOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHospitalOut.copyWith.fieldName(...)`
class _$HospitalOutCWProxyImpl implements _$HospitalOutCWProxy {
  const _$HospitalOutCWProxyImpl(this._value);

  final HospitalOut _value;

  @override
  HospitalOut id(String id) => this(id: id);

  @override
  HospitalOut name(String name) => this(name: name);

  @override
  HospitalOut type(String type) => this(type: type);

  @override
  HospitalOut address(String address) => this(address: address);

  @override
  HospitalOut city(String city) => this(city: city);

  @override
  HospitalOut lat(String lat) => this(lat: lat);

  @override
  HospitalOut lng(String lng) => this(lng: lng);

  @override
  HospitalOut phone(String phone) => this(phone: phone);

  @override
  HospitalOut opdHours(String opdHours) => this(opdHours: opdHours);

  @override
  HospitalOut departments(List<String> departments) =>
      this(departments: departments);

  @override
  HospitalOut photoKey(String photoKey) => this(photoKey: photoKey);

  @override
  HospitalOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  HospitalOut isActive(bool isActive) => this(isActive: isActive);

  @override
  HospitalOut doctorCount(int? doctorCount) => this(doctorCount: doctorCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalOut call({
    Object? id = const $CopyWithPlaceholder(),
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
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
    Object? doctorCount = const $CopyWithPlaceholder(),
  }) {
    return HospitalOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      city: city == const $CopyWithPlaceholder()
          ? _value.city
          // ignore: cast_nullable_to_non_nullable
          : city as String,
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
          : phone as String,
      opdHours: opdHours == const $CopyWithPlaceholder()
          ? _value.opdHours
          // ignore: cast_nullable_to_non_nullable
          : opdHours as String,
      departments: departments == const $CopyWithPlaceholder()
          ? _value.departments
          // ignore: cast_nullable_to_non_nullable
          : departments as List<String>,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
      doctorCount: doctorCount == const $CopyWithPlaceholder()
          ? _value.doctorCount
          // ignore: cast_nullable_to_non_nullable
          : doctorCount as int?,
    );
  }
}

extension $HospitalOutCopyWith on HospitalOut {
  /// Returns a callable class that can be used as follows: `instanceOfHospitalOut.copyWith(...)` or like so:`instanceOfHospitalOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HospitalOutCWProxy get copyWith => _$HospitalOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalOut _$HospitalOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HospitalOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'type',
          'address',
          'city',
          'lat',
          'lng',
          'phone',
          'opdHours',
          'departments',
          'photoKey',
          'isActive',
        ],
      );
      final val = HospitalOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        opdHours: $checkedConvert('opdHours', (v) => v as String),
        departments: $checkedConvert(
          'departments',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        photoKey: $checkedConvert('photoKey', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        isActive: $checkedConvert('isActive', (v) => v as bool),
        doctorCount: $checkedConvert(
          'doctorCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$HospitalOutToJson(HospitalOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'address': instance.address,
      'city': instance.city,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': instance.phone,
      'opdHours': instance.opdHours,
      'departments': instance.departments,
      'photoKey': instance.photoKey,
      'photoUrl': ?instance.photoUrl,
      'isActive': instance.isActive,
      'doctorCount': ?instance.doctorCount,
    };
