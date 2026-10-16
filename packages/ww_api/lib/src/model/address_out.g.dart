// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddressOutCWProxy {
  AddressOut id(String id);

  AddressOut memberId(String memberId);

  AddressOut label(String label);

  AddressOut line1(String line1);

  AddressOut landmark(String landmark);

  AddressOut notes(String notes);

  AddressOut lat(String lat);

  AddressOut lng(String lng);

  AddressOut inServiceArea(bool inServiceArea);

  AddressOut createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressOut call({
    String id,
    String memberId,
    String label,
    String line1,
    String landmark,
    String notes,
    String lat,
    String lng,
    bool inServiceArea,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddressOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddressOut.copyWith.fieldName(...)`
class _$AddressOutCWProxyImpl implements _$AddressOutCWProxy {
  const _$AddressOutCWProxyImpl(this._value);

  final AddressOut _value;

  @override
  AddressOut id(String id) => this(id: id);

  @override
  AddressOut memberId(String memberId) => this(memberId: memberId);

  @override
  AddressOut label(String label) => this(label: label);

  @override
  AddressOut line1(String line1) => this(line1: line1);

  @override
  AddressOut landmark(String landmark) => this(landmark: landmark);

  @override
  AddressOut notes(String notes) => this(notes: notes);

  @override
  AddressOut lat(String lat) => this(lat: lat);

  @override
  AddressOut lng(String lng) => this(lng: lng);

  @override
  AddressOut inServiceArea(bool inServiceArea) =>
      this(inServiceArea: inServiceArea);

  @override
  AddressOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? memberId = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? line1 = const $CopyWithPlaceholder(),
    Object? landmark = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? inServiceArea = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return AddressOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
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
      inServiceArea: inServiceArea == const $CopyWithPlaceholder()
          ? _value.inServiceArea
          // ignore: cast_nullable_to_non_nullable
          : inServiceArea as bool,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $AddressOutCopyWith on AddressOut {
  /// Returns a callable class that can be used as follows: `instanceOfAddressOut.copyWith(...)` or like so:`instanceOfAddressOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddressOutCWProxy get copyWith => _$AddressOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressOut _$AddressOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AddressOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'memberId',
          'label',
          'line1',
          'landmark',
          'notes',
          'lat',
          'lng',
          'inServiceArea',
          'createdAt',
        ],
      );
      final val = AddressOut(
        id: $checkedConvert('id', (v) => v as String),
        memberId: $checkedConvert('memberId', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        line1: $checkedConvert('line1', (v) => v as String),
        landmark: $checkedConvert('landmark', (v) => v as String),
        notes: $checkedConvert('notes', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        inServiceArea: $checkedConvert('inServiceArea', (v) => v as bool),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AddressOutToJson(AddressOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'memberId': instance.memberId,
      'label': instance.label,
      'line1': instance.line1,
      'landmark': instance.landmark,
      'notes': instance.notes,
      'lat': instance.lat,
      'lng': instance.lng,
      'inServiceArea': instance.inServiceArea,
      'createdAt': instance.createdAt.toIso8601String(),
    };
