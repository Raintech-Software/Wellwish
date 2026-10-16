// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AlertsOutCWProxy {
  AlertsOut open(int open);

  AlertsOut byKind(List<AlertCountOut> byKind);

  AlertsOut sosOpen(int sosOpen);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertsOut call({int open, List<AlertCountOut> byKind, int sosOpen});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAlertsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAlertsOut.copyWith.fieldName(...)`
class _$AlertsOutCWProxyImpl implements _$AlertsOutCWProxy {
  const _$AlertsOutCWProxyImpl(this._value);

  final AlertsOut _value;

  @override
  AlertsOut open(int open) => this(open: open);

  @override
  AlertsOut byKind(List<AlertCountOut> byKind) => this(byKind: byKind);

  @override
  AlertsOut sosOpen(int sosOpen) => this(sosOpen: sosOpen);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertsOut call({
    Object? open = const $CopyWithPlaceholder(),
    Object? byKind = const $CopyWithPlaceholder(),
    Object? sosOpen = const $CopyWithPlaceholder(),
  }) {
    return AlertsOut(
      open: open == const $CopyWithPlaceholder()
          ? _value.open
          // ignore: cast_nullable_to_non_nullable
          : open as int,
      byKind: byKind == const $CopyWithPlaceholder()
          ? _value.byKind
          // ignore: cast_nullable_to_non_nullable
          : byKind as List<AlertCountOut>,
      sosOpen: sosOpen == const $CopyWithPlaceholder()
          ? _value.sosOpen
          // ignore: cast_nullable_to_non_nullable
          : sosOpen as int,
    );
  }
}

extension $AlertsOutCopyWith on AlertsOut {
  /// Returns a callable class that can be used as follows: `instanceOfAlertsOut.copyWith(...)` or like so:`instanceOfAlertsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AlertsOutCWProxy get copyWith => _$AlertsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertsOut _$AlertsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AlertsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['open', 'byKind', 'sosOpen']);
      final val = AlertsOut(
        open: $checkedConvert('open', (v) => (v as num).toInt()),
        byKind: $checkedConvert(
          'byKind',
          (v) => (v as List<dynamic>)
              .map((e) => AlertCountOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        sosOpen: $checkedConvert('sosOpen', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AlertsOutToJson(AlertsOut instance) => <String, dynamic>{
  'open': instance.open,
  'byKind': instance.byKind.map((e) => e.toJson()).toList(),
  'sosOpen': instance.sosOpen,
};
