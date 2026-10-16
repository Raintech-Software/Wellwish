// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_day_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingDayOutCWProxy {
  BookingDayOut date(DateTime date);

  BookingDayOut available(bool available);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDayOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDayOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDayOut call({DateTime date, bool available});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingDayOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingDayOut.copyWith.fieldName(...)`
class _$BookingDayOutCWProxyImpl implements _$BookingDayOutCWProxy {
  const _$BookingDayOutCWProxyImpl(this._value);

  final BookingDayOut _value;

  @override
  BookingDayOut date(DateTime date) => this(date: date);

  @override
  BookingDayOut available(bool available) => this(available: available);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDayOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDayOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDayOut call({
    Object? date = const $CopyWithPlaceholder(),
    Object? available = const $CopyWithPlaceholder(),
  }) {
    return BookingDayOut(
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime,
      available: available == const $CopyWithPlaceholder()
          ? _value.available
          // ignore: cast_nullable_to_non_nullable
          : available as bool,
    );
  }
}

extension $BookingDayOutCopyWith on BookingDayOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingDayOut.copyWith(...)` or like so:`instanceOfBookingDayOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingDayOutCWProxy get copyWith => _$BookingDayOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDayOut _$BookingDayOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingDayOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['date', 'available']);
      final val = BookingDayOut(
        date: $checkedConvert('date', (v) => DateTime.parse(v as String)),
        available: $checkedConvert('available', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$BookingDayOutToJson(BookingDayOut instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'available': instance.available,
    };
