// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_query.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditQueryCWProxy {
  AuditQuery staffId(String? staffId);

  AuditQuery action(String? action);

  AuditQuery entityType(String? entityType);

  AuditQuery entityId(String? entityId);

  AuditQuery from(DateTime? from);

  AuditQuery to(DateTime? to);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditQuery call({
    String? staffId,
    String? action,
    String? entityType,
    String? entityId,
    DateTime? from,
    DateTime? to,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditQuery.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditQuery.copyWith.fieldName(...)`
class _$AuditQueryCWProxyImpl implements _$AuditQueryCWProxy {
  const _$AuditQueryCWProxyImpl(this._value);

  final AuditQuery _value;

  @override
  AuditQuery staffId(String? staffId) => this(staffId: staffId);

  @override
  AuditQuery action(String? action) => this(action: action);

  @override
  AuditQuery entityType(String? entityType) => this(entityType: entityType);

  @override
  AuditQuery entityId(String? entityId) => this(entityId: entityId);

  @override
  AuditQuery from(DateTime? from) => this(from: from);

  @override
  AuditQuery to(DateTime? to) => this(to: to);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditQuery(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditQuery(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditQuery call({
    Object? staffId = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? entityType = const $CopyWithPlaceholder(),
    Object? entityId = const $CopyWithPlaceholder(),
    Object? from = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
  }) {
    return AuditQuery(
      staffId: staffId == const $CopyWithPlaceholder()
          ? _value.staffId
          // ignore: cast_nullable_to_non_nullable
          : staffId as String?,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String?,
      entityType: entityType == const $CopyWithPlaceholder()
          ? _value.entityType
          // ignore: cast_nullable_to_non_nullable
          : entityType as String?,
      entityId: entityId == const $CopyWithPlaceholder()
          ? _value.entityId
          // ignore: cast_nullable_to_non_nullable
          : entityId as String?,
      from: from == const $CopyWithPlaceholder()
          ? _value.from
          // ignore: cast_nullable_to_non_nullable
          : from as DateTime?,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as DateTime?,
    );
  }
}

extension $AuditQueryCopyWith on AuditQuery {
  /// Returns a callable class that can be used as follows: `instanceOfAuditQuery.copyWith(...)` or like so:`instanceOfAuditQuery.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditQueryCWProxy get copyWith => _$AuditQueryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditQuery _$AuditQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditQuery', json, ($checkedConvert) {
      final val = AuditQuery(
        staffId: $checkedConvert('staffId', (v) => v as String?),
        action: $checkedConvert('action', (v) => v as String? ?? ''),
        entityType: $checkedConvert('entityType', (v) => v as String? ?? ''),
        entityId: $checkedConvert('entityId', (v) => v as String? ?? ''),
        from: $checkedConvert(
          'from',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        to: $checkedConvert(
          'to',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuditQueryToJson(AuditQuery instance) =>
    <String, dynamic>{
      'staffId': ?instance.staffId,
      'action': ?instance.action,
      'entityType': ?instance.entityType,
      'entityId': ?instance.entityId,
      'from': ?instance.from?.toIso8601String(),
      'to': ?instance.to?.toIso8601String(),
    };
