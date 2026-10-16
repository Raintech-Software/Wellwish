// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_by_service_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingsByServiceOutCWProxy {
  BookingsByServiceOut service(String service);

  BookingsByServiceOut booked(int booked);

  BookingsByServiceOut completed(int completed);

  BookingsByServiceOut cancelled(int cancelled);

  BookingsByServiceOut noShow(int noShow);

  BookingsByServiceOut open(int open);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsByServiceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsByServiceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsByServiceOut call({
    String service,
    int booked,
    int completed,
    int cancelled,
    int noShow,
    int open,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingsByServiceOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingsByServiceOut.copyWith.fieldName(...)`
class _$BookingsByServiceOutCWProxyImpl
    implements _$BookingsByServiceOutCWProxy {
  const _$BookingsByServiceOutCWProxyImpl(this._value);

  final BookingsByServiceOut _value;

  @override
  BookingsByServiceOut service(String service) => this(service: service);

  @override
  BookingsByServiceOut booked(int booked) => this(booked: booked);

  @override
  BookingsByServiceOut completed(int completed) => this(completed: completed);

  @override
  BookingsByServiceOut cancelled(int cancelled) => this(cancelled: cancelled);

  @override
  BookingsByServiceOut noShow(int noShow) => this(noShow: noShow);

  @override
  BookingsByServiceOut open(int open) => this(open: open);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingsByServiceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingsByServiceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingsByServiceOut call({
    Object? service = const $CopyWithPlaceholder(),
    Object? booked = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
    Object? cancelled = const $CopyWithPlaceholder(),
    Object? noShow = const $CopyWithPlaceholder(),
    Object? open = const $CopyWithPlaceholder(),
  }) {
    return BookingsByServiceOut(
      service: service == const $CopyWithPlaceholder()
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as String,
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

extension $BookingsByServiceOutCopyWith on BookingsByServiceOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingsByServiceOut.copyWith(...)` or like so:`instanceOfBookingsByServiceOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingsByServiceOutCWProxy get copyWith =>
      _$BookingsByServiceOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsByServiceOut _$BookingsByServiceOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookingsByServiceOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'service',
      'booked',
      'completed',
      'cancelled',
      'noShow',
      'open',
    ],
  );
  final val = BookingsByServiceOut(
    service: $checkedConvert('service', (v) => v as String),
    booked: $checkedConvert('booked', (v) => (v as num).toInt()),
    completed: $checkedConvert('completed', (v) => (v as num).toInt()),
    cancelled: $checkedConvert('cancelled', (v) => (v as num).toInt()),
    noShow: $checkedConvert('noShow', (v) => (v as num).toInt()),
    open: $checkedConvert('open', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$BookingsByServiceOutToJson(
  BookingsByServiceOut instance,
) => <String, dynamic>{
  'service': instance.service,
  'booked': instance.booked,
  'completed': instance.completed,
  'cancelled': instance.cancelled,
  'noShow': instance.noShow,
  'open': instance.open,
};
