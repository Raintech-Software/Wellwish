// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_counts_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QueueCountsOutCWProxy {
  QueueCountsOut today(int today);

  QueueCountsOut tomorrow(int tomorrow);

  QueueCountsOut later(int later);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueueCountsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueueCountsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  QueueCountsOut call({int today, int tomorrow, int later});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQueueCountsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQueueCountsOut.copyWith.fieldName(...)`
class _$QueueCountsOutCWProxyImpl implements _$QueueCountsOutCWProxy {
  const _$QueueCountsOutCWProxyImpl(this._value);

  final QueueCountsOut _value;

  @override
  QueueCountsOut today(int today) => this(today: today);

  @override
  QueueCountsOut tomorrow(int tomorrow) => this(tomorrow: tomorrow);

  @override
  QueueCountsOut later(int later) => this(later: later);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueueCountsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueueCountsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  QueueCountsOut call({
    Object? today = const $CopyWithPlaceholder(),
    Object? tomorrow = const $CopyWithPlaceholder(),
    Object? later = const $CopyWithPlaceholder(),
  }) {
    return QueueCountsOut(
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as int,
      tomorrow: tomorrow == const $CopyWithPlaceholder()
          ? _value.tomorrow
          // ignore: cast_nullable_to_non_nullable
          : tomorrow as int,
      later: later == const $CopyWithPlaceholder()
          ? _value.later
          // ignore: cast_nullable_to_non_nullable
          : later as int,
    );
  }
}

extension $QueueCountsOutCopyWith on QueueCountsOut {
  /// Returns a callable class that can be used as follows: `instanceOfQueueCountsOut.copyWith(...)` or like so:`instanceOfQueueCountsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QueueCountsOutCWProxy get copyWith => _$QueueCountsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueCountsOut _$QueueCountsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('QueueCountsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['today', 'tomorrow', 'later']);
      final val = QueueCountsOut(
        today: $checkedConvert('today', (v) => (v as num).toInt()),
        tomorrow: $checkedConvert('tomorrow', (v) => (v as num).toInt()),
        later: $checkedConvert('later', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$QueueCountsOutToJson(QueueCountsOut instance) =>
    <String, dynamic>{
      'today': instance.today,
      'tomorrow': instance.tomorrow,
      'later': instance.later,
    };
