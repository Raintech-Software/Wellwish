// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_mail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DevMailOutCWProxy {
  DevMailOut at(DateTime at);

  DevMailOut to(String to);

  DevMailOut subject(String subject);

  DevMailOut text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevMailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevMailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevMailOut call({DateTime at, String to, String subject, String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDevMailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDevMailOut.copyWith.fieldName(...)`
class _$DevMailOutCWProxyImpl implements _$DevMailOutCWProxy {
  const _$DevMailOutCWProxyImpl(this._value);

  final DevMailOut _value;

  @override
  DevMailOut at(DateTime at) => this(at: at);

  @override
  DevMailOut to(String to) => this(to: to);

  @override
  DevMailOut subject(String subject) => this(subject: subject);

  @override
  DevMailOut text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevMailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevMailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevMailOut call({
    Object? at = const $CopyWithPlaceholder(),
    Object? to = const $CopyWithPlaceholder(),
    Object? subject = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
  }) {
    return DevMailOut(
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as String,
      subject: subject == const $CopyWithPlaceholder()
          ? _value.subject
          // ignore: cast_nullable_to_non_nullable
          : subject as String,
      text: text == const $CopyWithPlaceholder()
          ? _value.text
          // ignore: cast_nullable_to_non_nullable
          : text as String,
    );
  }
}

extension $DevMailOutCopyWith on DevMailOut {
  /// Returns a callable class that can be used as follows: `instanceOfDevMailOut.copyWith(...)` or like so:`instanceOfDevMailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DevMailOutCWProxy get copyWith => _$DevMailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevMailOut _$DevMailOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DevMailOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['at', 'to', 'subject', 'text']);
      final val = DevMailOut(
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        to: $checkedConvert('to', (v) => v as String),
        subject: $checkedConvert('subject', (v) => v as String),
        text: $checkedConvert('text', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DevMailOutToJson(DevMailOut instance) =>
    <String, dynamic>{
      'at': instance.at.toIso8601String(),
      'to': instance.to,
      'subject': instance.subject,
      'text': instance.text,
    };
