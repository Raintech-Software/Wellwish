// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PlaceInCWProxy {
  PlaceIn lat(String? lat);

  PlaceIn lng(String? lng);

  PlaceIn accuracy(num? accuracy);

  PlaceIn clientTs(DateTime? clientTs);

  PlaceIn mock(bool? mock);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceIn call({
    String? lat,
    String? lng,
    num? accuracy,
    DateTime? clientTs,
    bool? mock,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPlaceIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPlaceIn.copyWith.fieldName(...)`
class _$PlaceInCWProxyImpl implements _$PlaceInCWProxy {
  const _$PlaceInCWProxyImpl(this._value);

  final PlaceIn _value;

  @override
  PlaceIn lat(String? lat) => this(lat: lat);

  @override
  PlaceIn lng(String? lng) => this(lng: lng);

  @override
  PlaceIn accuracy(num? accuracy) => this(accuracy: accuracy);

  @override
  PlaceIn clientTs(DateTime? clientTs) => this(clientTs: clientTs);

  @override
  PlaceIn mock(bool? mock) => this(mock: mock);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PlaceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PlaceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PlaceIn call({
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? accuracy = const $CopyWithPlaceholder(),
    Object? clientTs = const $CopyWithPlaceholder(),
    Object? mock = const $CopyWithPlaceholder(),
  }) {
    return PlaceIn(
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String?,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String?,
      accuracy: accuracy == const $CopyWithPlaceholder()
          ? _value.accuracy
          // ignore: cast_nullable_to_non_nullable
          : accuracy as num?,
      clientTs: clientTs == const $CopyWithPlaceholder()
          ? _value.clientTs
          // ignore: cast_nullable_to_non_nullable
          : clientTs as DateTime?,
      mock: mock == const $CopyWithPlaceholder()
          ? _value.mock
          // ignore: cast_nullable_to_non_nullable
          : mock as bool?,
    );
  }
}

extension $PlaceInCopyWith on PlaceIn {
  /// Returns a callable class that can be used as follows: `instanceOfPlaceIn.copyWith(...)` or like so:`instanceOfPlaceIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PlaceInCWProxy get copyWith => _$PlaceInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceIn _$PlaceInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlaceIn', json, ($checkedConvert) {
      final val = PlaceIn(
        lat: $checkedConvert('lat', (v) => v as String?),
        lng: $checkedConvert('lng', (v) => v as String?),
        accuracy: $checkedConvert('accuracy', (v) => v as num?),
        clientTs: $checkedConvert(
          'clientTs',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        mock: $checkedConvert('mock', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$PlaceInToJson(PlaceIn instance) => <String, dynamic>{
  'lat': ?instance.lat,
  'lng': ?instance.lng,
  'accuracy': ?instance.accuracy,
  'clientTs': ?instance.clientTs?.toIso8601String(),
  'mock': ?instance.mock,
};
