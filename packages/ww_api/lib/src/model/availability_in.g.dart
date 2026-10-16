// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AvailabilityInCWProxy {
  AvailabilityIn availableToday(bool availableToday);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityIn call({bool availableToday});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAvailabilityIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAvailabilityIn.copyWith.fieldName(...)`
class _$AvailabilityInCWProxyImpl implements _$AvailabilityInCWProxy {
  const _$AvailabilityInCWProxyImpl(this._value);

  final AvailabilityIn _value;

  @override
  AvailabilityIn availableToday(bool availableToday) =>
      this(availableToday: availableToday);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AvailabilityIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AvailabilityIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AvailabilityIn call({Object? availableToday = const $CopyWithPlaceholder()}) {
    return AvailabilityIn(
      availableToday: availableToday == const $CopyWithPlaceholder()
          ? _value.availableToday
          // ignore: cast_nullable_to_non_nullable
          : availableToday as bool,
    );
  }
}

extension $AvailabilityInCopyWith on AvailabilityIn {
  /// Returns a callable class that can be used as follows: `instanceOfAvailabilityIn.copyWith(...)` or like so:`instanceOfAvailabilityIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AvailabilityInCWProxy get copyWith => _$AvailabilityInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailabilityIn _$AvailabilityInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AvailabilityIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['availableToday']);
      final val = AvailabilityIn(
        availableToday: $checkedConvert('availableToday', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AvailabilityInToJson(AvailabilityIn instance) =>
    <String, dynamic>{'availableToday': instance.availableToday};
