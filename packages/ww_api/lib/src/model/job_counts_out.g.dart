// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_counts_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$JobCountsOutCWProxy {
  JobCountsOut today(int today);

  JobCountsOut thisWeek(int thisWeek);

  JobCountsOut thisMonth(int thisMonth);

  JobCountsOut allTime(int allTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCountsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCountsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCountsOut call({int today, int thisWeek, int thisMonth, int allTime});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfJobCountsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfJobCountsOut.copyWith.fieldName(...)`
class _$JobCountsOutCWProxyImpl implements _$JobCountsOutCWProxy {
  const _$JobCountsOutCWProxyImpl(this._value);

  final JobCountsOut _value;

  @override
  JobCountsOut today(int today) => this(today: today);

  @override
  JobCountsOut thisWeek(int thisWeek) => this(thisWeek: thisWeek);

  @override
  JobCountsOut thisMonth(int thisMonth) => this(thisMonth: thisMonth);

  @override
  JobCountsOut allTime(int allTime) => this(allTime: allTime);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `JobCountsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// JobCountsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  JobCountsOut call({
    Object? today = const $CopyWithPlaceholder(),
    Object? thisWeek = const $CopyWithPlaceholder(),
    Object? thisMonth = const $CopyWithPlaceholder(),
    Object? allTime = const $CopyWithPlaceholder(),
  }) {
    return JobCountsOut(
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as int,
      thisWeek: thisWeek == const $CopyWithPlaceholder()
          ? _value.thisWeek
          // ignore: cast_nullable_to_non_nullable
          : thisWeek as int,
      thisMonth: thisMonth == const $CopyWithPlaceholder()
          ? _value.thisMonth
          // ignore: cast_nullable_to_non_nullable
          : thisMonth as int,
      allTime: allTime == const $CopyWithPlaceholder()
          ? _value.allTime
          // ignore: cast_nullable_to_non_nullable
          : allTime as int,
    );
  }
}

extension $JobCountsOutCopyWith on JobCountsOut {
  /// Returns a callable class that can be used as follows: `instanceOfJobCountsOut.copyWith(...)` or like so:`instanceOfJobCountsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$JobCountsOutCWProxy get copyWith => _$JobCountsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobCountsOut _$JobCountsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('JobCountsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['today', 'thisWeek', 'thisMonth', 'allTime'],
      );
      final val = JobCountsOut(
        today: $checkedConvert('today', (v) => (v as num).toInt()),
        thisWeek: $checkedConvert('thisWeek', (v) => (v as num).toInt()),
        thisMonth: $checkedConvert('thisMonth', (v) => (v as num).toInt()),
        allTime: $checkedConvert('allTime', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$JobCountsOutToJson(JobCountsOut instance) =>
    <String, dynamic>{
      'today': instance.today,
      'thisWeek': instance.thisWeek,
      'thisMonth': instance.thisMonth,
      'allTime': instance.allTime,
    };
