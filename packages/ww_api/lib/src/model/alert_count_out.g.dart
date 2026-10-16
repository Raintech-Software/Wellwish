// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_count_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AlertCountOutCWProxy {
  AlertCountOut kind(String kind);

  AlertCountOut count(int count);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertCountOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertCountOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertCountOut call({String kind, int count});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAlertCountOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAlertCountOut.copyWith.fieldName(...)`
class _$AlertCountOutCWProxyImpl implements _$AlertCountOutCWProxy {
  const _$AlertCountOutCWProxyImpl(this._value);

  final AlertCountOut _value;

  @override
  AlertCountOut kind(String kind) => this(kind: kind);

  @override
  AlertCountOut count(int count) => this(count: count);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertCountOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertCountOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertCountOut call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
  }) {
    return AlertCountOut(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
    );
  }
}

extension $AlertCountOutCopyWith on AlertCountOut {
  /// Returns a callable class that can be used as follows: `instanceOfAlertCountOut.copyWith(...)` or like so:`instanceOfAlertCountOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AlertCountOutCWProxy get copyWith => _$AlertCountOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertCountOut _$AlertCountOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AlertCountOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['kind', 'count']);
      final val = AlertCountOut(
        kind: $checkedConvert('kind', (v) => v as String),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AlertCountOutToJson(AlertCountOut instance) =>
    <String, dynamic>{'kind': instance.kind, 'count': instance.count};
