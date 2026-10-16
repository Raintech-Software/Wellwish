// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_group_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingsGroupOutCWProxy {
  SettingsGroupOut name(String name);

  SettingsGroupOut settings(List<SettingOut> settings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsGroupOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsGroupOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsGroupOut call({String name, List<SettingOut> settings});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettingsGroupOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettingsGroupOut.copyWith.fieldName(...)`
class _$SettingsGroupOutCWProxyImpl implements _$SettingsGroupOutCWProxy {
  const _$SettingsGroupOutCWProxyImpl(this._value);

  final SettingsGroupOut _value;

  @override
  SettingsGroupOut name(String name) => this(name: name);

  @override
  SettingsGroupOut settings(List<SettingOut> settings) =>
      this(settings: settings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsGroupOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsGroupOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsGroupOut call({
    Object? name = const $CopyWithPlaceholder(),
    Object? settings = const $CopyWithPlaceholder(),
  }) {
    return SettingsGroupOut(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      settings: settings == const $CopyWithPlaceholder()
          ? _value.settings
          // ignore: cast_nullable_to_non_nullable
          : settings as List<SettingOut>,
    );
  }
}

extension $SettingsGroupOutCopyWith on SettingsGroupOut {
  /// Returns a callable class that can be used as follows: `instanceOfSettingsGroupOut.copyWith(...)` or like so:`instanceOfSettingsGroupOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingsGroupOutCWProxy get copyWith => _$SettingsGroupOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsGroupOut _$SettingsGroupOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SettingsGroupOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name', 'settings']);
      final val = SettingsGroupOut(
        name: $checkedConvert('name', (v) => v as String),
        settings: $checkedConvert(
          'settings',
          (v) => (v as List<dynamic>)
              .map((e) => SettingOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SettingsGroupOutToJson(SettingsGroupOut instance) =>
    <String, dynamic>{
      'name': instance.name,
      'settings': instance.settings.map((e) => e.toJson()).toList(),
    };
