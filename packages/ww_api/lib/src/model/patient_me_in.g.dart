// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_me_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientMeInCWProxy {
  PatientMeIn fullName(String fullName);

  PatientMeIn dob(DateTime dob);

  PatientMeIn gender(PatientMeInGenderEnum gender);

  PatientMeIn language(PatientMeInLanguageEnum language);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientMeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientMeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientMeIn call({
    String fullName,
    DateTime dob,
    PatientMeInGenderEnum gender,
    PatientMeInLanguageEnum language,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientMeIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientMeIn.copyWith.fieldName(...)`
class _$PatientMeInCWProxyImpl implements _$PatientMeInCWProxy {
  const _$PatientMeInCWProxyImpl(this._value);

  final PatientMeIn _value;

  @override
  PatientMeIn fullName(String fullName) => this(fullName: fullName);

  @override
  PatientMeIn dob(DateTime dob) => this(dob: dob);

  @override
  PatientMeIn gender(PatientMeInGenderEnum gender) => this(gender: gender);

  @override
  PatientMeIn language(PatientMeInLanguageEnum language) =>
      this(language: language);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientMeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientMeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientMeIn call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
  }) {
    return PatientMeIn(
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
          : gender as PatientMeInGenderEnum,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as PatientMeInLanguageEnum,
    );
  }
}

extension $PatientMeInCopyWith on PatientMeIn {
  /// Returns a callable class that can be used as follows: `instanceOfPatientMeIn.copyWith(...)` or like so:`instanceOfPatientMeIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientMeInCWProxy get copyWith => _$PatientMeInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientMeIn _$PatientMeInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientMeIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['fullName', 'dob', 'gender', 'language'],
      );
      final val = PatientMeIn(
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert('dob', (v) => DateTime.parse(v as String)),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$PatientMeInGenderEnumEnumMap, v),
        ),
        language: $checkedConvert(
          'language',
          (v) => $enumDecode(_$PatientMeInLanguageEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatientMeInToJson(PatientMeIn instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'dob': instance.dob.toIso8601String(),
      'gender': _$PatientMeInGenderEnumEnumMap[instance.gender]!,
      'language': _$PatientMeInLanguageEnumEnumMap[instance.language]!,
    };

const _$PatientMeInGenderEnumEnumMap = {
  PatientMeInGenderEnum.FEMALE: 'FEMALE',
  PatientMeInGenderEnum.MALE: 'MALE',
  PatientMeInGenderEnum.OTHER: 'OTHER',
};

const _$PatientMeInLanguageEnumEnumMap = {
  PatientMeInLanguageEnum.en: 'en',
  PatientMeInLanguageEnum.hi: 'hi',
  PatientMeInLanguageEnum.or: 'or',
};
