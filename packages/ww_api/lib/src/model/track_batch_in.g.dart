// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_batch_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackBatchInCWProxy {
  TrackBatchIn points(List<TrackPointIn> points);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackBatchIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackBatchIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackBatchIn call({List<TrackPointIn> points});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrackBatchIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrackBatchIn.copyWith.fieldName(...)`
class _$TrackBatchInCWProxyImpl implements _$TrackBatchInCWProxy {
  const _$TrackBatchInCWProxyImpl(this._value);

  final TrackBatchIn _value;

  @override
  TrackBatchIn points(List<TrackPointIn> points) => this(points: points);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackBatchIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackBatchIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackBatchIn call({Object? points = const $CopyWithPlaceholder()}) {
    return TrackBatchIn(
      points: points == const $CopyWithPlaceholder()
          ? _value.points
          // ignore: cast_nullable_to_non_nullable
          : points as List<TrackPointIn>,
    );
  }
}

extension $TrackBatchInCopyWith on TrackBatchIn {
  /// Returns a callable class that can be used as follows: `instanceOfTrackBatchIn.copyWith(...)` or like so:`instanceOfTrackBatchIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackBatchInCWProxy get copyWith => _$TrackBatchInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackBatchIn _$TrackBatchInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackBatchIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['points']);
      final val = TrackBatchIn(
        points: $checkedConvert(
          'points',
          (v) => (v as List<dynamic>)
              .map((e) => TrackPointIn.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TrackBatchInToJson(TrackBatchIn instance) =>
    <String, dynamic>{
      'points': instance.points.map((e) => e.toJson()).toList(),
    };
