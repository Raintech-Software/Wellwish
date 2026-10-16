// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackOutCWProxy {
  TrackOut points(List<List<num>> points);

  TrackOut km(String km);

  TrackOut startedAt(DateTime? startedAt);

  TrackOut endedAt(DateTime? endedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackOut call({
    List<List<num>> points,
    String km,
    DateTime? startedAt,
    DateTime? endedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrackOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrackOut.copyWith.fieldName(...)`
class _$TrackOutCWProxyImpl implements _$TrackOutCWProxy {
  const _$TrackOutCWProxyImpl(this._value);

  final TrackOut _value;

  @override
  TrackOut points(List<List<num>> points) => this(points: points);

  @override
  TrackOut km(String km) => this(km: km);

  @override
  TrackOut startedAt(DateTime? startedAt) => this(startedAt: startedAt);

  @override
  TrackOut endedAt(DateTime? endedAt) => this(endedAt: endedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackOut call({
    Object? points = const $CopyWithPlaceholder(),
    Object? km = const $CopyWithPlaceholder(),
    Object? startedAt = const $CopyWithPlaceholder(),
    Object? endedAt = const $CopyWithPlaceholder(),
  }) {
    return TrackOut(
      points: points == const $CopyWithPlaceholder()
          ? _value.points
          // ignore: cast_nullable_to_non_nullable
          : points as List<List<num>>,
      km: km == const $CopyWithPlaceholder()
          ? _value.km
          // ignore: cast_nullable_to_non_nullable
          : km as String,
      startedAt: startedAt == const $CopyWithPlaceholder()
          ? _value.startedAt
          // ignore: cast_nullable_to_non_nullable
          : startedAt as DateTime?,
      endedAt: endedAt == const $CopyWithPlaceholder()
          ? _value.endedAt
          // ignore: cast_nullable_to_non_nullable
          : endedAt as DateTime?,
    );
  }
}

extension $TrackOutCopyWith on TrackOut {
  /// Returns a callable class that can be used as follows: `instanceOfTrackOut.copyWith(...)` or like so:`instanceOfTrackOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackOutCWProxy get copyWith => _$TrackOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackOut _$TrackOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['points', 'km', 'startedAt', 'endedAt'],
      );
      final val = TrackOut(
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>)
              .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
              .toList(),
        ),
        km: $checkedConvert('km', (v) => v as String),
        startedAt: $checkedConvert(
          'startedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        endedAt: $checkedConvert(
          'endedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TrackOutToJson(TrackOut instance) => <String, dynamic>{
  'points': instance.points,
  'km': instance.km,
  'startedAt': instance.startedAt?.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
};
