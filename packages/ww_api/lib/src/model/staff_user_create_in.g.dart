// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_create_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUserCreateInCWProxy {
  StaffUserCreateIn name(String name);

  StaffUserCreateIn email(String email);

  StaffUserCreateIn role(String role);

  StaffUserCreateIn password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserCreateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserCreateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserCreateIn call({
    String name,
    String email,
    String role,
    String password,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUserCreateIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUserCreateIn.copyWith.fieldName(...)`
class _$StaffUserCreateInCWProxyImpl implements _$StaffUserCreateInCWProxy {
  const _$StaffUserCreateInCWProxyImpl(this._value);

  final StaffUserCreateIn _value;

  @override
  StaffUserCreateIn name(String name) => this(name: name);

  @override
  StaffUserCreateIn email(String email) => this(email: email);

  @override
  StaffUserCreateIn role(String role) => this(role: role);

  @override
  StaffUserCreateIn password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserCreateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserCreateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserCreateIn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return StaffUserCreateIn(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $StaffUserCreateInCopyWith on StaffUserCreateIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUserCreateIn.copyWith(...)` or like so:`instanceOfStaffUserCreateIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUserCreateInCWProxy get copyWith =>
      _$StaffUserCreateInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserCreateIn _$StaffUserCreateInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUserCreateIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['name', 'email', 'role', 'password'],
      );
      final val = StaffUserCreateIn(
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserCreateInToJson(StaffUserCreateIn instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'password': instance.password,
    };
