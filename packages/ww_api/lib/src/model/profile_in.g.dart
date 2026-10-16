// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProfileInCWProxy {
  ProfileIn fullName(String fullName);

  ProfileIn dob(DateTime dob);

  ProfileIn gender(ProfileInGenderEnum gender);

  ProfileIn photoKey(String photoKey);

  ProfileIn address(String address);

  ProfileIn lat(String lat);

  ProfileIn lng(String lng);

  ProfileIn languages(List<String> languages);

  ProfileIn skills(List<String>? skills);

  ProfileIn emergencyName(String emergencyName);

  ProfileIn emergencyPhone(String emergencyPhone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProfileIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProfileIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ProfileIn call({
    String fullName,
    DateTime dob,
    ProfileInGenderEnum gender,
    String photoKey,
    String address,
    String lat,
    String lng,
    List<String> languages,
    List<String>? skills,
    String emergencyName,
    String emergencyPhone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProfileIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProfileIn.copyWith.fieldName(...)`
class _$ProfileInCWProxyImpl implements _$ProfileInCWProxy {
  const _$ProfileInCWProxyImpl(this._value);

  final ProfileIn _value;

  @override
  ProfileIn fullName(String fullName) => this(fullName: fullName);

  @override
  ProfileIn dob(DateTime dob) => this(dob: dob);

  @override
  ProfileIn gender(ProfileInGenderEnum gender) => this(gender: gender);

  @override
  ProfileIn photoKey(String photoKey) => this(photoKey: photoKey);

  @override
  ProfileIn address(String address) => this(address: address);

  @override
  ProfileIn lat(String lat) => this(lat: lat);

  @override
  ProfileIn lng(String lng) => this(lng: lng);

  @override
  ProfileIn languages(List<String> languages) => this(languages: languages);

  @override
  ProfileIn skills(List<String>? skills) => this(skills: skills);

  @override
  ProfileIn emergencyName(String emergencyName) =>
      this(emergencyName: emergencyName);

  @override
  ProfileIn emergencyPhone(String emergencyPhone) =>
      this(emergencyPhone: emergencyPhone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProfileIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProfileIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ProfileIn call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? photoKey = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? skills = const $CopyWithPlaceholder(),
    Object? emergencyName = const $CopyWithPlaceholder(),
    Object? emergencyPhone = const $CopyWithPlaceholder(),
  }) {
    return ProfileIn(
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
          : gender as ProfileInGenderEnum,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String,
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

extension $ProfileInCopyWith on ProfileIn {
  /// Returns a callable class that can be used as follows: `instanceOfProfileIn.copyWith(...)` or like so:`instanceOfProfileIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProfileInCWProxy get copyWith => _$ProfileInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileIn _$ProfileInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ProfileIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'fullName',
          'dob',
          'gender',
          'photoKey',
          'address',
          'lat',
          'lng',
          'languages',
          'emergencyName',
          'emergencyPhone',
        ],
      );
      final val = ProfileIn(
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert('dob', (v) => DateTime.parse(v as String)),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$ProfileInGenderEnumEnumMap, v),
        ),
        photoKey: $checkedConvert('photoKey', (v) => v as String),
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

Map<String, dynamic> _$ProfileInToJson(ProfileIn instance) => <String, dynamic>{
  'fullName': instance.fullName,
  'dob': instance.dob.toIso8601String(),
  'gender': _$ProfileInGenderEnumEnumMap[instance.gender]!,
  'photoKey': instance.photoKey,
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
  'languages': instance.languages,
  'skills': ?instance.skills,
  'emergencyName': instance.emergencyName,
  'emergencyPhone': instance.emergencyPhone,
};

const _$ProfileInGenderEnumEnumMap = {
  ProfileInGenderEnum.FEMALE: 'FEMALE',
  ProfileInGenderEnum.MALE: 'MALE',
  ProfileInGenderEnum.OTHER: 'OTHER',
};
