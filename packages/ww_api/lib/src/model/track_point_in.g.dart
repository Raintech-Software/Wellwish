// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_point_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackPointInCWProxy {
  TrackPointIn lat(String lat);

  TrackPointIn lng(String lng);

  TrackPointIn accuracy(num accuracy);

  TrackPointIn mock(bool? mock);

  TrackPointIn at(DateTime at);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackPointIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackPointIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackPointIn call({
    String lat,
    String lng,
    num accuracy,
    bool? mock,
    DateTime at,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrackPointIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrackPointIn.copyWith.fieldName(...)`
class _$TrackPointInCWProxyImpl implements _$TrackPointInCWProxy {
  const _$TrackPointInCWProxyImpl(this._value);

  final TrackPointIn _value;

  @override
  TrackPointIn lat(String lat) => this(lat: lat);

  @override
  TrackPointIn lng(String lng) => this(lng: lng);

  @override
  TrackPointIn accuracy(num accuracy) => this(accuracy: accuracy);

  @override
  TrackPointIn mock(bool? mock) => this(mock: mock);

  @override
  TrackPointIn at(DateTime at) => this(at: at);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackPointIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackPointIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackPointIn call({
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? accuracy = const $CopyWithPlaceholder(),
    Object? mock = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
  }) {
    return TrackPointIn(
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String,
      accuracy: accuracy == const $CopyWithPlaceholder()
          ? _value.accuracy
          // ignore: cast_nullable_to_non_nullable
          : accuracy as num,
      mock: mock == const $CopyWithPlaceholder()
          ? _value.mock
          // ignore: cast_nullable_to_non_nullable
          : mock as bool?,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
    );
  }
}

extension $TrackPointInCopyWith on TrackPointIn {
  /// Returns a callable class that can be used as follows: `instanceOfTrackPointIn.copyWith(...)` or like so:`instanceOfTrackPointIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackPointInCWProxy get copyWith => _$TrackPointInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackPointIn _$TrackPointInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackPointIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['lat', 'lng', 'accuracy', 'at']);
      final val = TrackPointIn(
        lat: $checkedConvert('lat', (v) => v as String),
        lng: $checkedConvert('lng', (v) => v as String),
        accuracy: $checkedConvert('accuracy', (v) => v as num),
        mock: $checkedConvert('mock', (v) => v as bool? ?? false),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$TrackPointInToJson(TrackPointIn instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'accuracy': instance.accuracy,
      'mock': ?instance.mock,
      'at': instance.at.toIso8601String(),
    };
