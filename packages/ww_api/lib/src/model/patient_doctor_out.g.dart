// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_doctor_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientDoctorOutCWProxy {
  PatientDoctorOut id(String id);

  PatientDoctorOut fullName(String fullName);

  PatientDoctorOut photoUrl(String? photoUrl);

  PatientDoctorOut speciality(SpecialityOut speciality);

  PatientDoctorOut qualifications(String qualifications);

  PatientDoctorOut opdInfo(String opdInfo);

  PatientDoctorOut languages(List<String> languages);

  PatientDoctorOut hospitals(List<HospitalBrief> hospitals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDoctorOut call({
    String id,
    String fullName,
    String? photoUrl,
    SpecialityOut speciality,
    String qualifications,
    String opdInfo,
    List<String> languages,
    List<HospitalBrief> hospitals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientDoctorOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientDoctorOut.copyWith.fieldName(...)`
class _$PatientDoctorOutCWProxyImpl implements _$PatientDoctorOutCWProxy {
  const _$PatientDoctorOutCWProxyImpl(this._value);

  final PatientDoctorOut _value;

  @override
  PatientDoctorOut id(String id) => this(id: id);

  @override
  PatientDoctorOut fullName(String fullName) => this(fullName: fullName);

  @override
  PatientDoctorOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  PatientDoctorOut speciality(SpecialityOut speciality) =>
      this(speciality: speciality);

  @override
  PatientDoctorOut qualifications(String qualifications) =>
      this(qualifications: qualifications);

  @override
  PatientDoctorOut opdInfo(String opdInfo) => this(opdInfo: opdInfo);

  @override
  PatientDoctorOut languages(List<String> languages) =>
      this(languages: languages);

  @override
  PatientDoctorOut hospitals(List<HospitalBrief> hospitals) =>
      this(hospitals: hospitals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDoctorOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? speciality = const $CopyWithPlaceholder(),
    Object? qualifications = const $CopyWithPlaceholder(),
    Object? opdInfo = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? hospitals = const $CopyWithPlaceholder(),
  }) {
    return PatientDoctorOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      speciality: speciality == const $CopyWithPlaceholder()
          ? _value.speciality
          // ignore: cast_nullable_to_non_nullable
          : speciality as SpecialityOut,
      qualifications: qualifications == const $CopyWithPlaceholder()
          ? _value.qualifications
          // ignore: cast_nullable_to_non_nullable
          : qualifications as String,
      opdInfo: opdInfo == const $CopyWithPlaceholder()
          ? _value.opdInfo
          // ignore: cast_nullable_to_non_nullable
          : opdInfo as String,
      languages: languages == const $CopyWithPlaceholder()
          ? _value.languages
          // ignore: cast_nullable_to_non_nullable
          : languages as List<String>,
      hospitals: hospitals == const $CopyWithPlaceholder()
          ? _value.hospitals
          // ignore: cast_nullable_to_non_nullable
          : hospitals as List<HospitalBrief>,
    );
  }
}

extension $PatientDoctorOutCopyWith on PatientDoctorOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientDoctorOut.copyWith(...)` or like so:`instanceOfPatientDoctorOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientDoctorOutCWProxy get copyWith => _$PatientDoctorOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDoctorOut _$PatientDoctorOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientDoctorOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'fullName',
          'speciality',
          'qualifications',
          'opdInfo',
          'languages',
          'hospitals',
        ],
      );
      final val = PatientDoctorOut(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        speciality: $checkedConvert(
          'speciality',
          (v) => SpecialityOut.fromJson(v as Map<String, dynamic>),
        ),
        qualifications: $checkedConvert('qualifications', (v) => v as String),
        opdInfo: $checkedConvert('opdInfo', (v) => v as String),
        languages: $checkedConvert(
          'languages',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        hospitals: $checkedConvert(
          'hospitals',
          (v) => (v as List<dynamic>)
              .map((e) => HospitalBrief.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatientDoctorOutToJson(PatientDoctorOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'photoUrl': ?instance.photoUrl,
      'speciality': instance.speciality.toJson(),
      'qualifications': instance.qualifications,
      'opdInfo': instance.opdInfo,
      'languages': instance.languages,
      'hospitals': instance.hospitals.map((e) => e.toJson()).toList(),
    };
