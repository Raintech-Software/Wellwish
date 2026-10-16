// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_login_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffLoginInCWProxy {
  StaffLoginIn email(String email);

  StaffLoginIn password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffLoginIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffLoginIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffLoginIn call({String email, String password});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffLoginIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffLoginIn.copyWith.fieldName(...)`
class _$StaffLoginInCWProxyImpl implements _$StaffLoginInCWProxy {
  const _$StaffLoginInCWProxyImpl(this._value);

  final StaffLoginIn _value;

  @override
  StaffLoginIn email(String email) => this(email: email);

  @override
  StaffLoginIn password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffLoginIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffLoginIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffLoginIn call({
    Object? email = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
  }) {
    return StaffLoginIn(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $StaffLoginInCopyWith on StaffLoginIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffLoginIn.copyWith(...)` or like so:`instanceOfStaffLoginIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffLoginInCWProxy get copyWith => _$StaffLoginInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffLoginIn _$StaffLoginInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffLoginIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email', 'password']);
      final val = StaffLoginIn(
        email: $checkedConvert('email', (v) => v as String),
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffLoginInToJson(StaffLoginIn instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};
