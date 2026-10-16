// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_timeline_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingTimelineOutCWProxy {
  BookingTimelineOut status(String status);

  BookingTimelineOut event(String event);

  BookingTimelineOut step(String? step);

  BookingTimelineOut at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingTimelineOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingTimelineOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingTimelineOut call({
    String status,
    String event,
    String? step,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingTimelineOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingTimelineOut.copyWith.fieldName(...)`
class _$BookingTimelineOutCWProxyImpl implements _$BookingTimelineOutCWProxy {
  const _$BookingTimelineOutCWProxyImpl(this._value);

  final BookingTimelineOut _value;

  @override
  BookingTimelineOut status(String status) => this(status: status);

  @override
  BookingTimelineOut event(String event) => this(event: event);

  @override
  BookingTimelineOut step(String? step) => this(step: step);

  @override
  BookingTimelineOut at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingTimelineOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingTimelineOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingTimelineOut call({
    Object? status = const $CopyWithPlaceholder(),
    Object? event = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return BookingTimelineOut(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      event: event == const $CopyWithPlaceholder()
          ? _value.event
          // ignore: cast_nullable_to_non_nullable
          : event as String,
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as String?,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $BookingTimelineOutCopyWith on BookingTimelineOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingTimelineOut.copyWith(...)` or like so:`instanceOfBookingTimelineOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingTimelineOutCWProxy get copyWith =>
      _$BookingTimelineOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingTimelineOut _$BookingTimelineOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingTimelineOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['status', 'event', 'at']);
      final val = BookingTimelineOut(
        status: $checkedConvert('status', (v) => v as String),
        event: $checkedConvert('event', (v) => v as String),
        step: $checkedConvert('step', (v) => v as String? ?? ''),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$BookingTimelineOutToJson(BookingTimelineOut instance) =>
    <String, dynamic>{
      'status': instance.status,
      'event': instance.event,
      'step': ?instance.step,
      'at': instance.at.toIso8601String(),
    };
