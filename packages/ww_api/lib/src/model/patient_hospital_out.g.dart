// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_hospital_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientHospitalOutCWProxy {
  PatientHospitalOut id(String id);

  PatientHospitalOut name(String name);

  PatientHospitalOut type(String type);

  PatientHospitalOut address(String address);

  PatientHospitalOut city(String city);

  PatientHospitalOut lat(String lat);

  PatientHospitalOut lng(String lng);

  PatientHospitalOut phone(String phone);

  PatientHospitalOut opdHours(String opdHours);

  PatientHospitalOut photoUrl(String? photoUrl);

  PatientHospitalOut distanceKm(num? distanceKm);

  PatientHospitalOut doctorCount(int doctorCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientHospitalOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientHospitalOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientHospitalOut call({
    String id,
    String name,
    String type,
    String address,
    String city,
    String lat,
    String lng,
    String phone,
    String opdHours,
    String? photoUrl,
    num? distanceKm,
    int doctorCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientHospitalOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientHospitalOut.copyWith.fieldName(...)`
class _$PatientHospitalOutCWProxyImpl implements _$PatientHospitalOutCWProxy {
  const _$PatientHospitalOutCWProxyImpl(this._value);

  final PatientHospitalOut _value;

  @override
  PatientHospitalOut id(String id) => this(id: id);

  @override
  PatientHospitalOut name(String name) => this(name: name);

  @override
  PatientHospitalOut type(String type) => this(type: type);

  @override
  PatientHospitalOut address(String address) => this(address: address);

  @override
  PatientHospitalOut city(String city) => this(city: city);

  @override
  PatientHospitalOut lat(String lat) => this(lat: lat);

  @override
  PatientHospitalOut lng(String lng) => this(lng: lng);

  @override
  PatientHospitalOut phone(String phone) => this(phone: phone);

  @override
  PatientHospitalOut opdHours(String opdHours) => this(opdHours: opdHours);

  @override
  PatientHospitalOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  PatientHospitalOut distanceKm(num? distanceKm) =>
      this(distanceKm: distanceKm);

  @override
  PatientHospitalOut doctorCount(int doctorCount) =>
      this(doctorCount: doctorCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientHospitalOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientHospitalOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientHospitalOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? city = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? opdHours = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? distanceKm = const $CopyWithPlaceholder(),
    Object? doctorCount = const $CopyWithPlaceholder(),
  }) {
    return PatientHospitalOut(
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
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      distanceKm: distanceKm == const $CopyWithPlaceholder()
          ? _value.distanceKm
          // ignore: cast_nullable_to_non_nullable
          : distanceKm as num?,
      doctorCount: doctorCount == const $CopyWithPlaceholder()
          ? _value.doctorCount
          // ignore: cast_nullable_to_non_nullable
          : doctorCount as int,
    );
  }
}

extension $PatientHospitalOutCopyWith on PatientHospitalOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientHospitalOut.copyWith(...)` or like so:`instanceOfPatientHospitalOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientHospitalOutCWProxy get copyWith =>
      _$PatientHospitalOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientHospitalOut _$PatientHospitalOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientHospitalOut', json, ($checkedConvert) {
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
          'doctorCount',
        ],
      );
      final val = PatientHospitalOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        type: $checkedConvert('type', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        city: $checkedConvert('city', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        opdHours: $checkedConvert('opdHours', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        distanceKm: $checkedConvert('distanceKm', (v) => v as num?),
        doctorCount: $checkedConvert('doctorCount', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PatientHospitalOutToJson(PatientHospitalOut instance) =>
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
      'photoUrl': ?instance.photoUrl,
      'distanceKm': ?instance.distanceKm,
      'doctorCount': instance.doctorCount,
    };
