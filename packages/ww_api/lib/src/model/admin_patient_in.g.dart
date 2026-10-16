// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_patient_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminPatientInCWProxy {
  AdminPatientIn fullName(String fullName);

  AdminPatientIn dob(DateTime dob);

  AdminPatientIn gender(AdminPatientInGenderEnum gender);

  AdminPatientIn language(AdminPatientInLanguageEnum language);

  AdminPatientIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPatientIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPatientIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPatientIn call({
    String fullName,
    DateTime dob,
    AdminPatientInGenderEnum gender,
    AdminPatientInLanguageEnum language,
    String reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminPatientIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminPatientIn.copyWith.fieldName(...)`
class _$AdminPatientInCWProxyImpl implements _$AdminPatientInCWProxy {
  const _$AdminPatientInCWProxyImpl(this._value);

  final AdminPatientIn _value;

  @override
  AdminPatientIn fullName(String fullName) => this(fullName: fullName);

  @override
  AdminPatientIn dob(DateTime dob) => this(dob: dob);

  @override
  AdminPatientIn gender(AdminPatientInGenderEnum gender) =>
      this(gender: gender);

  @override
  AdminPatientIn language(AdminPatientInLanguageEnum language) =>
      this(language: language);

  @override
  AdminPatientIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPatientIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPatientIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPatientIn call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return AdminPatientIn(
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
          : gender as AdminPatientInGenderEnum,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as AdminPatientInLanguageEnum,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $AdminPatientInCopyWith on AdminPatientIn {
  /// Returns a callable class that can be used as follows: `instanceOfAdminPatientIn.copyWith(...)` or like so:`instanceOfAdminPatientIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminPatientInCWProxy get copyWith => _$AdminPatientInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminPatientIn _$AdminPatientInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminPatientIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['fullName', 'dob', 'gender', 'language', 'reason'],
      );
      final val = AdminPatientIn(
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert('dob', (v) => DateTime.parse(v as String)),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$AdminPatientInGenderEnumEnumMap, v),
        ),
        language: $checkedConvert(
          'language',
          (v) => $enumDecode(_$AdminPatientInLanguageEnumEnumMap, v),
        ),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminPatientInToJson(AdminPatientIn instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'dob': instance.dob.toIso8601String(),
      'gender': _$AdminPatientInGenderEnumEnumMap[instance.gender]!,
      'language': _$AdminPatientInLanguageEnumEnumMap[instance.language]!,
      'reason': instance.reason,
    };

const _$AdminPatientInGenderEnumEnumMap = {
  AdminPatientInGenderEnum.FEMALE: 'FEMALE',
  AdminPatientInGenderEnum.MALE: 'MALE',
  AdminPatientInGenderEnum.OTHER: 'OTHER',
};

const _$AdminPatientInLanguageEnumEnumMap = {
  AdminPatientInLanguageEnum.en: 'en',
  AdminPatientInLanguageEnum.hi: 'hi',
  AdminPatientInLanguageEnum.or: 'or',
};
