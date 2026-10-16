// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RoleOutCWProxy {
  RoleOut code(String code);

  RoleOut name(String name);

  RoleOut permissions(List<String> permissions);

  RoleOut userCount(int userCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RoleOut call({
    String code,
    String name,
    List<String> permissions,
    int userCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRoleOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRoleOut.copyWith.fieldName(...)`
class _$RoleOutCWProxyImpl implements _$RoleOutCWProxy {
  const _$RoleOutCWProxyImpl(this._value);

  final RoleOut _value;

  @override
  RoleOut code(String code) => this(code: code);

  @override
  RoleOut name(String name) => this(name: name);

  @override
  RoleOut permissions(List<String> permissions) =>
      this(permissions: permissions);

  @override
  RoleOut userCount(int userCount) => this(userCount: userCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RoleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RoleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RoleOut call({
    Object? code = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
    Object? userCount = const $CopyWithPlaceholder(),
  }) {
    return RoleOut(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      permissions: permissions == const $CopyWithPlaceholder()
          ? _value.permissions
          // ignore: cast_nullable_to_non_nullable
          : permissions as List<String>,
      userCount: userCount == const $CopyWithPlaceholder()
          ? _value.userCount
          // ignore: cast_nullable_to_non_nullable
          : userCount as int,
    );
  }
}

extension $RoleOutCopyWith on RoleOut {
  /// Returns a callable class that can be used as follows: `instanceOfRoleOut.copyWith(...)` or like so:`instanceOfRoleOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RoleOutCWProxy get copyWith => _$RoleOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleOut _$RoleOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RoleOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['code', 'name', 'permissions', 'userCount'],
      );
      final val = RoleOut(
        code: $checkedConvert('code', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        permissions: $checkedConvert(
          'permissions',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        userCount: $checkedConvert('userCount', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$RoleOutToJson(RoleOut instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'permissions': instance.permissions,
  'userCount': instance.userCount,
};
