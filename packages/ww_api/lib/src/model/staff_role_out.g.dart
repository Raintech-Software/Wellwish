// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_role_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffRoleOutCWProxy {
  StaffRoleOut code(String code);

  StaffRoleOut name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffRoleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffRoleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffRoleOut call({String code, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffRoleOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffRoleOut.copyWith.fieldName(...)`
class _$StaffRoleOutCWProxyImpl implements _$StaffRoleOutCWProxy {
  const _$StaffRoleOutCWProxyImpl(this._value);

  final StaffRoleOut _value;

  @override
  StaffRoleOut code(String code) => this(code: code);

  @override
  StaffRoleOut name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffRoleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffRoleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffRoleOut call({
    Object? code = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return StaffRoleOut(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $StaffRoleOutCopyWith on StaffRoleOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffRoleOut.copyWith(...)` or like so:`instanceOfStaffRoleOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffRoleOutCWProxy get copyWith => _$StaffRoleOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffRoleOut _$StaffRoleOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffRoleOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'name']);
      final val = StaffRoleOut(
        code: $checkedConvert('code', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffRoleOutToJson(StaffRoleOut instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};
