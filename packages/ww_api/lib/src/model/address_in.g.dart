// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddressInCWProxy {
  AddressIn memberId(String memberId);

  AddressIn label(String label);

  AddressIn line1(String line1);

  AddressIn landmark(String landmark);

  AddressIn notes(String notes);

  AddressIn lat(String lat);

  AddressIn lng(String lng);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressIn call({
    String memberId,
    String label,
    String line1,
    String landmark,
    String notes,
    String lat,
    String lng,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddressIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddressIn.copyWith.fieldName(...)`
class _$AddressInCWProxyImpl implements _$AddressInCWProxy {
  const _$AddressInCWProxyImpl(this._value);

  final AddressIn _value;

  @override
  AddressIn memberId(String memberId) => this(memberId: memberId);

  @override
  AddressIn label(String label) => this(label: label);

  @override
  AddressIn line1(String line1) => this(line1: line1);

  @override
  AddressIn landmark(String landmark) => this(landmark: landmark);

  @override
  AddressIn notes(String notes) => this(notes: notes);

  @override
  AddressIn lat(String lat) => this(lat: lat);

  @override
  AddressIn lng(String lng) => this(lng: lng);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressIn call({
    Object? memberId = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? line1 = const $CopyWithPlaceholder(),
    Object? landmark = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
  }) {
    return AddressIn(
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      line1: line1 == const $CopyWithPlaceholder()
          ? _value.line1
          // ignore: cast_nullable_to_non_nullable
          : line1 as String,
      landmark: landmark == const $CopyWithPlaceholder()
          ? _value.landmark
          // ignore: cast_nullable_to_non_nullable
          : landmark as String,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String,
    );
  }
}

extension $AddressInCopyWith on AddressIn {
  /// Returns a callable class that can be used as follows: `instanceOfAddressIn.copyWith(...)` or like so:`instanceOfAddressIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddressInCWProxy get copyWith => _$AddressInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressIn _$AddressInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AddressIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'memberId',
          'label',
          'line1',
          'landmark',
          'notes',
          'lat',
          'lng',
        ],
      );
      final val = AddressIn(
        memberId: $checkedConvert('memberId', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        line1: $checkedConvert('line1', (v) => v as String),
        landmark: $checkedConvert('landmark', (v) => v as String),
        notes: $checkedConvert('notes', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AddressInToJson(AddressIn instance) => <String, dynamic>{
  'memberId': instance.memberId,
  'label': instance.label,
  'line1': instance.line1,
  'landmark': instance.landmark,
  'notes': instance.notes,
  'lat': instance.lat,
  'lng': instance.lng,
};
