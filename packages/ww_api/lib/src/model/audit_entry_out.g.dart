// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditEntryOutCWProxy {
  AuditEntryOut id(String id);

  AuditEntryOut at(DateTime at);

  AuditEntryOut staff(AuditStaffOut? staff);

  AuditEntryOut action(String action);

  AuditEntryOut entityType(String entityType);

  AuditEntryOut entityId(String entityId);

  AuditEntryOut before(Map<String, Object>? before);

  AuditEntryOut after(Map<String, Object>? after);

  AuditEntryOut reason(String reason);

  AuditEntryOut ip(String? ip);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryOut call({
    String id,
    DateTime at,
    AuditStaffOut? staff,
    String action,
    String entityType,
    String entityId,
    Map<String, Object>? before,
    Map<String, Object>? after,
    String reason,
    String? ip,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditEntryOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditEntryOut.copyWith.fieldName(...)`
class _$AuditEntryOutCWProxyImpl implements _$AuditEntryOutCWProxy {
  const _$AuditEntryOutCWProxyImpl(this._value);

  final AuditEntryOut _value;

  @override
  AuditEntryOut id(String id) => this(id: id);

  @override
  AuditEntryOut at(DateTime at) => this(at: at);

  @override
  AuditEntryOut staff(AuditStaffOut? staff) => this(staff: staff);

  @override
  AuditEntryOut action(String action) => this(action: action);

  @override
  AuditEntryOut entityType(String entityType) => this(entityType: entityType);

  @override
  AuditEntryOut entityId(String entityId) => this(entityId: entityId);

  @override
  AuditEntryOut before(Map<String, Object>? before) => this(before: before);

  @override
  AuditEntryOut after(Map<String, Object>? after) => this(after: after);

  @override
  AuditEntryOut reason(String reason) => this(reason: reason);

  @override
  AuditEntryOut ip(String? ip) => this(ip: ip);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditEntryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditEntryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditEntryOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? staff = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? entityType = const $CopyWithPlaceholder(),
    Object? entityId = const $CopyWithPlaceholder(),
    Object? before = const $CopyWithPlaceholder(),
    Object? after = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? ip = const $CopyWithPlaceholder(),
  }) {
    return AuditEntryOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      staff: staff == const $CopyWithPlaceholder()
          ? _value.staff
          // ignore: cast_nullable_to_non_nullable
          : staff as AuditStaffOut?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      entityType: entityType == const $CopyWithPlaceholder()
          ? _value.entityType
          // ignore: cast_nullable_to_non_nullable
          : entityType as String,
      entityId: entityId == const $CopyWithPlaceholder()
          ? _value.entityId
          // ignore: cast_nullable_to_non_nullable
          : entityId as String,
      before: before == const $CopyWithPlaceholder()
          ? _value.before
          // ignore: cast_nullable_to_non_nullable
          : before as Map<String, Object>?,
      after: after == const $CopyWithPlaceholder()
          ? _value.after
          // ignore: cast_nullable_to_non_nullable
          : after as Map<String, Object>?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      ip: ip == const $CopyWithPlaceholder()
          ? _value.ip
          // ignore: cast_nullable_to_non_nullable
          : ip as String?,
    );
  }
}

extension $AuditEntryOutCopyWith on AuditEntryOut {
  /// Returns a callable class that can be used as follows: `instanceOfAuditEntryOut.copyWith(...)` or like so:`instanceOfAuditEntryOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditEntryOutCWProxy get copyWith => _$AuditEntryOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryOut _$AuditEntryOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AuditEntryOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'at',
      'action',
      'entityType',
      'entityId',
      'before',
      'after',
      'reason',
      'ip',
    ],
  );
  final val = AuditEntryOut(
    id: $checkedConvert('id', (v) => v as String),
    at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
    staff: $checkedConvert(
      'staff',
      (v) =>
          v == null ? null : AuditStaffOut.fromJson(v as Map<String, dynamic>),
    ),
    action: $checkedConvert('action', (v) => v as String),
    entityType: $checkedConvert('entityType', (v) => v as String),
    entityId: $checkedConvert('entityId', (v) => v as String),
    before: $checkedConvert(
      'before',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
    after: $checkedConvert(
      'after',
      (v) =>
          (v as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as Object)),
    ),
    reason: $checkedConvert('reason', (v) => v as String),
    ip: $checkedConvert('ip', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AuditEntryOutToJson(AuditEntryOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'at': instance.at.toIso8601String(),
      'staff': ?instance.staff?.toJson(),
      'action': instance.action,
      'entityType': instance.entityType,
      'entityId': instance.entityId,
      'before': instance.before,
      'after': instance.after,
      'reason': instance.reason,
      'ip': instance.ip,
    };
