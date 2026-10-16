// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_me_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffMeOutCWProxy {
  StaffMeOut id(String id);

  StaffMeOut name(String name);

  StaffMeOut email(String email);

  StaffMeOut role(StaffRoleOut role);

  StaffMeOut permissions(List<String> permissions);

  StaffMeOut recoveryCodesLeft(int recoveryCodesLeft);

  StaffMeOut recoveryCodesSaved(bool recoveryCodesSaved);

  StaffMeOut onlySuperAdmin(bool onlySuperAdmin);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffMeOut call({
    String id,
    String name,
    String email,
    StaffRoleOut role,
    List<String> permissions,
    int recoveryCodesLeft,
    bool recoveryCodesSaved,
    bool onlySuperAdmin,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffMeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffMeOut.copyWith.fieldName(...)`
class _$StaffMeOutCWProxyImpl implements _$StaffMeOutCWProxy {
  const _$StaffMeOutCWProxyImpl(this._value);

  final StaffMeOut _value;

  @override
  StaffMeOut id(String id) => this(id: id);

  @override
  StaffMeOut name(String name) => this(name: name);

  @override
  StaffMeOut email(String email) => this(email: email);

  @override
  StaffMeOut role(StaffRoleOut role) => this(role: role);

  @override
  StaffMeOut permissions(List<String> permissions) =>
      this(permissions: permissions);

  @override
  StaffMeOut recoveryCodesLeft(int recoveryCodesLeft) =>
      this(recoveryCodesLeft: recoveryCodesLeft);

  @override
  StaffMeOut recoveryCodesSaved(bool recoveryCodesSaved) =>
      this(recoveryCodesSaved: recoveryCodesSaved);

  @override
  StaffMeOut onlySuperAdmin(bool onlySuperAdmin) =>
      this(onlySuperAdmin: onlySuperAdmin);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffMeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
    Object? recoveryCodesLeft = const $CopyWithPlaceholder(),
    Object? recoveryCodesSaved = const $CopyWithPlaceholder(),
    Object? onlySuperAdmin = const $CopyWithPlaceholder(),
  }) {
    return StaffMeOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
          : role as StaffRoleOut,
      permissions: permissions == const $CopyWithPlaceholder()
          ? _value.permissions
          // ignore: cast_nullable_to_non_nullable
          : permissions as List<String>,
      recoveryCodesLeft: recoveryCodesLeft == const $CopyWithPlaceholder()
          ? _value.recoveryCodesLeft
          // ignore: cast_nullable_to_non_nullable
          : recoveryCodesLeft as int,
      recoveryCodesSaved: recoveryCodesSaved == const $CopyWithPlaceholder()
          ? _value.recoveryCodesSaved
          // ignore: cast_nullable_to_non_nullable
          : recoveryCodesSaved as bool,
      onlySuperAdmin: onlySuperAdmin == const $CopyWithPlaceholder()
          ? _value.onlySuperAdmin
          // ignore: cast_nullable_to_non_nullable
          : onlySuperAdmin as bool,
    );
  }
}

extension $StaffMeOutCopyWith on StaffMeOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffMeOut.copyWith(...)` or like so:`instanceOfStaffMeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffMeOutCWProxy get copyWith => _$StaffMeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffMeOut _$StaffMeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffMeOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'email',
          'role',
          'permissions',
          'recoveryCodesLeft',
          'recoveryCodesSaved',
          'onlySuperAdmin',
        ],
      );
      final val = StaffMeOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => StaffRoleOut.fromJson(v as Map<String, dynamic>),
        ),
        permissions: $checkedConvert(
          'permissions',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        recoveryCodesLeft: $checkedConvert(
          'recoveryCodesLeft',
          (v) => (v as num).toInt(),
        ),
        recoveryCodesSaved: $checkedConvert(
          'recoveryCodesSaved',
          (v) => v as bool,
        ),
        onlySuperAdmin: $checkedConvert('onlySuperAdmin', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$StaffMeOutToJson(StaffMeOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role.toJson(),
      'permissions': instance.permissions,
      'recoveryCodesLeft': instance.recoveryCodesLeft,
      'recoveryCodesSaved': instance.recoveryCodesSaved,
      'onlySuperAdmin': instance.onlySuperAdmin,
    };
