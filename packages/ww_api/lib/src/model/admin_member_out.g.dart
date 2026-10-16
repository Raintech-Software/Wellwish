// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_member_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminMemberOutCWProxy {
  AdminMemberOut id(String id);

  AdminMemberOut relation(String relation);

  AdminMemberOut fullName(String fullName);

  AdminMemberOut age(int? age);

  AdminMemberOut gender(String gender);

  AdminMemberOut phone(String phone);

  AdminMemberOut language(String language);

  AdminMemberOut isActive(bool isActive);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminMemberOut call({
    String id,
    String relation,
    String fullName,
    int? age,
    String gender,
    String phone,
    String language,
    bool isActive,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminMemberOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminMemberOut.copyWith.fieldName(...)`
class _$AdminMemberOutCWProxyImpl implements _$AdminMemberOutCWProxy {
  const _$AdminMemberOutCWProxyImpl(this._value);

  final AdminMemberOut _value;

  @override
  AdminMemberOut id(String id) => this(id: id);

  @override
  AdminMemberOut relation(String relation) => this(relation: relation);

  @override
  AdminMemberOut fullName(String fullName) => this(fullName: fullName);

  @override
  AdminMemberOut age(int? age) => this(age: age);

  @override
  AdminMemberOut gender(String gender) => this(gender: gender);

  @override
  AdminMemberOut phone(String phone) => this(phone: phone);

  @override
  AdminMemberOut language(String language) => this(language: language);

  @override
  AdminMemberOut isActive(bool isActive) => this(isActive: isActive);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminMemberOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? relation = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? age = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? isActive = const $CopyWithPlaceholder(),
  }) {
    return AdminMemberOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      relation: relation == const $CopyWithPlaceholder()
          ? _value.relation
          // ignore: cast_nullable_to_non_nullable
          : relation as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      age: age == const $CopyWithPlaceholder()
          ? _value.age
          // ignore: cast_nullable_to_non_nullable
          : age as int?,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
      isActive: isActive == const $CopyWithPlaceholder()
          ? _value.isActive
          // ignore: cast_nullable_to_non_nullable
          : isActive as bool,
    );
  }
}

extension $AdminMemberOutCopyWith on AdminMemberOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminMemberOut.copyWith(...)` or like so:`instanceOfAdminMemberOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminMemberOutCWProxy get copyWith => _$AdminMemberOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminMemberOut _$AdminMemberOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminMemberOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'relation',
          'fullName',
          'age',
          'gender',
          'phone',
          'language',
          'isActive',
        ],
      );
      final val = AdminMemberOut(
        id: $checkedConvert('id', (v) => v as String),
        relation: $checkedConvert('relation', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        age: $checkedConvert('age', (v) => (v as num?)?.toInt()),
        gender: $checkedConvert('gender', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        language: $checkedConvert('language', (v) => v as String),
        isActive: $checkedConvert('isActive', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AdminMemberOutToJson(AdminMemberOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'relation': instance.relation,
      'fullName': instance.fullName,
      'age': instance.age,
      'gender': instance.gender,
      'phone': instance.phone,
      'language': instance.language,
      'isActive': instance.isActive,
    };
