// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingsOutCWProxy {
  SettingsOut groups(List<SettingsGroupOut> groups);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsOut call({List<SettingsGroupOut> groups});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettingsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettingsOut.copyWith.fieldName(...)`
class _$SettingsOutCWProxyImpl implements _$SettingsOutCWProxy {
  const _$SettingsOutCWProxyImpl(this._value);

  final SettingsOut _value;

  @override
  SettingsOut groups(List<SettingsGroupOut> groups) => this(groups: groups);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsOut call({Object? groups = const $CopyWithPlaceholder()}) {
    return SettingsOut(
      groups: groups == const $CopyWithPlaceholder()
          ? _value.groups
          // ignore: cast_nullable_to_non_nullable
          : groups as List<SettingsGroupOut>,
    );
  }
}

extension $SettingsOutCopyWith on SettingsOut {
  /// Returns a callable class that can be used as follows: `instanceOfSettingsOut.copyWith(...)` or like so:`instanceOfSettingsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingsOutCWProxy get copyWith => _$SettingsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsOut _$SettingsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SettingsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['groups']);
      final val = SettingsOut(
        groups: $checkedConvert(
          'groups',
          (v) => (v as List<dynamic>)
              .map((e) => SettingsGroupOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SettingsOutToJson(SettingsOut instance) =>
    <String, dynamic>{
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };
