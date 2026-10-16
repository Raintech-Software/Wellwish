// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SettingOutCWProxy {
  SettingOut key(String key);

  SettingOut label(String label);

  SettingOut kind(String kind);

  SettingOut value(String value);

  SettingOut default_(String default_);

  SettingOut help(String help);

  SettingOut min(int? min);

  SettingOut max(int? max);

  SettingOut choices(List<String> choices);

  SettingOut unit(String unit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingOut call({
    String key,
    String label,
    String kind,
    String value,
    String default_,
    String help,
    int? min,
    int? max,
    List<String> choices,
    String unit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSettingOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSettingOut.copyWith.fieldName(...)`
class _$SettingOutCWProxyImpl implements _$SettingOutCWProxy {
  const _$SettingOutCWProxyImpl(this._value);

  final SettingOut _value;

  @override
  SettingOut key(String key) => this(key: key);

  @override
  SettingOut label(String label) => this(label: label);

  @override
  SettingOut kind(String kind) => this(kind: kind);

  @override
  SettingOut value(String value) => this(value: value);

  @override
  SettingOut default_(String default_) => this(default_: default_);

  @override
  SettingOut help(String help) => this(help: help);

  @override
  SettingOut min(int? min) => this(min: min);

  @override
  SettingOut max(int? max) => this(max: max);

  @override
  SettingOut choices(List<String> choices) => this(choices: choices);

  @override
  SettingOut unit(String unit) => this(unit: unit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SettingOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SettingOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SettingOut call({
    Object? key = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? value = const $CopyWithPlaceholder(),
    Object? default_ = const $CopyWithPlaceholder(),
    Object? help = const $CopyWithPlaceholder(),
    Object? min = const $CopyWithPlaceholder(),
    Object? max = const $CopyWithPlaceholder(),
    Object? choices = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
  }) {
    return SettingOut(
      key: key == const $CopyWithPlaceholder()
          ? _value.key
          // ignore: cast_nullable_to_non_nullable
          : key as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      value: value == const $CopyWithPlaceholder()
          ? _value.value
          // ignore: cast_nullable_to_non_nullable
          : value as String,
      default_: default_ == const $CopyWithPlaceholder()
          ? _value.default_
          // ignore: cast_nullable_to_non_nullable
          : default_ as String,
      help: help == const $CopyWithPlaceholder()
          ? _value.help
          // ignore: cast_nullable_to_non_nullable
          : help as String,
      min: min == const $CopyWithPlaceholder()
          ? _value.min
          // ignore: cast_nullable_to_non_nullable
          : min as int?,
      max: max == const $CopyWithPlaceholder()
          ? _value.max
          // ignore: cast_nullable_to_non_nullable
          : max as int?,
      choices: choices == const $CopyWithPlaceholder()
          ? _value.choices
          // ignore: cast_nullable_to_non_nullable
          : choices as List<String>,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String,
    );
  }
}

extension $SettingOutCopyWith on SettingOut {
  /// Returns a callable class that can be used as follows: `instanceOfSettingOut.copyWith(...)` or like so:`instanceOfSettingOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SettingOutCWProxy get copyWith => _$SettingOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingOut _$SettingOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SettingOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'key',
          'label',
          'kind',
          'value',
          'default',
          'help',
          'choices',
          'unit',
        ],
      );
      final val = SettingOut(
        key: $checkedConvert('key', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        kind: $checkedConvert('kind', (v) => v as String),
        value: $checkedConvert('value', (v) => v as String),
        default_: $checkedConvert('default', (v) => v as String),
        help: $checkedConvert('help', (v) => v as String),
        min: $checkedConvert('min', (v) => (v as num?)?.toInt()),
        max: $checkedConvert('max', (v) => (v as num?)?.toInt()),
        choices: $checkedConvert(
          'choices',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        unit: $checkedConvert('unit', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'default_': 'default'});

Map<String, dynamic> _$SettingOutToJson(SettingOut instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'kind': instance.kind,
      'value': instance.value,
      'default': instance.default_,
      'help': instance.help,
      'min': ?instance.min,
      'max': ?instance.max,
      'choices': instance.choices,
      'unit': instance.unit,
    };
