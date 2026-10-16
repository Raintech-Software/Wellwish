// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DoctorOutCWProxy {
  DoctorOut id(String id);

  DoctorOut fullName(String fullName);

  DoctorOut photoKey(String photoKey);

  DoctorOut photoUrl(String? photoUrl);

  DoctorOut speciality(SpecialityOut speciality);

  DoctorOut qualifications(String qualifications);

  DoctorOut opdInfo(String opdInfo);

  DoctorOut languages(List<String> languages);

  DoctorOut hospitals(List<HospitalBrief> hospitals);

  DoctorOut isActive(bool isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DoctorOut call({
    String id,
    String fullName,
    String photoKey,
    String? photoUrl,
    SpecialityOut speciality,
    String qualifications,
    String opdInfo,
    List<String> languages,
    List<HospitalBrief> hospitals,
    bool isActive,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDoctorOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDoctorOut.copyWith.fieldName(...)`
class _$DoctorOutCWProxyImpl implements _$DoctorOutCWProxy {
  const _$DoctorOutCWProxyImpl(this._value);

  final DoctorOut _value;

  @override
  DoctorOut id(String id) => this(id: id);

  @override
  DoctorOut fullName(String fullName) => this(fullName: fullName);

  @override
  DoctorOut photoKey(String photoKey) => this(photoKey: photoKey);

  @override
  DoctorOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  DoctorOut speciality(SpecialityOut speciality) =>
      this(speciality: speciality);

  @override
  DoctorOut qualifications(String qualifications) =>
      this(qualifications: qualifications);

  @override
  DoctorOut opdInfo(String opdInfo) => this(opdInfo: opdInfo);

  @override
  DoctorOut languages(List<String> languages) => this(languages: languages);

  @override
  DoctorOut hospitals(List<HospitalBrief> hospitals) =>
      this(hospitals: hospitals);

  @override
  DoctorOut isActive(bool isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DoctorOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? photoKey = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? speciality = const $CopyWithPlaceholder(),
    Object? qualifications = const $CopyWithPlaceholder(),
    Object? opdInfo = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? hospitals = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return DoctorOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String,
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
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
    );
  }
}

extension $DoctorOutCopyWith on DoctorOut {
  /// Returns a callable class that can be used as follows: `instanceOfDoctorOut.copyWith(...)` or like so:`instanceOfDoctorOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DoctorOutCWProxy get copyWith => _$DoctorOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorOut _$DoctorOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DoctorOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'fullName',
          'photoKey',
          'speciality',
          'qualifications',
          'opdInfo',
          'languages',
          'hospitals',
          'isActive',
        ],
      );
      final val = DoctorOut(
        id: $checkedConvert('id', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        photoKey: $checkedConvert('photoKey', (v) => v as String),
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
        isActive: $checkedConvert('isActive', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$DoctorOutToJson(DoctorOut instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'photoKey': instance.photoKey,
  'photoUrl': ?instance.photoUrl,
  'speciality': instance.speciality.toJson(),
  'qualifications': instance.qualifications,
  'opdInfo': instance.opdInfo,
  'languages': instance.languages,
  'hospitals': instance.hospitals.map((e) => e.toJson()).toList(),
  'isActive': instance.isActive,
};
