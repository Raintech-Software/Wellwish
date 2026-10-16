// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reschedule_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RescheduleInCWProxy {
  RescheduleIn pickupAt(DateTime pickupAt);

  RescheduleIn appointmentAt(DateTime? appointmentAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RescheduleIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RescheduleIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RescheduleIn call({DateTime pickupAt, DateTime? appointmentAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRescheduleIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRescheduleIn.copyWith.fieldName(...)`
class _$RescheduleInCWProxyImpl implements _$RescheduleInCWProxy {
  const _$RescheduleInCWProxyImpl(this._value);

  final RescheduleIn _value;

  @override
  RescheduleIn pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  RescheduleIn appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RescheduleIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RescheduleIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RescheduleIn call({
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
  }) {
    return RescheduleIn(
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      appointmentAt: appointmentAt == const $CopyWithPlaceholder()
          ? _value.appointmentAt
          // ignore: cast_nullable_to_non_nullable
          : appointmentAt as DateTime?,
    );
  }
}

extension $RescheduleInCopyWith on RescheduleIn {
  /// Returns a callable class that can be used as follows: `instanceOfRescheduleIn.copyWith(...)` or like so:`instanceOfRescheduleIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RescheduleInCWProxy get copyWith => _$RescheduleInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RescheduleIn _$RescheduleInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RescheduleIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['pickupAt']);
      final val = RescheduleIn(
        pickupAt: $checkedConvert(
          'pickupAt',
          (v) => DateTime.parse(v as String),
        ),
        appointmentAt: $checkedConvert(
          'appointmentAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RescheduleInToJson(RescheduleIn instance) =>
    <String, dynamic>{
      'pickupAt': instance.pickupAt.toIso8601String(),
      'appointmentAt': ?instance.appointmentAt?.toIso8601String(),
    };
