// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sum_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BalanceSumOutCWProxy {
  BalanceSumOut cashPaise(int cashPaise);

  BalanceSumOut upiPaise(int upiPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalanceSumOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalanceSumOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BalanceSumOut call({int cashPaise, int upiPaise});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBalanceSumOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBalanceSumOut.copyWith.fieldName(...)`
class _$BalanceSumOutCWProxyImpl implements _$BalanceSumOutCWProxy {
  const _$BalanceSumOutCWProxyImpl(this._value);

  final BalanceSumOut _value;

  @override
  BalanceSumOut cashPaise(int cashPaise) => this(cashPaise: cashPaise);

  @override
  BalanceSumOut upiPaise(int upiPaise) => this(upiPaise: upiPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalanceSumOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalanceSumOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BalanceSumOut call({
    Object? cashPaise = const $CopyWithPlaceholder(),
    Object? upiPaise = const $CopyWithPlaceholder(),
  }) {
    return BalanceSumOut(
      cashPaise: cashPaise == const $CopyWithPlaceholder()
          ? _value.cashPaise
          // ignore: cast_nullable_to_non_nullable
          : cashPaise as int,
      upiPaise: upiPaise == const $CopyWithPlaceholder()
          ? _value.upiPaise
          // ignore: cast_nullable_to_non_nullable
          : upiPaise as int,
    );
  }
}

extension $BalanceSumOutCopyWith on BalanceSumOut {
  /// Returns a callable class that can be used as follows: `instanceOfBalanceSumOut.copyWith(...)` or like so:`instanceOfBalanceSumOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BalanceSumOutCWProxy get copyWith => _$BalanceSumOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceSumOut _$BalanceSumOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BalanceSumOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['cashPaise', 'upiPaise']);
      final val = BalanceSumOut(
        cashPaise: $checkedConvert('cashPaise', (v) => (v as num).toInt()),
        upiPaise: $checkedConvert('upiPaise', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$BalanceSumOutToJson(BalanceSumOut instance) =>
    <String, dynamic>{
      'cashPaise': instance.cashPaise,
      'upiPaise': instance.upiPaise,
    };
