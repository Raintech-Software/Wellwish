// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_fees_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodayFeesOutCWProxy {
  TodayFeesOut payments(int payments);

  TodayFeesOut collectedPaise(int collectedPaise);

  TodayFeesOut refundedPaise(int refundedPaise);

  TodayFeesOut monthCollectedPaise(int monthCollectedPaise);

  TodayFeesOut monthNetPaise(int monthNetPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayFeesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayFeesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayFeesOut call({
    int payments,
    int collectedPaise,
    int refundedPaise,
    int monthCollectedPaise,
    int monthNetPaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodayFeesOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodayFeesOut.copyWith.fieldName(...)`
class _$TodayFeesOutCWProxyImpl implements _$TodayFeesOutCWProxy {
  const _$TodayFeesOutCWProxyImpl(this._value);

  final TodayFeesOut _value;

  @override
  TodayFeesOut payments(int payments) => this(payments: payments);

  @override
  TodayFeesOut collectedPaise(int collectedPaise) =>
      this(collectedPaise: collectedPaise);

  @override
  TodayFeesOut refundedPaise(int refundedPaise) =>
      this(refundedPaise: refundedPaise);

  @override
  TodayFeesOut monthCollectedPaise(int monthCollectedPaise) =>
      this(monthCollectedPaise: monthCollectedPaise);

  @override
  TodayFeesOut monthNetPaise(int monthNetPaise) =>
      this(monthNetPaise: monthNetPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayFeesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayFeesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayFeesOut call({
    Object? payments = const $CopyWithPlaceholder(),
    Object? collectedPaise = const $CopyWithPlaceholder(),
    Object? refundedPaise = const $CopyWithPlaceholder(),
    Object? monthCollectedPaise = const $CopyWithPlaceholder(),
    Object? monthNetPaise = const $CopyWithPlaceholder(),
  }) {
    return TodayFeesOut(
      payments: payments == const $CopyWithPlaceholder()
          ? _value.payments
          // ignore: cast_nullable_to_non_nullable
          : payments as int,
      collectedPaise: collectedPaise == const $CopyWithPlaceholder()
          ? _value.collectedPaise
          // ignore: cast_nullable_to_non_nullable
          : collectedPaise as int,
      refundedPaise: refundedPaise == const $CopyWithPlaceholder()
          ? _value.refundedPaise
          // ignore: cast_nullable_to_non_nullable
          : refundedPaise as int,
      monthCollectedPaise: monthCollectedPaise == const $CopyWithPlaceholder()
          ? _value.monthCollectedPaise
          // ignore: cast_nullable_to_non_nullable
          : monthCollectedPaise as int,
      monthNetPaise: monthNetPaise == const $CopyWithPlaceholder()
          ? _value.monthNetPaise
          // ignore: cast_nullable_to_non_nullable
          : monthNetPaise as int,
    );
  }
}

extension $TodayFeesOutCopyWith on TodayFeesOut {
  /// Returns a callable class that can be used as follows: `instanceOfTodayFeesOut.copyWith(...)` or like so:`instanceOfTodayFeesOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodayFeesOutCWProxy get copyWith => _$TodayFeesOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayFeesOut _$TodayFeesOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TodayFeesOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'payments',
      'collectedPaise',
      'refundedPaise',
      'monthCollectedPaise',
      'monthNetPaise',
    ],
  );
  final val = TodayFeesOut(
    payments: $checkedConvert('payments', (v) => (v as num).toInt()),
    collectedPaise: $checkedConvert(
      'collectedPaise',
      (v) => (v as num).toInt(),
    ),
    refundedPaise: $checkedConvert('refundedPaise', (v) => (v as num).toInt()),
    monthCollectedPaise: $checkedConvert(
      'monthCollectedPaise',
      (v) => (v as num).toInt(),
    ),
    monthNetPaise: $checkedConvert('monthNetPaise', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$TodayFeesOutToJson(TodayFeesOut instance) =>
    <String, dynamic>{
      'payments': instance.payments,
      'collectedPaise': instance.collectedPaise,
      'refundedPaise': instance.refundedPaise,
      'monthCollectedPaise': instance.monthCollectedPaise,
      'monthNetPaise': instance.monthNetPaise,
    };
