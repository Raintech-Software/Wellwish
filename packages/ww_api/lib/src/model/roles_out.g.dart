// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RolesOutCWProxy {
  RolesOut roles(List<RoleOut> roles);

  RolesOut permissions(List<PermissionOut> permissions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RolesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RolesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RolesOut call({List<RoleOut> roles, List<PermissionOut> permissions});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRolesOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRolesOut.copyWith.fieldName(...)`
class _$RolesOutCWProxyImpl implements _$RolesOutCWProxy {
  const _$RolesOutCWProxyImpl(this._value);

  final RolesOut _value;

  @override
  RolesOut roles(List<RoleOut> roles) => this(roles: roles);

  @override
  RolesOut permissions(List<PermissionOut> permissions) =>
      this(permissions: permissions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RolesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RolesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RolesOut call({
    Object? roles = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
  }) {
    return RolesOut(
      roles: roles == const $CopyWithPlaceholder()
          ? _value.roles
          // ignore: cast_nullable_to_non_nullable
          : roles as List<RoleOut>,
      permissions: permissions == const $CopyWithPlaceholder()
          ? _value.permissions
          // ignore: cast_nullable_to_non_nullable
          : permissions as List<PermissionOut>,
    );
  }
}

extension $RolesOutCopyWith on RolesOut {
  /// Returns a callable class that can be used as follows: `instanceOfRolesOut.copyWith(...)` or like so:`instanceOfRolesOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RolesOutCWProxy get copyWith => _$RolesOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesOut _$RolesOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RolesOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['roles', 'permissions']);
      final val = RolesOut(
        roles: $checkedConvert(
          'roles',
          (v) => (v as List<dynamic>)
              .map((e) => RoleOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        permissions: $checkedConvert(
          'permissions',
          (v) => (v as List<dynamic>)
              .map((e) => PermissionOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RolesOutToJson(RolesOut instance) => <String, dynamic>{
  'roles': instance.roles.map((e) => e.toJson()).toList(),
  'permissions': instance.permissions.map((e) => e.toJson()).toList(),
};
