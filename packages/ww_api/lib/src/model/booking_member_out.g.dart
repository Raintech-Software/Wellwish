// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_member_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingMemberOutCWProxy {
  BookingMemberOut id(String? id);

  BookingMemberOut fullName(String fullName);

  BookingMemberOut relation(String relation);

  BookingMemberOut gender(String gender);

  BookingMemberOut age(int? age);

  BookingMemberOut phone(String phone);

  BookingMemberOut language(String language);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingMemberOut call({
    String? id,
    String fullName,
    String relation,
    String gender,
    int? age,
    String phone,
    String language,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingMemberOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingMemberOut.copyWith.fieldName(...)`
class _$BookingMemberOutCWProxyImpl implements _$BookingMemberOutCWProxy {
  const _$BookingMemberOutCWProxyImpl(this._value);

  final BookingMemberOut _value;

  @override
  BookingMemberOut id(String? id) => this(id: id);

  @override
  BookingMemberOut fullName(String fullName) => this(fullName: fullName);

  @override
  BookingMemberOut relation(String relation) => this(relation: relation);

  @override
  BookingMemberOut gender(String gender) => this(gender: gender);

  @override
  BookingMemberOut age(int? age) => this(age: age);

  @override
  BookingMemberOut phone(String phone) => this(phone: phone);

  @override
  BookingMemberOut language(String language) => this(language: language);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingMemberOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingMemberOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingMemberOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? relation = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? age = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
  }) {
    return BookingMemberOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
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
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
    );
  }
}

extension $BookingMemberOutCopyWith on BookingMemberOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingMemberOut.copyWith(...)` or like so:`instanceOfBookingMemberOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingMemberOutCWProxy get copyWith => _$BookingMemberOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingMemberOut _$BookingMemberOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingMemberOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'fullName',
          'relation',
          'gender',
          'age',
          'phone',
          'language',
        ],
      );
      final val = BookingMemberOut(
        id: $checkedConvert('id', (v) => v as String?),
        fullName: $checkedConvert('fullName', (v) => v as String),
        relation: $checkedConvert('relation', (v) => v as String),
        gender: $checkedConvert('gender', (v) => v as String),
        age: $checkedConvert('age', (v) => (v as num?)?.toInt()),
        phone: $checkedConvert('phone', (v) => v as String),
        language: $checkedConvert('language', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$BookingMemberOutToJson(BookingMemberOut instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'fullName': instance.fullName,
      'relation': instance.relation,
      'gender': instance.gender,
      'age': instance.age,
      'phone': instance.phone,
      'language': instance.language,
    };
