// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_booking_event_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminBookingEventOutCWProxy {
  AdminBookingEventOut fromStatus(String fromStatus);

  AdminBookingEventOut status(String status);

  AdminBookingEventOut event(String event);

  AdminBookingEventOut step(String? step);

  AdminBookingEventOut actorType(String actorType);

  AdminBookingEventOut note(String note);

  AdminBookingEventOut at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingEventOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingEventOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingEventOut call({
    String fromStatus,
    String status,
    String event,
    String? step,
    String actorType,
    String note,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminBookingEventOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminBookingEventOut.copyWith.fieldName(...)`
class _$AdminBookingEventOutCWProxyImpl
    implements _$AdminBookingEventOutCWProxy {
  const _$AdminBookingEventOutCWProxyImpl(this._value);

  final AdminBookingEventOut _value;

  @override
  AdminBookingEventOut fromStatus(String fromStatus) =>
      this(fromStatus: fromStatus);

  @override
  AdminBookingEventOut status(String status) => this(status: status);

  @override
  AdminBookingEventOut event(String event) => this(event: event);

  @override
  AdminBookingEventOut step(String? step) => this(step: step);

  @override
  AdminBookingEventOut actorType(String actorType) =>
      this(actorType: actorType);

  @override
  AdminBookingEventOut note(String note) => this(note: note);

  @override
  AdminBookingEventOut at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingEventOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingEventOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingEventOut call({
    Object? fromStatus = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? event = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
    Object? actorType = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return AdminBookingEventOut(
      fromStatus: fromStatus == const $CopyWithPlaceholder()
          ? _value.fromStatus
          // ignore: cast_nullable_to_non_nullable
          : fromStatus as String,
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
      actorType: actorType == const $CopyWithPlaceholder()
          ? _value.actorType
          // ignore: cast_nullable_to_non_nullable
          : actorType as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $AdminBookingEventOutCopyWith on AdminBookingEventOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminBookingEventOut.copyWith(...)` or like so:`instanceOfAdminBookingEventOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminBookingEventOutCWProxy get copyWith =>
      _$AdminBookingEventOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminBookingEventOut _$AdminBookingEventOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminBookingEventOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'fromStatus',
      'status',
      'event',
      'actorType',
      'note',
      'at',
    ],
  );
  final val = AdminBookingEventOut(
    fromStatus: $checkedConvert('fromStatus', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    event: $checkedConvert('event', (v) => v as String),
    step: $checkedConvert('step', (v) => v as String? ?? ''),
    actorType: $checkedConvert('actorType', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String),
    at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$AdminBookingEventOutToJson(
  AdminBookingEventOut instance,
) => <String, dynamic>{
  'fromStatus': instance.fromStatus,
  'status': instance.status,
  'event': instance.event,
  'step': ?instance.step,
  'actorType': instance.actorType,
  'note': instance.note,
  'at': instance.at.toIso8601String(),
};
