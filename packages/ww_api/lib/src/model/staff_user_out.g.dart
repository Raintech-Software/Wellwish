// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffUserOutCWProxy {
  StaffUserOut id(String id);

  StaffUserOut name(String name);

  StaffUserOut email(String email);

  StaffUserOut role(StaffRoleOut role);

  StaffUserOut status(StaffUserOutStatusEnum status);

  StaffUserOut twoFactorSet(bool twoFactorSet);

  StaffUserOut lastLoginAt(DateTime? lastLoginAt);

  StaffUserOut createdAt(DateTime createdAt);

  StaffUserOut activeSessions(int activeSessions);

  StaffUserOut isYou(bool isYou);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserOut call({
    String id,
    String name,
    String email,
    StaffRoleOut role,
    StaffUserOutStatusEnum status,
    bool twoFactorSet,
    DateTime? lastLoginAt,
    DateTime createdAt,
    int activeSessions,
    bool isYou,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffUserOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffUserOut.copyWith.fieldName(...)`
class _$StaffUserOutCWProxyImpl implements _$StaffUserOutCWProxy {
  const _$StaffUserOutCWProxyImpl(this._value);

  final StaffUserOut _value;

  @override
  StaffUserOut id(String id) => this(id: id);

  @override
  StaffUserOut name(String name) => this(name: name);

  @override
  StaffUserOut email(String email) => this(email: email);

  @override
  StaffUserOut role(StaffRoleOut role) => this(role: role);

  @override
  StaffUserOut status(StaffUserOutStatusEnum status) => this(status: status);

  @override
  StaffUserOut twoFactorSet(bool twoFactorSet) =>
      this(twoFactorSet: twoFactorSet);

  @override
  StaffUserOut lastLoginAt(DateTime? lastLoginAt) =>
      this(lastLoginAt: lastLoginAt);

  @override
  StaffUserOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  StaffUserOut activeSessions(int activeSessions) =>
      this(activeSessions: activeSessions);

  @override
  StaffUserOut isYou(bool isYou) => this(isYou: isYou);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffUserOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffUserOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffUserOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? twoFactorSet = const $CopyWithPlaceholder(),
    Object? lastLoginAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? activeSessions = const $CopyWithPlaceholder(),
    Object? isYou = const $CopyWithPlaceholder(),
  }) {
    return StaffUserOut(
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
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as StaffUserOutStatusEnum,
      twoFactorSet: twoFactorSet == const $CopyWithPlaceholder()
          ? _value.twoFactorSet
          // ignore: cast_nullable_to_non_nullable
          : twoFactorSet as bool,
      lastLoginAt: lastLoginAt == const $CopyWithPlaceholder()
          ? _value.lastLoginAt
          // ignore: cast_nullable_to_non_nullable
          : lastLoginAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      activeSessions: activeSessions == const $CopyWithPlaceholder()
          ? _value.activeSessions
          // ignore: cast_nullable_to_non_nullable
          : activeSessions as int,
      isYou: isYou == const $CopyWithPlaceholder()
          ? _value.isYou
          // ignore: cast_nullable_to_non_nullable
          : isYou as bool,
    );
  }
}

extension $StaffUserOutCopyWith on StaffUserOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffUserOut.copyWith(...)` or like so:`instanceOfStaffUserOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffUserOutCWProxy get copyWith => _$StaffUserOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserOut _$StaffUserOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffUserOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'email',
          'role',
          'status',
          'twoFactorSet',
          'lastLoginAt',
          'createdAt',
          'activeSessions',
          'isYou',
        ],
      );
      final val = StaffUserOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        role: $checkedConvert(
          'role',
          (v) => StaffRoleOut.fromJson(v as Map<String, dynamic>),
        ),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$StaffUserOutStatusEnumEnumMap, v),
        ),
        twoFactorSet: $checkedConvert('twoFactorSet', (v) => v as bool),
        lastLoginAt: $checkedConvert(
          'lastLoginAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        activeSessions: $checkedConvert(
          'activeSessions',
          (v) => (v as num).toInt(),
        ),
        isYou: $checkedConvert('isYou', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$StaffUserOutToJson(StaffUserOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role.toJson(),
      'status': _$StaffUserOutStatusEnumEnumMap[instance.status]!,
      'twoFactorSet': instance.twoFactorSet,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'activeSessions': instance.activeSessions,
      'isYou': instance.isYou,
    };

const _$StaffUserOutStatusEnumEnumMap = {
  StaffUserOutStatusEnum.ACTIVE: 'ACTIVE',
  StaffUserOutStatusEnum.DISABLED: 'DISABLED',
};
