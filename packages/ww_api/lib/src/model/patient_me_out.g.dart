// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_me_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientMeOutCWProxy {
  PatientMeOut id(String id);

  PatientMeOut phone(String phone);

  PatientMeOut fullName(String fullName);

  PatientMeOut dob(DateTime? dob);

  PatientMeOut gender(String gender);

  PatientMeOut language(String language);

  PatientMeOut selfMemberId(String selfMemberId);

  PatientMeOut profileComplete(bool profileComplete);

  PatientMeOut consentsNeeded(List<ConsentNeededOut> consentsNeeded);

  PatientMeOut googleLinked(bool googleLinked);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientMeOut call({
    String id,
    String phone,
    String fullName,
    DateTime? dob,
    String gender,
    String language,
    String selfMemberId,
    bool profileComplete,
    List<ConsentNeededOut> consentsNeeded,
    bool googleLinked,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientMeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientMeOut.copyWith.fieldName(...)`
class _$PatientMeOutCWProxyImpl implements _$PatientMeOutCWProxy {
  const _$PatientMeOutCWProxyImpl(this._value);

  final PatientMeOut _value;

  @override
  PatientMeOut id(String id) => this(id: id);

  @override
  PatientMeOut phone(String phone) => this(phone: phone);

  @override
  PatientMeOut fullName(String fullName) => this(fullName: fullName);

  @override
  PatientMeOut dob(DateTime? dob) => this(dob: dob);

  @override
  PatientMeOut gender(String gender) => this(gender: gender);

  @override
  PatientMeOut language(String language) => this(language: language);

  @override
  PatientMeOut selfMemberId(String selfMemberId) =>
      this(selfMemberId: selfMemberId);

  @override
  PatientMeOut profileComplete(bool profileComplete) =>
      this(profileComplete: profileComplete);

  @override
  PatientMeOut consentsNeeded(List<ConsentNeededOut> consentsNeeded) =>
      this(consentsNeeded: consentsNeeded);

  @override
  PatientMeOut googleLinked(bool googleLinked) =>
      this(googleLinked: googleLinked);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientMeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? selfMemberId = const $CopyWithPlaceholder(),
    Object? profileComplete = const $CopyWithPlaceholder(),
    Object? consentsNeeded = const $CopyWithPlaceholder(),
    Object? googleLinked = const $CopyWithPlaceholder(),
  }) {
    return PatientMeOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      dob: dob == const $CopyWithPlaceholder()
          ? _value.dob
          // ignore: cast_nullable_to_non_nullable
          : dob as DateTime?,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
      selfMemberId: selfMemberId == const $CopyWithPlaceholder()
          ? _value.selfMemberId
          // ignore: cast_nullable_to_non_nullable
          : selfMemberId as String,
      profileComplete: profileComplete == const $CopyWithPlaceholder()
          ? _value.profileComplete
          // ignore: cast_nullable_to_non_nullable
          : profileComplete as bool,
      consentsNeeded: consentsNeeded == const $CopyWithPlaceholder()
          ? _value.consentsNeeded
          // ignore: cast_nullable_to_non_nullable
          : consentsNeeded as List<ConsentNeededOut>,
      googleLinked: googleLinked == const $CopyWithPlaceholder()
          ? _value.googleLinked
          // ignore: cast_nullable_to_non_nullable
          : googleLinked as bool,
    );
  }
}

extension $PatientMeOutCopyWith on PatientMeOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientMeOut.copyWith(...)` or like so:`instanceOfPatientMeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientMeOutCWProxy get copyWith => _$PatientMeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientMeOut _$PatientMeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientMeOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phone',
          'fullName',
          'dob',
          'gender',
          'language',
          'selfMemberId',
          'profileComplete',
          'consentsNeeded',
          'googleLinked',
        ],
      );
      final val = PatientMeOut(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert(
          'dob',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        gender: $checkedConvert('gender', (v) => v as String),
        language: $checkedConvert('language', (v) => v as String),
        selfMemberId: $checkedConvert('selfMemberId', (v) => v as String),
        profileComplete: $checkedConvert('profileComplete', (v) => v as bool),
        consentsNeeded: $checkedConvert(
          'consentsNeeded',
          (v) => (v as List<dynamic>)
              .map((e) => ConsentNeededOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        googleLinked: $checkedConvert('googleLinked', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PatientMeOutToJson(PatientMeOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'dob': instance.dob?.toIso8601String(),
      'gender': instance.gender,
      'language': instance.language,
      'selfMemberId': instance.selfMemberId,
      'profileComplete': instance.profileComplete,
      'consentsNeeded': instance.consentsNeeded.map((e) => e.toJson()).toList(),
      'googleLinked': instance.googleLinked,
    };
