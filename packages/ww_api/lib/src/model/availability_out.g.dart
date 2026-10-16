// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AvailabilityOutCWProxy {
  AvailabilityOut availableToday(bool availableToday);

  AvailabilityOut selfieToday(bool? selfieToday);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityOut call({bool availableToday, bool? selfieToday});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAvailabilityOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAvailabilityOut.copyWith.fieldName(...)`
class _$AvailabilityOutCWProxyImpl implements _$AvailabilityOutCWProxy {
  const _$AvailabilityOutCWProxyImpl(this._value);

  final AvailabilityOut _value;

  @override
  AvailabilityOut availableToday(bool availableToday) =>
      this(availableToday: availableToday);

  @override
  AvailabilityOut selfieToday(bool? selfieToday) =>
      this(selfieToday: selfieToday);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityOut call({
    Object? availableToday = const $CopyWithPlaceholder(),
    Object? selfieToday = const $CopyWithPlaceholder(),
  }) {
    return AvailabilityOut(
      availableToday: availableToday == const $CopyWithPlaceholder()
          ? _value.availableToday
          // ignore: cast_nullable_to_non_nullable
          : availableToday as bool,
      selfieToday: selfieToday == const $CopyWithPlaceholder()
          ? _value.selfieToday
          // ignore: cast_nullable_to_non_nullable
          : selfieToday as bool?,
    );
  }
}

extension $AvailabilityOutCopyWith on AvailabilityOut {
  /// Returns a callable class that can be used as follows: `instanceOfAvailabilityOut.copyWith(...)` or like so:`instanceOfAvailabilityOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AvailabilityOutCWProxy get copyWith => _$AvailabilityOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailabilityOut _$AvailabilityOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AvailabilityOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['availableToday']);
      final val = AvailabilityOut(
        availableToday: $checkedConvert('availableToday', (v) => v as bool),
        selfieToday: $checkedConvert('selfieToday', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$AvailabilityOutToJson(AvailabilityOut instance) =>
    <String, dynamic>{
      'availableToday': instance.availableToday,
      'selfieToday': ?instance.selfieToday,
    };
