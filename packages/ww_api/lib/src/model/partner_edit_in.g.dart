// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_edit_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerEditInCWProxy {
  PartnerEditIn role(PartnerEditInRoleEnum role);

  PartnerEditIn fullName(String fullName);

  PartnerEditIn dob(DateTime dob);

  PartnerEditIn gender(PartnerEditInGenderEnum gender);

  PartnerEditIn address(String address);

  PartnerEditIn lat(String lat);

  PartnerEditIn lng(String lng);

  PartnerEditIn languages(List<String> languages);

  PartnerEditIn skills(List<String>? skills);

  PartnerEditIn emergencyName(String emergencyName);

  PartnerEditIn emergencyPhone(String emergencyPhone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerEditIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerEditIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerEditIn call({
    PartnerEditInRoleEnum role,
    String fullName,
    DateTime dob,
    PartnerEditInGenderEnum gender,
    String address,
    String lat,
    String lng,
    List<String> languages,
    List<String>? skills,
    String emergencyName,
    String emergencyPhone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerEditIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerEditIn.copyWith.fieldName(...)`
class _$PartnerEditInCWProxyImpl implements _$PartnerEditInCWProxy {
  const _$PartnerEditInCWProxyImpl(this._value);

  final PartnerEditIn _value;

  @override
  PartnerEditIn role(PartnerEditInRoleEnum role) => this(role: role);

  @override
  PartnerEditIn fullName(String fullName) => this(fullName: fullName);

  @override
  PartnerEditIn dob(DateTime dob) => this(dob: dob);

  @override
  PartnerEditIn gender(PartnerEditInGenderEnum gender) => this(gender: gender);

  @override
  PartnerEditIn address(String address) => this(address: address);

  @override
  PartnerEditIn lat(String lat) => this(lat: lat);

  @override
  PartnerEditIn lng(String lng) => this(lng: lng);

  @override
  PartnerEditIn languages(List<String> languages) => this(languages: languages);

  @override
  PartnerEditIn skills(List<String>? skills) => this(skills: skills);

  @override
  PartnerEditIn emergencyName(String emergencyName) =>
      this(emergencyName: emergencyName);

  @override
  PartnerEditIn emergencyPhone(String emergencyPhone) =>
      this(emergencyPhone: emergencyPhone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerEditIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerEditIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerEditIn call({
    Object? role = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? skills = const $CopyWithPlaceholder(),
    Object? emergencyName = const $CopyWithPlaceholder(),
    Object? emergencyPhone = const $CopyWithPlaceholder(),
  }) {
    return PartnerEditIn(
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as PartnerEditInRoleEnum,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      dob: dob == const $CopyWithPlaceholder()
          ? _value.dob
          // ignore: cast_nullable_to_non_nullable
          : dob as DateTime,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as PartnerEditInGenderEnum,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String,
      languages: languages == const $CopyWithPlaceholder()
          ? _value.languages
          // ignore: cast_nullable_to_non_nullable
          : languages as List<String>,
      skills: skills == const $CopyWithPlaceholder()
          ? _value.skills
          // ignore: cast_nullable_to_non_nullable
          : skills as List<String>?,
      emergencyName: emergencyName == const $CopyWithPlaceholder()
          ? _value.emergencyName
          // ignore: cast_nullable_to_non_nullable
          : emergencyName as String,
      emergencyPhone: emergencyPhone == const $CopyWithPlaceholder()
          ? _value.emergencyPhone
          // ignore: cast_nullable_to_non_nullable
          : emergencyPhone as String,
    );
  }
}

extension $PartnerEditInCopyWith on PartnerEditIn {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerEditIn.copyWith(...)` or like so:`instanceOfPartnerEditIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerEditInCWProxy get copyWith => _$PartnerEditInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerEditIn _$PartnerEditInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerEditIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'role',
          'fullName',
          'dob',
          'gender',
          'address',
          'lat',
          'lng',
          'languages',
          'emergencyName',
          'emergencyPhone',
        ],
      );
      final val = PartnerEditIn(
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$PartnerEditInRoleEnumEnumMap, v),
        ),
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert('dob', (v) => DateTime.parse(v as String)),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$PartnerEditInGenderEnumEnumMap, v),
        ),
        address: $checkedConvert('address', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        languages: $checkedConvert(
          'languages',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        skills: $checkedConvert(
          'skills',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        emergencyName: $checkedConvert('emergencyName', (v) => v as String),
        emergencyPhone: $checkedConvert('emergencyPhone', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PartnerEditInToJson(PartnerEditIn instance) =>
    <String, dynamic>{
      'role': _$PartnerEditInRoleEnumEnumMap[instance.role]!,
      'fullName': instance.fullName,
      'dob': instance.dob.toIso8601String(),
      'gender': _$PartnerEditInGenderEnumEnumMap[instance.gender]!,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'languages': instance.languages,
      'skills': ?instance.skills,
      'emergencyName': instance.emergencyName,
      'emergencyPhone': instance.emergencyPhone,
    };

const _$PartnerEditInRoleEnumEnumMap = {
  PartnerEditInRoleEnum.COMPANION: 'COMPANION',
  PartnerEditInRoleEnum.NURSE: 'NURSE',
};

const _$PartnerEditInGenderEnumEnumMap = {
  PartnerEditInGenderEnum.FEMALE: 'FEMALE',
  PartnerEditInGenderEnum.MALE: 'MALE',
  PartnerEditInGenderEnum.OTHER: 'OTHER',
};
