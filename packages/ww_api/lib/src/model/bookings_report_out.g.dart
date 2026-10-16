// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_report_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingsReportOutCWProxy {
  BookingsReportOut start(DateTime start);

  BookingsReportOut end(DateTime end);

  BookingsReportOut days(List<BookingsReportRowOut> days);

  BookingsReportOut services(List<BookingsByServiceOut> services);

  BookingsReportOut total(BookingsReportRowOut total);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsReportOut call({
    DateTime start,
    DateTime end,
    List<BookingsReportRowOut> days,
    List<BookingsByServiceOut> services,
    BookingsReportRowOut total,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingsReportOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingsReportOut.copyWith.fieldName(...)`
class _$BookingsReportOutCWProxyImpl implements _$BookingsReportOutCWProxy {
  const _$BookingsReportOutCWProxyImpl(this._value);

  final BookingsReportOut _value;

  @override
  BookingsReportOut start(DateTime start) => this(start: start);

  @override
  BookingsReportOut end(DateTime end) => this(end: end);

  @override
  BookingsReportOut days(List<BookingsReportRowOut> days) => this(days: days);

  @override
  BookingsReportOut services(List<BookingsByServiceOut> services) =>
      this(services: services);

  @override
  BookingsReportOut total(BookingsReportRowOut total) => this(total: total);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsReportOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsReportOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsReportOut call({
    Object? start = const $CopyWithPlaceholder(),
    Object? end = const $CopyWithPlaceholder(),
    Object? days = const $CopyWithPlaceholder(),
    Object? services = const $CopyWithPlaceholder(),
    Object? total = const $CopyWithPlaceholder(),
  }) {
    return BookingsReportOut(
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
          : days as List<BookingsReportRowOut>,
      services: services == const $CopyWithPlaceholder()
          ? _value.services
          // ignore: cast_nullable_to_non_nullable
          : services as List<BookingsByServiceOut>,
      total: total == const $CopyWithPlaceholder()
          ? _value.total
          // ignore: cast_nullable_to_non_nullable
          : total as BookingsReportRowOut,
    );
  }
}

extension $BookingsReportOutCopyWith on BookingsReportOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingsReportOut.copyWith(...)` or like so:`instanceOfBookingsReportOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingsReportOutCWProxy get copyWith =>
      _$BookingsReportOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsReportOut _$BookingsReportOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookingsReportOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['start', 'end', 'days', 'services', 'total'],
  );
  final val = BookingsReportOut(
    start: $checkedConvert('start', (v) => DateTime.parse(v as String)),
    end: $checkedConvert('end', (v) => DateTime.parse(v as String)),
    days: $checkedConvert(
      'days',
      (v) => (v as List<dynamic>)
          .map((e) => BookingsReportRowOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    services: $checkedConvert(
      'services',
      (v) => (v as List<dynamic>)
          .map((e) => BookingsByServiceOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    total: $checkedConvert(
      'total',
      (v) => BookingsReportRowOut.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$BookingsReportOutToJson(BookingsReportOut instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'days': instance.days.map((e) => e.toJson()).toList(),
      'services': instance.services.map((e) => e.toJson()).toList(),
      'total': instance.total.toJson(),
    };
