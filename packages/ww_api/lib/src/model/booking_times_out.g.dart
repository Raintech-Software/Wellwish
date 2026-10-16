// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_times_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingTimesOutCWProxy {
  BookingTimesOut date(DateTime date);

  BookingTimesOut times(List<DateTime> times);

  BookingTimesOut days(List<BookingDayOut> days);

  BookingTimesOut timeStepMin(int timeStepMin);

  BookingTimesOut travelBufferMin(int travelBufferMin);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingTimesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingTimesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingTimesOut call({
    DateTime date,
    List<DateTime> times,
    List<BookingDayOut> days,
    int timeStepMin,
    int travelBufferMin,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingTimesOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingTimesOut.copyWith.fieldName(...)`
class _$BookingTimesOutCWProxyImpl implements _$BookingTimesOutCWProxy {
  const _$BookingTimesOutCWProxyImpl(this._value);

  final BookingTimesOut _value;

  @override
  BookingTimesOut date(DateTime date) => this(date: date);

  @override
  BookingTimesOut times(List<DateTime> times) => this(times: times);

  @override
  BookingTimesOut days(List<BookingDayOut> days) => this(days: days);

  @override
  BookingTimesOut timeStepMin(int timeStepMin) =>
      this(timeStepMin: timeStepMin);

  @override
  BookingTimesOut travelBufferMin(int travelBufferMin) =>
      this(travelBufferMin: travelBufferMin);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingTimesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingTimesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingTimesOut call({
    Object? date = const $CopyWithPlaceholder(),
    Object? times = const $CopyWithPlaceholder(),
    Object? days = const $CopyWithPlaceholder(),
    Object? timeStepMin = const $CopyWithPlaceholder(),
    Object? travelBufferMin = const $CopyWithPlaceholder(),
  }) {
    return BookingTimesOut(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      times: times == const $CopyWithPlaceholder()
          ? _value.times
          // ignore: cast_nullable_to_non_nullable
          : times as List<DateTime>,
      days: days == const $CopyWithPlaceholder()
          ? _value.days
          // ignore: cast_nullable_to_non_nullable
          : days as List<BookingDayOut>,
      timeStepMin: timeStepMin == const $CopyWithPlaceholder()
          ? _value.timeStepMin
          // ignore: cast_nullable_to_non_nullable
          : timeStepMin as int,
      travelBufferMin: travelBufferMin == const $CopyWithPlaceholder()
          ? _value.travelBufferMin
          // ignore: cast_nullable_to_non_nullable
          : travelBufferMin as int,
    );
  }
}

extension $BookingTimesOutCopyWith on BookingTimesOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingTimesOut.copyWith(...)` or like so:`instanceOfBookingTimesOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingTimesOutCWProxy get copyWith => _$BookingTimesOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingTimesOut _$BookingTimesOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingTimesOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'date',
          'times',
          'days',
          'timeStepMin',
          'travelBufferMin',
        ],
      );
      final val = BookingTimesOut(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        times: $checkedConvert(
          'times',
          (v) => (v as List<dynamic>)
              .map((e) => DateTime.parse(e as String))
              .toList(),
        ),
        days: $checkedConvert(
          'days',
          (v) => (v as List<dynamic>)
              .map((e) => BookingDayOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        timeStepMin: $checkedConvert('timeStepMin', (v) => (v as num).toInt()),
        travelBufferMin: $checkedConvert(
          'travelBufferMin',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BookingTimesOutToJson(BookingTimesOut instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'times': instance.times.map((e) => e.toIso8601String()).toList(),
      'days': instance.days.map((e) => e.toJson()).toList(),
      'timeStepMin': instance.timeStepMin,
      'travelBufferMin': instance.travelBufferMin,
    };
