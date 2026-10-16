// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_filters_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AuditFiltersOutCWProxy {
  AuditFiltersOut actions(List<String> actions);

  AuditFiltersOut entityTypes(List<String> entityTypes);

  AuditFiltersOut staff(List<AuditStaffOut> staff);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditFiltersOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditFiltersOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditFiltersOut call({
    List<String> actions,
    List<String> entityTypes,
    List<AuditStaffOut> staff,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAuditFiltersOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAuditFiltersOut.copyWith.fieldName(...)`
class _$AuditFiltersOutCWProxyImpl implements _$AuditFiltersOutCWProxy {
  const _$AuditFiltersOutCWProxyImpl(this._value);

  final AuditFiltersOut _value;

  @override
  AuditFiltersOut actions(List<String> actions) => this(actions: actions);

  @override
  AuditFiltersOut entityTypes(List<String> entityTypes) =>
      this(entityTypes: entityTypes);

  @override
  AuditFiltersOut staff(List<AuditStaffOut> staff) => this(staff: staff);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AuditFiltersOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AuditFiltersOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AuditFiltersOut call({
    Object? actions = const $CopyWithPlaceholder(),
    Object? entityTypes = const $CopyWithPlaceholder(),
    Object? staff = const $CopyWithPlaceholder(),
  }) {
    return AuditFiltersOut(
      actions: actions == const $CopyWithPlaceholder()
          ? _value.actions
          // ignore: cast_nullable_to_non_nullable
          : actions as List<String>,
      entityTypes: entityTypes == const $CopyWithPlaceholder()
          ? _value.entityTypes
          // ignore: cast_nullable_to_non_nullable
          : entityTypes as List<String>,
      staff: staff == const $CopyWithPlaceholder()
          ? _value.staff
          // ignore: cast_nullable_to_non_nullable
          : staff as List<AuditStaffOut>,
    );
  }
}

extension $AuditFiltersOutCopyWith on AuditFiltersOut {
  /// Returns a callable class that can be used as follows: `instanceOfAuditFiltersOut.copyWith(...)` or like so:`instanceOfAuditFiltersOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AuditFiltersOutCWProxy get copyWith => _$AuditFiltersOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditFiltersOut _$AuditFiltersOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AuditFiltersOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['actions', 'entityTypes', 'staff']);
      final val = AuditFiltersOut(
        actions: $checkedConvert(
          'actions',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        entityTypes: $checkedConvert(
          'entityTypes',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        staff: $checkedConvert(
          'staff',
          (v) => (v as List<dynamic>)
              .map((e) => AuditStaffOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AuditFiltersOutToJson(AuditFiltersOut instance) =>
    <String, dynamic>{
      'actions': instance.actions,
      'entityTypes': instance.entityTypes,
      'staff': instance.staff.map((e) => e.toJson()).toList(),
    };
