// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_decision_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RefundDecisionInCWProxy {
  RefundDecisionIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefundDecisionIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefundDecisionIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RefundDecisionIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRefundDecisionIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRefundDecisionIn.copyWith.fieldName(...)`
class _$RefundDecisionInCWProxyImpl implements _$RefundDecisionInCWProxy {
  const _$RefundDecisionInCWProxyImpl(this._value);

  final RefundDecisionIn _value;

  @override
  RefundDecisionIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefundDecisionIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefundDecisionIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RefundDecisionIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return RefundDecisionIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $RefundDecisionInCopyWith on RefundDecisionIn {
  /// Returns a callable class that can be used as follows: `instanceOfRefundDecisionIn.copyWith(...)` or like so:`instanceOfRefundDecisionIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RefundDecisionInCWProxy get copyWith => _$RefundDecisionInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundDecisionIn _$RefundDecisionInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RefundDecisionIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = RefundDecisionIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RefundDecisionInToJson(RefundDecisionIn instance) =>
    <String, dynamic>{'reason': instance.reason};
