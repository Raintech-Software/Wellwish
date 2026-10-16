// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminCancelInCWProxy {
  AdminCancelIn reason(String reason);

  AdminCancelIn refundPercent(int refundPercent);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCancelIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCancelIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCancelIn call({String reason, int refundPercent});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminCancelIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminCancelIn.copyWith.fieldName(...)`
class _$AdminCancelInCWProxyImpl implements _$AdminCancelInCWProxy {
  const _$AdminCancelInCWProxyImpl(this._value);

  final AdminCancelIn _value;

  @override
  AdminCancelIn reason(String reason) => this(reason: reason);

  @override
  AdminCancelIn refundPercent(int refundPercent) =>
      this(refundPercent: refundPercent);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminCancelIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminCancelIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminCancelIn call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? refundPercent = const $CopyWithPlaceholder(),
  }) {
    return AdminCancelIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      refundPercent: refundPercent == const $CopyWithPlaceholder()
          ? _value.refundPercent
          // ignore: cast_nullable_to_non_nullable
          : refundPercent as int,
    );
  }
}

extension $AdminCancelInCopyWith on AdminCancelIn {
  /// Returns a callable class that can be used as follows: `instanceOfAdminCancelIn.copyWith(...)` or like so:`instanceOfAdminCancelIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminCancelInCWProxy get copyWith => _$AdminCancelInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCancelIn _$AdminCancelInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminCancelIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason', 'refundPercent']);
      final val = AdminCancelIn(
        reason: $checkedConvert('reason', (v) => v as String),
        refundPercent: $checkedConvert(
          'refundPercent',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminCancelInToJson(AdminCancelIn instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'refundPercent': instance.refundPercent,
    };
