// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_performance_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerPerformanceOutCWProxy {
  PartnerPerformanceOut start(DateTime start);

  PartnerPerformanceOut end(DateTime end);

  PartnerPerformanceOut rows(List<PartnerPerformanceRowOut> rows);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerPerformanceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerPerformanceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerPerformanceOut call({
    DateTime start,
    DateTime end,
    List<PartnerPerformanceRowOut> rows,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerPerformanceOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerPerformanceOut.copyWith.fieldName(...)`
class _$PartnerPerformanceOutCWProxyImpl
    implements _$PartnerPerformanceOutCWProxy {
  const _$PartnerPerformanceOutCWProxyImpl(this._value);

  final PartnerPerformanceOut _value;

  @override
  PartnerPerformanceOut start(DateTime start) => this(start: start);

  @override
  PartnerPerformanceOut end(DateTime end) => this(end: end);

  @override
  PartnerPerformanceOut rows(List<PartnerPerformanceRowOut> rows) =>
      this(rows: rows);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerPerformanceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerPerformanceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerPerformanceOut call({
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? rows = const $CopyWithPlaceholder(),
  }) {
    return PartnerPerformanceOut(
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
          : rows as List<PartnerPerformanceRowOut>,
    );
  }
}

extension $PartnerPerformanceOutCopyWith on PartnerPerformanceOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerPerformanceOut.copyWith(...)` or like so:`instanceOfPartnerPerformanceOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerPerformanceOutCWProxy get copyWith =>
      _$PartnerPerformanceOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerPerformanceOut _$PartnerPerformanceOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PartnerPerformanceOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['start', 'end', 'rows']);
  final val = PartnerPerformanceOut(
    start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
    end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
    rows: $checkedConvert(
      'rows',
      (v) => (v as List<dynamic>)
          .map(
            (e) => PartnerPerformanceRowOut.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$PartnerPerformanceOutToJson(
  PartnerPerformanceOut instance,
) => <String, dynamic>{
  'start': instance.start.toIso8601String(),
  'end': instance.end.toIso8601String(),
  'rows': instance.rows.map((e) => e.toJson()).toList(),
};
