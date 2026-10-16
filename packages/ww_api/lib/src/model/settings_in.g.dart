// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingsInCWProxy {
  SettingsIn values(Map<String, String> values);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsIn call({Map<String, String> values});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettingsIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettingsIn.copyWith.fieldName(...)`
class _$SettingsInCWProxyImpl implements _$SettingsInCWProxy {
  const _$SettingsInCWProxyImpl(this._value);

  final SettingsIn _value;

  @override
  SettingsIn values(Map<String, String> values) => this(values: values);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingsIn call({Object? values = const $CopyWithPlaceholder()}) {
    return SettingsIn(
      values: values == const $CopyWithPlaceholder()
          ? _value.values
          // ignore: cast_nullable_to_non_nullable
          : values as Map<String, String>,
    );
  }
}

extension $SettingsInCopyWith on SettingsIn {
  /// Returns a callable class that can be used as follows: `instanceOfSettingsIn.copyWith(...)` or like so:`instanceOfSettingsIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingsInCWProxy get copyWith => _$SettingsInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsIn _$SettingsInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SettingsIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['values']);
      final val = SettingsIn(
        values: $checkedConvert(
          'values',
          (v) => Map<String, String>.from(v as Map),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SettingsInToJson(SettingsIn instance) =>
    <String, dynamic>{'values': instance.values};
