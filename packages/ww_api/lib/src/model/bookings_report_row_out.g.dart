// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_report_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingsReportRowOutCWProxy {
  BookingsReportRowOut date(DateTime? date);

  BookingsReportRowOut booked(int booked);

  BookingsReportRowOut completed(int completed);

  BookingsReportRowOut cancelled(int cancelled);

  BookingsReportRowOut noShow(int noShow);

  BookingsReportRowOut open(int open);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsReportRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsReportRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsReportRowOut call({
    DateTime? date,
    int booked,
    int completed,
    int cancelled,
    int noShow,
    int open,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingsReportRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingsReportRowOut.copyWith.fieldName(...)`
class _$BookingsReportRowOutCWProxyImpl
    implements _$BookingsReportRowOutCWProxy {
  const _$BookingsReportRowOutCWProxyImpl(this._value);

  final BookingsReportRowOut _value;

  @override
  BookingsReportRowOut date(DateTime? date) => this(date: date);

  @override
  BookingsReportRowOut booked(int booked) => this(booked: booked);

  @override
  BookingsReportRowOut completed(int completed) => this(completed: completed);

  @override
  BookingsReportRowOut cancelled(int cancelled) => this(cancelled: cancelled);

  @override
  BookingsReportRowOut noShow(int noShow) => this(noShow: noShow);

  @override
  BookingsReportRowOut open(int open) => this(open: open);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsReportRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsReportRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsReportRowOut call({
    Object? date = const $CopyWithPlaceholder(),
    Object? booked = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
    Object? cancelled = const $CopyWithPlaceholder(),
    Object? noShow = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
  }) {
    return BookingsReportRowOut(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime?,
      booked: booked == const $CopyWithPlaceholder()
          ? _value.booked
          // ignore: cast_nullable_to_non_nullable
          : booked as int,
      completed: completed == const $CopyWithPlaceholder()
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as int,
      cancelled: cancelled == const $CopyWithPlaceholder()
          ? _value.cancelled
          // ignore: cast_nullable_to_non_nullable
          : cancelled as int,
      noShow: noShow == const $CopyWithPlaceholder()
          ? _value.noShow
          // ignore: cast_nullable_to_non_nullable
          : noShow as int,
      open: open == const $CopyWithPlaceholder()
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as int,
    );
  }
}

extension $BookingsReportRowOutCopyWith on BookingsReportRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingsReportRowOut.copyWith(...)` or like so:`instanceOfBookingsReportRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingsReportRowOutCWProxy get copyWith =>
      _$BookingsReportRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsReportRowOut _$BookingsReportRowOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookingsReportRowOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['booked', 'completed', 'cancelled', 'noShow', 'open'],
  );
  final val = BookingsReportRowOut(
    date: $checkedConvert(
      'date',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    booked: $checkedConvert('booked', (v) => (v as num).toInt()),
    completed: $checkedConvert('completed', (v) => (v as num).toInt()),
    cancelled: $checkedConvert('cancelled', (v) => (v as num).toInt()),
    noShow: $checkedConvert('noShow', (v) => (v as num).toInt()),
    open: $checkedConvert('open', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$BookingsReportRowOutToJson(
  BookingsReportRowOut instance,
) => <String, dynamic>{
  'date': ?instance.date?.toIso8601String(),
  'booked': instance.booked,
  'completed': instance.completed,
  'cancelled': instance.cancelled,
  'noShow': instance.noShow,
  'open': instance.open,
};
