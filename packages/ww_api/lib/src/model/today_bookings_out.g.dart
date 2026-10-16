// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_bookings_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodayBookingsOutCWProxy {
  TodayBookingsOut new_(int new_);

  TodayBookingsOut offered(int offered);

  TodayBookingsOut accepted(int accepted);

  TodayBookingsOut inProgress(int inProgress);

  TodayBookingsOut completed(int completed);

  TodayBookingsOut noShow(int noShow);

  TodayBookingsOut cancelled(int cancelled);

  TodayBookingsOut queueToday(int queueToday);

  TodayBookingsOut queueLater(int queueLater);

  TodayBookingsOut queueLate(int queueLate);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayBookingsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayBookingsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayBookingsOut call({
    int new_,
    int offered,
    int accepted,
    int inProgress,
    int completed,
    int noShow,
    int cancelled,
    int queueToday,
    int queueLater,
    int queueLate,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodayBookingsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodayBookingsOut.copyWith.fieldName(...)`
class _$TodayBookingsOutCWProxyImpl implements _$TodayBookingsOutCWProxy {
  const _$TodayBookingsOutCWProxyImpl(this._value);

  final TodayBookingsOut _value;

  @override
  TodayBookingsOut new_(int new_) => this(new_: new_);

  @override
  TodayBookingsOut offered(int offered) => this(offered: offered);

  @override
  TodayBookingsOut accepted(int accepted) => this(accepted: accepted);

  @override
  TodayBookingsOut inProgress(int inProgress) => this(inProgress: inProgress);

  @override
  TodayBookingsOut completed(int completed) => this(completed: completed);

  @override
  TodayBookingsOut noShow(int noShow) => this(noShow: noShow);

  @override
  TodayBookingsOut cancelled(int cancelled) => this(cancelled: cancelled);

  @override
  TodayBookingsOut queueToday(int queueToday) => this(queueToday: queueToday);

  @override
  TodayBookingsOut queueLater(int queueLater) => this(queueLater: queueLater);

  @override
  TodayBookingsOut queueLate(int queueLate) => this(queueLate: queueLate);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodayBookingsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodayBookingsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TodayBookingsOut call({
    Object? new_ = const $CopyWithPlaceholder(),
    Object? offered = const $CopyWithPlaceholder(),
    Object? accepted = const $CopyWithPlaceholder(),
    Object? inProgress = const $CopyWithPlaceholder(),
    Object? completed = const $CopyWithPlaceholder(),
    Object? noShow = const $CopyWithPlaceholder(),
    Object? cancelled = const $CopyWithPlaceholder(),
    Object? queueToday = const $CopyWithPlaceholder(),
    Object? queueLater = const $CopyWithPlaceholder(),
    Object? queueLate = const $CopyWithPlaceholder(),
  }) {
    return TodayBookingsOut(
      new_: new_ == const $CopyWithPlaceholder()
          ? _value.new_
          // ignore: cast_nullable_to_non_nullable
          : new_ as int,
      offered: offered == const $CopyWithPlaceholder()
          ? _value.offered
          // ignore: cast_nullable_to_non_nullable
          : offered as int,
      accepted: accepted == const $CopyWithPlaceholder()
          ? _value.accepted
          // ignore: cast_nullable_to_non_nullable
          : accepted as int,
      inProgress: inProgress == const $CopyWithPlaceholder()
          ? _value.inProgress
          // ignore: cast_nullable_to_non_nullable
          : inProgress as int,
      completed: completed == const $CopyWithPlaceholder()
          ? _value.completed
          // ignore: cast_nullable_to_non_nullable
          : completed as int,
      noShow: noShow == const $CopyWithPlaceholder()
          ? _value.noShow
          // ignore: cast_nullable_to_non_nullable
          : noShow as int,
      cancelled: cancelled == const $CopyWithPlaceholder()
          ? _value.cancelled
          // ignore: cast_nullable_to_non_nullable
          : cancelled as int,
      queueToday: queueToday == const $CopyWithPlaceholder()
          ? _value.queueToday
          // ignore: cast_nullable_to_non_nullable
          : queueToday as int,
      queueLater: queueLater == const $CopyWithPlaceholder()
          ? _value.queueLater
          // ignore: cast_nullable_to_non_nullable
          : queueLater as int,
      queueLate: queueLate == const $CopyWithPlaceholder()
          ? _value.queueLate
          // ignore: cast_nullable_to_non_nullable
          : queueLate as int,
    );
  }
}

extension $TodayBookingsOutCopyWith on TodayBookingsOut {
  /// Returns a callable class that can be used as follows: `instanceOfTodayBookingsOut.copyWith(...)` or like so:`instanceOfTodayBookingsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodayBookingsOutCWProxy get copyWith => _$TodayBookingsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayBookingsOut _$TodayBookingsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TodayBookingsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'new',
          'offered',
          'accepted',
          'inProgress',
          'completed',
          'noShow',
          'cancelled',
          'queueToday',
          'queueLater',
          'queueLate',
        ],
      );
      final val = TodayBookingsOut(
        new_: $checkedConvert('new', (v) => (v as num).toInt()),
        offered: $checkedConvert('offered', (v) => (v as num).toInt()),
        accepted: $checkedConvert('accepted', (v) => (v as num).toInt()),
        inProgress: $checkedConvert('inProgress', (v) => (v as num).toInt()),
        completed: $checkedConvert('completed', (v) => (v as num).toInt()),
        noShow: $checkedConvert('noShow', (v) => (v as num).toInt()),
        cancelled: $checkedConvert('cancelled', (v) => (v as num).toInt()),
        queueToday: $checkedConvert('queueToday', (v) => (v as num).toInt()),
        queueLater: $checkedConvert('queueLater', (v) => (v as num).toInt()),
        queueLate: $checkedConvert('queueLate', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'new_': 'new'});

Map<String, dynamic> _$TodayBookingsOutToJson(TodayBookingsOut instance) =>
    <String, dynamic>{
      'new': instance.new_,
      'offered': instance.offered,
      'accepted': instance.accepted,
      'inProgress': instance.inProgress,
      'completed': instance.completed,
      'noShow': instance.noShow,
      'cancelled': instance.cancelled,
      'queueToday': instance.queueToday,
      'queueLater': instance.queueLater,
      'queueLate': instance.queueLate,
    };
