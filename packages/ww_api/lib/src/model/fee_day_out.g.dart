// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_day_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeeDayOutCWProxy {
  FeeDayOut date(DateTime? date);

  FeeDayOut payments(int payments);

  FeeDayOut collectedPaise(int collectedPaise);

  FeeDayOut refundedPaise(int refundedPaise);

  FeeDayOut netPaise(int netPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeeDayOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeeDayOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FeeDayOut call({
    DateTime? date,
    int payments,
    int collectedPaise,
    int refundedPaise,
    int netPaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeeDayOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeeDayOut.copyWith.fieldName(...)`
class _$FeeDayOutCWProxyImpl implements _$FeeDayOutCWProxy {
  const _$FeeDayOutCWProxyImpl(this._value);

  final FeeDayOut _value;

  @override
  FeeDayOut date(DateTime? date) => this(date: date);

  @override
  FeeDayOut payments(int payments) => this(payments: payments);

  @override
  FeeDayOut collectedPaise(int collectedPaise) =>
      this(collectedPaise: collectedPaise);

  @override
  FeeDayOut refundedPaise(int refundedPaise) =>
      this(refundedPaise: refundedPaise);

  @override
  FeeDayOut netPaise(int netPaise) => this(netPaise: netPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeeDayOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeeDayOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FeeDayOut call({
    Object? date = const $CopyWithPlaceholder(),
    Object? payments = const $CopyWithPlaceholder(),
    Object? collectedPaise = const $CopyWithPlaceholder(),
    Object? refundedPaise = const $CopyWithPlaceholder(),
    Object? netPaise = const $CopyWithPlaceholder(),
  }) {
    return FeeDayOut(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime?,
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
      netPaise: netPaise == const $CopyWithPlaceholder()
          ? _value.netPaise
          // ignore: cast_nullable_to_non_nullable
          : netPaise as int,
    );
  }
}

extension $FeeDayOutCopyWith on FeeDayOut {
  /// Returns a callable class that can be used as follows: `instanceOfFeeDayOut.copyWith(...)` or like so:`instanceOfFeeDayOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeeDayOutCWProxy get copyWith => _$FeeDayOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeeDayOut _$FeeDayOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FeeDayOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'payments',
          'collectedPaise',
          'refundedPaise',
          'netPaise',
        ],
      );
      final val = FeeDayOut(
        date: $checkedConvert(
          'date',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        payments: $checkedConvert('payments', (v) => (v as num).toInt()),
        collectedPaise: $checkedConvert(
          'collectedPaise',
          (v) => (v as num).toInt(),
        ),
        refundedPaise: $checkedConvert(
          'refundedPaise',
          (v) => (v as num).toInt(),
        ),
        netPaise: $checkedConvert('netPaise', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$FeeDayOutToJson(FeeDayOut instance) => <String, dynamic>{
  'date': ?instance.date?.toIso8601String(),
  'payments': instance.payments,
  'collectedPaise': instance.collectedPaise,
  'refundedPaise': instance.refundedPaise,
  'netPaise': instance.netPaise,
};
