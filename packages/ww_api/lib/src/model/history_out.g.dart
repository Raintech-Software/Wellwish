// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HistoryOutCWProxy {
  HistoryOut at(DateTime at);

  HistoryOut action(String action);

  HistoryOut by(String? by);

  HistoryOut before(String? before);

  HistoryOut after(String? after);

  HistoryOut reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HistoryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HistoryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HistoryOut call({
    DateTime at,
    String action,
    String? by,
    String? before,
    String? after,
    String reason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHistoryOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHistoryOut.copyWith.fieldName(...)`
class _$HistoryOutCWProxyImpl implements _$HistoryOutCWProxy {
  const _$HistoryOutCWProxyImpl(this._value);

  final HistoryOut _value;

  @override
  HistoryOut at(DateTime at) => this(at: at);

  @override
  HistoryOut action(String action) => this(action: action);

  @override
  HistoryOut by(String? by) => this(by: by);

  @override
  HistoryOut before(String? before) => this(before: before);

  @override
  HistoryOut after(String? after) => this(after: after);

  @override
  HistoryOut reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HistoryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HistoryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  HistoryOut call({
    Object? at = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
    Object? by = const $CopyWithPlaceholder(),
    Object? before = const $CopyWithPlaceholder(),
    Object? after = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return HistoryOut(
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      action: action == const $CopyWithPlaceholder()
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as String,
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as String?,
      before: before == const $CopyWithPlaceholder()
          ? _value.before
          // ignore: cast_nullable_to_non_nullable
          : before as String?,
      after: after == const $CopyWithPlaceholder()
          ? _value.after
          // ignore: cast_nullable_to_non_nullable
          : after as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $HistoryOutCopyWith on HistoryOut {
  /// Returns a callable class that can be used as follows: `instanceOfHistoryOut.copyWith(...)` or like so:`instanceOfHistoryOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HistoryOutCWProxy get copyWith => _$HistoryOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryOut _$HistoryOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HistoryOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['at', 'action', 'before', 'after', 'reason'],
      );
      final val = HistoryOut(
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        action: $checkedConvert('action', (v) => v as String),
        by: $checkedConvert('by', (v) => v as String?),
        before: $checkedConvert('before', (v) => v as String?),
        after: $checkedConvert('after', (v) => v as String?),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HistoryOutToJson(HistoryOut instance) =>
    <String, dynamic>{
      'at': instance.at.toIso8601String(),
      'action': instance.action,
      'by': ?instance.by,
      'before': instance.before,
      'after': instance.after,
      'reason': instance.reason,
    };
