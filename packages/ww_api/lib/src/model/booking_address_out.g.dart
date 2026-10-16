// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_address_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingAddressOutCWProxy {
  BookingAddressOut label(String label);

  BookingAddressOut line1(String line1);

  BookingAddressOut landmark(String landmark);

  BookingAddressOut notes(String notes);

  BookingAddressOut lat(String lat);

  BookingAddressOut lng(String lng);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingAddressOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingAddressOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingAddressOut call({
    String label,
    String line1,
    String landmark,
    String notes,
    String lat,
    String lng,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingAddressOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingAddressOut.copyWith.fieldName(...)`
class _$BookingAddressOutCWProxyImpl implements _$BookingAddressOutCWProxy {
  const _$BookingAddressOutCWProxyImpl(this._value);

  final BookingAddressOut _value;

  @override
  BookingAddressOut label(String label) => this(label: label);

  @override
  BookingAddressOut line1(String line1) => this(line1: line1);

  @override
  BookingAddressOut landmark(String landmark) => this(landmark: landmark);

  @override
  BookingAddressOut notes(String notes) => this(notes: notes);

  @override
  BookingAddressOut lat(String lat) => this(lat: lat);

  @override
  BookingAddressOut lng(String lng) => this(lng: lng);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingAddressOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingAddressOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingAddressOut call({
    Object? label = const $CopyWithPlaceholder(),
    Object? line1 = const $CopyWithPlaceholder(),
    Object? landmark = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
  }) {
    return BookingAddressOut(
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

extension $BookingAddressOutCopyWith on BookingAddressOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingAddressOut.copyWith(...)` or like so:`instanceOfBookingAddressOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingAddressOutCWProxy get copyWith =>
      _$BookingAddressOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingAddressOut _$BookingAddressOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingAddressOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'label',
          'line1',
          'landmark',
          'notes',
          'lat',
          'lng',
        ],
      );
      final val = BookingAddressOut(
        label: $checkedConvert('label', (v) => v as String),
        line1: $checkedConvert('line1', (v) => v as String),
        landmark: $checkedConvert('landmark', (v) => v as String),
        notes: $checkedConvert('notes', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$BookingAddressOutToJson(BookingAddressOut instance) =>
    <String, dynamic>{
      'label': instance.label,
      'line1': instance.line1,
      'landmark': instance.landmark,
      'notes': instance.notes,
      'lat': instance.lat,
      'lng': instance.lng,
    };
