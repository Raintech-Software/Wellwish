// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_update_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUserUpdateInCWProxy {
  StaffUserUpdateIn name(String name);

  StaffUserUpdateIn role(String role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserUpdateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserUpdateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserUpdateIn call({String name, String role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUserUpdateIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUserUpdateIn.copyWith.fieldName(...)`
class _$StaffUserUpdateInCWProxyImpl implements _$StaffUserUpdateInCWProxy {
  const _$StaffUserUpdateInCWProxyImpl(this._value);

  final StaffUserUpdateIn _value;

  @override
  StaffUserUpdateIn name(String name) => this(name: name);

  @override
  StaffUserUpdateIn role(String role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserUpdateIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserUpdateIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserUpdateIn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
  }) {
    return StaffUserUpdateIn(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
    );
  }
}

extension $StaffUserUpdateInCopyWith on StaffUserUpdateIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUserUpdateIn.copyWith(...)` or like so:`instanceOfStaffUserUpdateIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUserUpdateInCWProxy get copyWith =>
      _$StaffUserUpdateInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserUpdateIn _$StaffUserUpdateInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUserUpdateIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'role']);
      final val = StaffUserUpdateIn(
        name: $checkedConvert('name', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserUpdateInToJson(StaffUserUpdateIn instance) =>
    <String, dynamic>{'name': instance.name, 'role': instance.role};
