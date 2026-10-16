// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DoctorInCWProxy {
  DoctorIn fullName(String fullName);

  DoctorIn specialityId(String specialityId);

  DoctorIn hospitalIds(List<String>? hospitalIds);

  DoctorIn qualifications(String? qualifications);

  DoctorIn opdInfo(String? opdInfo);

  DoctorIn languages(List<String>? languages);

  DoctorIn photoKey(String? photoKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DoctorIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DoctorIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DoctorIn call({
    String fullName,
    String specialityId,
    List<String>? hospitalIds,
    String? qualifications,
    String? opdInfo,
    List<String>? languages,
    String? photoKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDoctorIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDoctorIn.copyWith.fieldName(...)`
class _$DoctorInCWProxyImpl implements _$DoctorInCWProxy {
  const _$DoctorInCWProxyImpl(this._value);

  final DoctorIn _value;

  @override
  DoctorIn fullName(String fullName) => this(fullName: fullName);

  @override
  DoctorIn specialityId(String specialityId) =>
      this(specialityId: specialityId);

  @override
  DoctorIn hospitalIds(List<String>? hospitalIds) =>
      this(hospitalIds: hospitalIds);

  @override
  DoctorIn qualifications(String? qualifications) =>
      this(qualifications: qualifications);

  @override
  DoctorIn opdInfo(String? opdInfo) => this(opdInfo: opdInfo);

  @override
  DoctorIn languages(List<String>? languages) => this(languages: languages);

  @override
  DoctorIn photoKey(String? photoKey) => this(photoKey: photoKey);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DoctorIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DoctorIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DoctorIn call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? specialityId = const $CopyWithPlaceholder(),
    Object? hospitalIds = const $CopyWithPlaceholder(),
    Object? qualifications = const $CopyWithPlaceholder(),
    Object? opdInfo = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? photoKey = const $CopyWithPlaceholder(),
  }) {
    return DoctorIn(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      specialityId: specialityId == const $CopyWithPlaceholder()
          ? _value.specialityId
          // ignore: cast_nullable_to_non_nullable
          : specialityId as String,
      hospitalIds: hospitalIds == const $CopyWithPlaceholder()
          ? _value.hospitalIds
          // ignore: cast_nullable_to_non_nullable
          : hospitalIds as List<String>?,
      qualifications: qualifications == const $CopyWithPlaceholder()
          ? _value.qualifications
          // ignore: cast_nullable_to_non_nullable
          : qualifications as String?,
      opdInfo: opdInfo == const $CopyWithPlaceholder()
          ? _value.opdInfo
          // ignore: cast_nullable_to_non_nullable
          : opdInfo as String?,
      languages: languages == const $CopyWithPlaceholder()
          ? _value.languages
          // ignore: cast_nullable_to_non_nullable
          : languages as List<String>?,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String?,
    );
  }
}

extension $DoctorInCopyWith on DoctorIn {
  /// Returns a callable class that can be used as follows: `instanceOfDoctorIn.copyWith(...)` or like so:`instanceOfDoctorIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DoctorInCWProxy get copyWith => _$DoctorInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorIn _$DoctorInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DoctorIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['fullName', 'specialityId']);
      final val = DoctorIn(
        fullName: $checkedConvert('fullName', (v) => v as String),
        specialityId: $checkedConvert('specialityId', (v) => v as String),
        hospitalIds: $checkedConvert(
          'hospitalIds',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        qualifications: $checkedConvert(
          'qualifications',
          (v) => v as String? ?? '',
        ),
        opdInfo: $checkedConvert('opdInfo', (v) => v as String? ?? ''),
        languages: $checkedConvert(
          'languages',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        photoKey: $checkedConvert('photoKey', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$DoctorInToJson(DoctorIn instance) => <String, dynamic>{
  'fullName': instance.fullName,
  'specialityId': instance.specialityId,
  'hospitalIds': ?instance.hospitalIds,
  'qualifications': ?instance.qualifications,
  'opdInfo': ?instance.opdInfo,
  'languages': ?instance.languages,
  'photoKey': ?instance.photoKey,
};
