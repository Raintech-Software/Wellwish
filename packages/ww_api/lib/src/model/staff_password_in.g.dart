// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_password_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffPasswordInCWProxy {
  StaffPasswordIn password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffPasswordIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffPasswordIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffPasswordIn call({String password});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffPasswordIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffPasswordIn.copyWith.fieldName(...)`
class _$StaffPasswordInCWProxyImpl implements _$StaffPasswordInCWProxy {
  const _$StaffPasswordInCWProxyImpl(this._value);

  final StaffPasswordIn _value;

  @override
  StaffPasswordIn password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffPasswordIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffPasswordIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffPasswordIn call({Object? password = const $CopyWithPlaceholder()}) {
    return StaffPasswordIn(
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $StaffPasswordInCopyWith on StaffPasswordIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffPasswordIn.copyWith(...)` or like so:`instanceOfStaffPasswordIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffPasswordInCWProxy get copyWith => _$StaffPasswordInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffPasswordIn _$StaffPasswordInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffPasswordIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['password']);
      final val = StaffPasswordIn(
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffPasswordInToJson(StaffPasswordIn instance) =>
    <String, dynamic>{'password': instance.password};
