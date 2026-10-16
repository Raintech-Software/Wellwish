// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MemberInCWProxy {
  MemberIn relation(MemberInRelationEnum relation);

  MemberIn fullName(String fullName);

  MemberIn dob(DateTime dob);

  MemberIn gender(MemberInGenderEnum gender);

  MemberIn photoKey(String photoKey);

  MemberIn phone(String phone);

  MemberIn language(MemberInLanguageEnum language);

  MemberIn conditions(String conditions);

  MemberIn allergies(String allergies);

  MemberIn mobility(MemberInMobilityEnum mobility);

  MemberIn sensoryNotes(String sensoryNotes);

  MemberIn emergencyName(String emergencyName);

  MemberIn emergencyPhone(String emergencyPhone);

  MemberIn consent(bool consent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberIn call({
    MemberInRelationEnum relation,
    String fullName,
    DateTime dob,
    MemberInGenderEnum gender,
    String photoKey,
    String phone,
    MemberInLanguageEnum language,
    String conditions,
    String allergies,
    MemberInMobilityEnum mobility,
    String sensoryNotes,
    String emergencyName,
    String emergencyPhone,
    bool consent,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMemberIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMemberIn.copyWith.fieldName(...)`
class _$MemberInCWProxyImpl implements _$MemberInCWProxy {
  const _$MemberInCWProxyImpl(this._value);

  final MemberIn _value;

  @override
  MemberIn relation(MemberInRelationEnum relation) => this(relation: relation);

  @override
  MemberIn fullName(String fullName) => this(fullName: fullName);

  @override
  MemberIn dob(DateTime dob) => this(dob: dob);

  @override
  MemberIn gender(MemberInGenderEnum gender) => this(gender: gender);

  @override
  MemberIn photoKey(String photoKey) => this(photoKey: photoKey);

  @override
  MemberIn phone(String phone) => this(phone: phone);

  @override
  MemberIn language(MemberInLanguageEnum language) => this(language: language);

  @override
  MemberIn conditions(String conditions) => this(conditions: conditions);

  @override
  MemberIn allergies(String allergies) => this(allergies: allergies);

  @override
  MemberIn mobility(MemberInMobilityEnum mobility) => this(mobility: mobility);

  @override
  MemberIn sensoryNotes(String sensoryNotes) =>
      this(sensoryNotes: sensoryNotes);

  @override
  MemberIn emergencyName(String emergencyName) =>
      this(emergencyName: emergencyName);

  @override
  MemberIn emergencyPhone(String emergencyPhone) =>
      this(emergencyPhone: emergencyPhone);

  @override
  MemberIn consent(bool consent) => this(consent: consent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberIn call({
    Object? relation = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? dob = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? photoKey = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? conditions = const $CopyWithPlaceholder(),
    Object? allergies = const $CopyWithPlaceholder(),
    Object? mobility = const $CopyWithPlaceholder(),
    Object? sensoryNotes = const $CopyWithPlaceholder(),
    Object? emergencyName = const $CopyWithPlaceholder(),
    Object? emergencyPhone = const $CopyWithPlaceholder(),
    Object? consent = const $CopyWithPlaceholder(),
  }) {
    return MemberIn(
      relation: relation == const $CopyWithPlaceholder()
          ? _value.relation
          // ignore: cast_nullable_to_non_nullable
          : relation as MemberInRelationEnum,
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
          : gender as MemberInGenderEnum,
      photoKey: photoKey == const $CopyWithPlaceholder()
          ? _value.photoKey
          // ignore: cast_nullable_to_non_nullable
          : photoKey as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as MemberInLanguageEnum,
      conditions: conditions == const $CopyWithPlaceholder()
          ? _value.conditions
          // ignore: cast_nullable_to_non_nullable
          : conditions as String,
      allergies: allergies == const $CopyWithPlaceholder()
          ? _value.allergies
          // ignore: cast_nullable_to_non_nullable
          : allergies as String,
      mobility: mobility == const $CopyWithPlaceholder()
          ? _value.mobility
          // ignore: cast_nullable_to_non_nullable
          : mobility as MemberInMobilityEnum,
      sensoryNotes: sensoryNotes == const $CopyWithPlaceholder()
          ? _value.sensoryNotes
          // ignore: cast_nullable_to_non_nullable
          : sensoryNotes as String,
      emergencyName: emergencyName == const $CopyWithPlaceholder()
          ? _value.emergencyName
          // ignore: cast_nullable_to_non_nullable
          : emergencyName as String,
      emergencyPhone: emergencyPhone == const $CopyWithPlaceholder()
          ? _value.emergencyPhone
          // ignore: cast_nullable_to_non_nullable
          : emergencyPhone as String,
      consent: consent == const $CopyWithPlaceholder()
          ? _value.consent
          // ignore: cast_nullable_to_non_nullable
          : consent as bool,
    );
  }
}

extension $MemberInCopyWith on MemberIn {
  /// Returns a callable class that can be used as follows: `instanceOfMemberIn.copyWith(...)` or like so:`instanceOfMemberIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MemberInCWProxy get copyWith => _$MemberInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberIn _$MemberInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MemberIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'relation',
          'fullName',
          'dob',
          'gender',
          'photoKey',
          'phone',
          'language',
          'conditions',
          'allergies',
          'mobility',
          'sensoryNotes',
          'emergencyName',
          'emergencyPhone',
          'consent',
        ],
      );
      final val = MemberIn(
        relation: $checkedConvert(
          'relation',
          (v) => $enumDecode(_$MemberInRelationEnumEnumMap, v),
        ),
        fullName: $checkedConvert('fullName', (v) => v as String),
        dob: $checkedConvert('dob', (v) => DateTime.parse(v as String)),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$MemberInGenderEnumEnumMap, v),
        ),
        photoKey: $checkedConvert('photoKey', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        language: $checkedConvert(
          'language',
          (v) => $enumDecode(_$MemberInLanguageEnumEnumMap, v),
        ),
        conditions: $checkedConvert('conditions', (v) => v as String),
        allergies: $checkedConvert('allergies', (v) => v as String),
        mobility: $checkedConvert(
          'mobility',
          (v) => $enumDecode(_$MemberInMobilityEnumEnumMap, v),
        ),
        sensoryNotes: $checkedConvert('sensoryNotes', (v) => v as String),
        emergencyName: $checkedConvert('emergencyName', (v) => v as String),
        emergencyPhone: $checkedConvert('emergencyPhone', (v) => v as String),
        consent: $checkedConvert('consent', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$MemberInToJson(MemberIn instance) => <String, dynamic>{
  'relation': _$MemberInRelationEnumEnumMap[instance.relation]!,
  'fullName': instance.fullName,
  'dob': instance.dob.toIso8601String(),
  'gender': _$MemberInGenderEnumEnumMap[instance.gender]!,
  'photoKey': instance.photoKey,
  'phone': instance.phone,
  'language': _$MemberInLanguageEnumEnumMap[instance.language]!,
  'conditions': instance.conditions,
  'allergies': instance.allergies,
  'mobility': _$MemberInMobilityEnumEnumMap[instance.mobility]!,
  'sensoryNotes': instance.sensoryNotes,
  'emergencyName': instance.emergencyName,
  'emergencyPhone': instance.emergencyPhone,
  'consent': instance.consent,
};

const _$MemberInRelationEnumEnumMap = {
  MemberInRelationEnum.SELF: 'SELF',
  MemberInRelationEnum.MOTHER: 'MOTHER',
  MemberInRelationEnum.FATHER: 'FATHER',
  MemberInRelationEnum.GRANDMOTHER: 'GRANDMOTHER',
  MemberInRelationEnum.GRANDFATHER: 'GRANDFATHER',
  MemberInRelationEnum.SPOUSE: 'SPOUSE',
  MemberInRelationEnum.CHILD: 'CHILD',
  MemberInRelationEnum.SIBLING: 'SIBLING',
  MemberInRelationEnum.OTHER: 'OTHER',
};

const _$MemberInGenderEnumEnumMap = {
  MemberInGenderEnum.FEMALE: 'FEMALE',
  MemberInGenderEnum.MALE: 'MALE',
  MemberInGenderEnum.OTHER: 'OTHER',
};

const _$MemberInLanguageEnumEnumMap = {
  MemberInLanguageEnum.empty: '',
  MemberInLanguageEnum.odia: 'Odia',
  MemberInLanguageEnum.hindi: 'Hindi',
  MemberInLanguageEnum.english: 'English',
  MemberInLanguageEnum.bengali: 'Bengali',
  MemberInLanguageEnum.telugu: 'Telugu',
};

const _$MemberInMobilityEnumEnumMap = {
  MemberInMobilityEnum.empty: '',
  MemberInMobilityEnum.WALKS_ALONE: 'WALKS_ALONE',
  MemberInMobilityEnum.NEEDS_SUPPORT: 'NEEDS_SUPPORT',
  MemberInMobilityEnum.WHEELCHAIR: 'WHEELCHAIR',
};
