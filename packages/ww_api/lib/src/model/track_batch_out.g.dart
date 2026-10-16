// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_batch_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TrackBatchOutCWProxy {
  TrackBatchOut accepted(int accepted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackBatchOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackBatchOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackBatchOut call({int accepted});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTrackBatchOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTrackBatchOut.copyWith.fieldName(...)`
class _$TrackBatchOutCWProxyImpl implements _$TrackBatchOutCWProxy {
  const _$TrackBatchOutCWProxyImpl(this._value);

  final TrackBatchOut _value;

  @override
  TrackBatchOut accepted(int accepted) => this(accepted: accepted);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TrackBatchOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TrackBatchOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TrackBatchOut call({Object? accepted = const $CopyWithPlaceholder()}) {
    return TrackBatchOut(
      accepted: accepted == const $CopyWithPlaceholder()
          ? _value.accepted
          // ignore: cast_nullable_to_non_nullable
          : accepted as int,
    );
  }
}

extension $TrackBatchOutCopyWith on TrackBatchOut {
  /// Returns a callable class that can be used as follows: `instanceOfTrackBatchOut.copyWith(...)` or like so:`instanceOfTrackBatchOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TrackBatchOutCWProxy get copyWith => _$TrackBatchOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackBatchOut _$TrackBatchOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TrackBatchOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['accepted']);
      final val = TrackBatchOut(
        accepted: $checkedConvert('accepted', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$TrackBatchOutToJson(TrackBatchOut instance) =>
    <String, dynamic>{'accepted': instance.accepted};
