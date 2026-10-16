// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_report_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FeeReportOutCWProxy {
  FeeReportOut start(DateTime start);

  FeeReportOut end(DateTime end);

  FeeReportOut days(List<FeeDayOut> days);

  FeeReportOut total(FeeDayOut total);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeeReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeeReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FeeReportOut call({
    DateTime start,
    DateTime end,
    List<FeeDayOut> days,
    FeeDayOut total,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFeeReportOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFeeReportOut.copyWith.fieldName(...)`
class _$FeeReportOutCWProxyImpl implements _$FeeReportOutCWProxy {
  const _$FeeReportOutCWProxyImpl(this._value);

  final FeeReportOut _value;

  @override
  FeeReportOut start(DateTime start) => this(start: start);

  @override
  FeeReportOut end(DateTime end) => this(end: end);

  @override
  FeeReportOut days(List<FeeDayOut> days) => this(days: days);

  @override
  FeeReportOut total(FeeDayOut total) => this(total: total);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FeeReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FeeReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FeeReportOut call({
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? days = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
  }) {
    return FeeReportOut(
      start: start == const $CopyWithPlaceholder()
          ? _value.start
          // ignore: cast_nullable_to_non_nullable
          : start as DateTime,
      end: end == const $CopyWithPlaceholder()
          ? _value.end
          // ignore: cast_nullable_to_non_nullable
          : end as DateTime,
      days: days == const $CopyWithPlaceholder()
          ? _value.days
          // ignore: cast_nullable_to_non_nullable
          : days as List<FeeDayOut>,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as FeeDayOut,
    );
  }
}

extension $FeeReportOutCopyWith on FeeReportOut {
  /// Returns a callable class that can be used as follows: `instanceOfFeeReportOut.copyWith(...)` or like so:`instanceOfFeeReportOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FeeReportOutCWProxy get copyWith => _$FeeReportOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeeReportOut _$FeeReportOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FeeReportOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['start', 'end', 'days', 'total']);
      final val = FeeReportOut(
        start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
        end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
        days: $checkedConvert(
          'days',
          (v) => (v as List<dynamic>)
              .map((e) => FeeDayOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        total: $checkedConvert(
          'total',
          (v) => FeeDayOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$FeeReportOutToJson(FeeReportOut instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'days': instance.days.map((e) => e.toJson()).toList(),
      'total': instance.total.toJson(),
    };
