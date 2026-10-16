// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_sms_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DevSmsOutCWProxy {
  DevSmsOut at(DateTime at);

  DevSmsOut phone(String phone);

  DevSmsOut template(String template);

  DevSmsOut text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevSmsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevSmsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevSmsOut call({DateTime at, String phone, String template, String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDevSmsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDevSmsOut.copyWith.fieldName(...)`
class _$DevSmsOutCWProxyImpl implements _$DevSmsOutCWProxy {
  const _$DevSmsOutCWProxyImpl(this._value);

  final DevSmsOut _value;

  @override
  DevSmsOut at(DateTime at) => this(at: at);

  @override
  DevSmsOut phone(String phone) => this(phone: phone);

  @override
  DevSmsOut template(String template) => this(template: template);

  @override
  DevSmsOut text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevSmsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevSmsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevSmsOut call({
    Object? at = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? template = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
  }) {
    return DevSmsOut(
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      template: template == const $CopyWithPlaceholder()
          ? _value.template
          // ignore: cast_nullable_to_non_nullable
          : template as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $DevSmsOutCopyWith on DevSmsOut {
  /// Returns a callable class that can be used as follows: `instanceOfDevSmsOut.copyWith(...)` or like so:`instanceOfDevSmsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DevSmsOutCWProxy get copyWith => _$DevSmsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevSmsOut _$DevSmsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DevSmsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['at', 'phone', 'template', 'text']);
      final val = DevSmsOut(
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        phone: $checkedConvert('phone', (v) => v as String),
        template: $checkedConvert('template', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DevSmsOutToJson(DevSmsOut instance) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'phone': instance.phone,
  'template': instance.template,
  'text': instance.text,
};
