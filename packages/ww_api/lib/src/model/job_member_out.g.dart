// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_member_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobMemberOutCWProxy {
  JobMemberOut fullName(String fullName);

  JobMemberOut relation(String relation);

  JobMemberOut gender(String gender);

  JobMemberOut age(int? age);

  JobMemberOut language(String language);

  JobMemberOut phone(String phone);

  JobMemberOut photoUrl(String? photoUrl);

  JobMemberOut mobility(String mobility);

  JobMemberOut conditions(String conditions);

  JobMemberOut allergies(String allergies);

  JobMemberOut sensoryNotes(String sensoryNotes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  JobMemberOut call({
    String fullName,
    String relation,
    String gender,
    int? age,
    String language,
    String phone,
    String? photoUrl,
    String mobility,
    String conditions,
    String allergies,
    String sensoryNotes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobMemberOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobMemberOut.copyWith.fieldName(...)`
class _$JobMemberOutCWProxyImpl implements _$JobMemberOutCWProxy {
  const _$JobMemberOutCWProxyImpl(this._value);

  final JobMemberOut _value;

  @override
  JobMemberOut fullName(String fullName) => this(fullName: fullName);

  @override
  JobMemberOut relation(String relation) => this(relation: relation);

  @override
  JobMemberOut gender(String gender) => this(gender: gender);

  @override
  JobMemberOut age(int? age) => this(age: age);

  @override
  JobMemberOut language(String language) => this(language: language);

  @override
  JobMemberOut phone(String phone) => this(phone: phone);

  @override
  JobMemberOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  JobMemberOut mobility(String mobility) => this(mobility: mobility);

  @override
  JobMemberOut conditions(String conditions) => this(conditions: conditions);

  @override
  JobMemberOut allergies(String allergies) => this(allergies: allergies);

  @override
  JobMemberOut sensoryNotes(String sensoryNotes) =>
      this(sensoryNotes: sensoryNotes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  JobMemberOut call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? relation = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? age = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? mobility = const $CopyWithPlaceholder(),
    Object? conditions = const $CopyWithPlaceholder(),
    Object? allergies = const $CopyWithPlaceholder(),
    Object? sensoryNotes = const $CopyWithPlaceholder(),
  }) {
    return JobMemberOut(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      relation: relation == const $CopyWithPlaceholder()
          ? _value.relation
          // ignore: cast_nullable_to_non_nullable
          : relation as String,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String,
      age: age == const $CopyWithPlaceholder()
          ? _value.age
          // ignore: cast_nullable_to_non_nullable
          : age as int?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      mobility: mobility == const $CopyWithPlaceholder()
          ? _value.mobility
          // ignore: cast_nullable_to_non_nullable
          : mobility as String,
      conditions: conditions == const $CopyWithPlaceholder()
          ? _value.conditions
          // ignore: cast_nullable_to_non_nullable
          : conditions as String,
      allergies: allergies == const $CopyWithPlaceholder()
          ? _value.allergies
          // ignore: cast_nullable_to_non_nullable
          : allergies as String,
      sensoryNotes: sensoryNotes == const $CopyWithPlaceholder()
          ? _value.sensoryNotes
          // ignore: cast_nullable_to_non_nullable
          : sensoryNotes as String,
    );
  }
}

extension $JobMemberOutCopyWith on JobMemberOut {
  /// Returns a callable class that can be used as follows: `instanceOfJobMemberOut.copyWith(...)` or like so:`instanceOfJobMemberOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobMemberOutCWProxy get copyWith => _$JobMemberOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobMemberOut _$JobMemberOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobMemberOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'fullName',
          'relation',
          'gender',
          'age',
          'language',
          'phone',
          'photoUrl',
          'mobility',
          'conditions',
          'allergies',
          'sensoryNotes',
        ],
      );
      final val = JobMemberOut(
        fullName: $checkedConvert('fullName', (v) => v as String),
        relation: $checkedConvert('relation', (v) => v as String),
        gender: $checkedConvert('gender', (v) => v as String),
        age: $checkedConvert('age', (v) => (v as num?)?.toInt()),
        language: $checkedConvert('language', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        mobility: $checkedConvert('mobility', (v) => v as String),
        conditions: $checkedConvert('conditions', (v) => v as String),
        allergies: $checkedConvert('allergies', (v) => v as String),
        sensoryNotes: $checkedConvert('sensoryNotes', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$JobMemberOutToJson(JobMemberOut instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'relation': instance.relation,
      'gender': instance.gender,
      'age': instance.age,
      'language': instance.language,
      'phone': instance.phone,
      'photoUrl': instance.photoUrl,
      'mobility': instance.mobility,
      'conditions': instance.conditions,
      'allergies': instance.allergies,
      'sensoryNotes': instance.sensoryNotes,
    };
