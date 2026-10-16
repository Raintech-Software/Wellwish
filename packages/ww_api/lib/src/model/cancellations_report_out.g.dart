// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellations_report_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancellationsReportOutCWProxy {
  CancellationsReportOut start(DateTime start);

  CancellationsReportOut end(DateTime end);

  CancellationsReportOut rows(List<CancellationRowOut> rows);

  CancellationsReportOut cancelled(int cancelled);

  CancellationsReportOut refundedPaise(int refundedPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationsReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationsReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationsReportOut call({
    DateTime start,
    DateTime end,
    List<CancellationRowOut> rows,
    int cancelled,
    int refundedPaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancellationsReportOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancellationsReportOut.copyWith.fieldName(...)`
class _$CancellationsReportOutCWProxyImpl
    implements _$CancellationsReportOutCWProxy {
  const _$CancellationsReportOutCWProxyImpl(this._value);

  final CancellationsReportOut _value;

  @override
  CancellationsReportOut start(DateTime start) => this(start: start);

  @override
  CancellationsReportOut end(DateTime end) => this(end: end);

  @override
  CancellationsReportOut rows(List<CancellationRowOut> rows) =>
      this(rows: rows);

  @override
  CancellationsReportOut cancelled(int cancelled) => this(cancelled: cancelled);

  @override
  CancellationsReportOut refundedPaise(int refundedPaise) =>
      this(refundedPaise: refundedPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancellationsReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancellationsReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CancellationsReportOut call({
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? rows = const $CopyWithPlaceholder(),
    Object? cancelled = const $CopyWithPlaceholder(),
    Object? refundedPaise = const $CopyWithPlaceholder(),
  }) {
    return CancellationsReportOut(
      start: start == const $CopyWithPlaceholder()
          ? _value.start
          // ignore: cast_nullable_to_non_nullable
          : start as DateTime,
      end: end == const $CopyWithPlaceholder()
          ? _value.end
          // ignore: cast_nullable_to_non_nullable
          : end as DateTime,
      rows: rows == const $CopyWithPlaceholder()
          ? _value.rows
          // ignore: cast_nullable_to_non_nullable
          : rows as List<CancellationRowOut>,
      cancelled: cancelled == const $CopyWithPlaceholder()
          ? _value.cancelled
          // ignore: cast_nullable_to_non_nullable
          : cancelled as int,
      refundedPaise: refundedPaise == const $CopyWithPlaceholder()
          ? _value.refundedPaise
          // ignore: cast_nullable_to_non_nullable
          : refundedPaise as int,
    );
  }
}

extension $CancellationsReportOutCopyWith on CancellationsReportOut {
  /// Returns a callable class that can be used as follows: `instanceOfCancellationsReportOut.copyWith(...)` or like so:`instanceOfCancellationsReportOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancellationsReportOutCWProxy get copyWith =>
      _$CancellationsReportOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancellationsReportOut _$CancellationsReportOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('CancellationsReportOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['start', 'end', 'rows', 'cancelled', 'refundedPaise'],
  );
  final val = CancellationsReportOut(
    start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
    end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
    rows: $checkedConvert(
      'rows',
      (v) => (v as List<dynamic>)
          .map((e) => CancellationRowOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    cancelled: $checkedConvert('cancelled', (v) => (v as num).toInt()),
    refundedPaise: $checkedConvert('refundedPaise', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$CancellationsReportOutToJson(
  CancellationsReportOut instance,
) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'rows': instance.rows.map((e) => e.toJson()).toList(),
  'cancelled': instance.cancelled,
  'refundedPaise': instance.refundedPaise,
};
