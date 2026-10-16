// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_staff_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditStaffOutCWProxy {
  AuditStaffOut id(String id);

  AuditStaffOut name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditStaffOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditStaffOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditStaffOut call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditStaffOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditStaffOut.copyWith.fieldName(...)`
class _$AuditStaffOutCWProxyImpl implements _$AuditStaffOutCWProxy {
  const _$AuditStaffOutCWProxyImpl(this._value);

  final AuditStaffOut _value;

  @override
  AuditStaffOut id(String id) => this(id: id);

  @override
  AuditStaffOut name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditStaffOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditStaffOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditStaffOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return AuditStaffOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $AuditStaffOutCopyWith on AuditStaffOut {
  /// Returns a callable class that can be used as follows: `instanceOfAuditStaffOut.copyWith(...)` or like so:`instanceOfAuditStaffOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditStaffOutCWProxy get copyWith => _$AuditStaffOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditStaffOut _$AuditStaffOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditStaffOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = AuditStaffOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AuditStaffOutToJson(AuditStaffOut instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
