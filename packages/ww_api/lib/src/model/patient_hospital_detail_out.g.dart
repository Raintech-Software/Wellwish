// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_hospital_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientHospitalDetailOutCWProxy {
  PatientHospitalDetailOut id(String id);

  PatientHospitalDetailOut name(String name);

  PatientHospitalDetailOut type(String type);

  PatientHospitalDetailOut address(String address);

  PatientHospitalDetailOut city(String city);

  PatientHospitalDetailOut lat(String lat);

  PatientHospitalDetailOut lng(String lng);

  PatientHospitalDetailOut phone(String phone);

  PatientHospitalDetailOut opdHours(String opdHours);

  PatientHospitalDetailOut photoUrl(String? photoUrl);

  PatientHospitalDetailOut distanceKm(num? distanceKm);

  PatientHospitalDetailOut doctorCount(int doctorCount);

  PatientHospitalDetailOut departments(List<String> departments);

  PatientHospitalDetailOut doctors(List<PatientDoctorOut> doctors);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientHospitalDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientHospitalDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientHospitalDetailOut call({
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
    List<String> departments,
    List<PatientDoctorOut> doctors,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientHospitalDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientHospitalDetailOut.copyWith.fieldName(...)`
class _$PatientHospitalDetailOutCWProxyImpl
    implements _$PatientHospitalDetailOutCWProxy {
  const _$PatientHospitalDetailOutCWProxyImpl(this._value);

  final PatientHospitalDetailOut _value;

  @override
  PatientHospitalDetailOut id(String id) => this(id: id);

  @override
  PatientHospitalDetailOut name(String name) => this(name: name);

  @override
  PatientHospitalDetailOut type(String type) => this(type: type);

  @override
  PatientHospitalDetailOut address(String address) => this(address: address);

  @override
  PatientHospitalDetailOut city(String city) => this(city: city);

  @override
  PatientHospitalDetailOut lat(String lat) => this(lat: lat);

  @override
  PatientHospitalDetailOut lng(String lng) => this(lng: lng);

  @override
  PatientHospitalDetailOut phone(String phone) => this(phone: phone);

  @override
  PatientHospitalDetailOut opdHours(String opdHours) =>
      this(opdHours: opdHours);

  @override
  PatientHospitalDetailOut photoUrl(String? photoUrl) =>
      this(photoUrl: photoUrl);

  @override
  PatientHospitalDetailOut distanceKm(num? distanceKm) =>
      this(distanceKm: distanceKm);

  @override
  PatientHospitalDetailOut doctorCount(int doctorCount) =>
      this(doctorCount: doctorCount);

  @override
  PatientHospitalDetailOut departments(List<String> departments) =>
      this(departments: departments);

  @override
  PatientHospitalDetailOut doctors(List<PatientDoctorOut> doctors) =>
      this(doctors: doctors);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientHospitalDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientHospitalDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientHospitalDetailOut call({
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
    Object? departments = const $CopyWithPlaceholder(),
    Object? doctors = const $CopyWithPlaceholder(),
  }) {
    return PatientHospitalDetailOut(
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
      departments: departments == const $CopyWithPlaceholder()
          ? _value.departments
          // ignore: cast_nullable_to_non_nullable
          : departments as List<String>,
      doctors: doctors == const $CopyWithPlaceholder()
          ? _value.doctors
          // ignore: cast_nullable_to_non_nullable
          : doctors as List<PatientDoctorOut>,
    );
  }
}

extension $PatientHospitalDetailOutCopyWith on PatientHospitalDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientHospitalDetailOut.copyWith(...)` or like so:`instanceOfPatientHospitalDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientHospitalDetailOutCWProxy get copyWith =>
      _$PatientHospitalDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientHospitalDetailOut _$PatientHospitalDetailOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PatientHospitalDetailOut', json, ($checkedConvert) {
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
      'departments',
      'doctors',
    ],
  );
  final val = PatientHospitalDetailOut(
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
    departments: $checkedConvert(
      'departments',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    doctors: $checkedConvert(
      'doctors',
      (v) => (v as List<dynamic>)
          .map((e) => PatientDoctorOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatientHospitalDetailOutToJson(
  PatientHospitalDetailOut instance,
) => <String, dynamic>{
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
  'departments': instance.departments,
  'doctors': instance.doctors.map((e) => e.toJson()).toList(),
};
