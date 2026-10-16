// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_outbox_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DevOutboxOutCWProxy {
  DevOutboxOut sms(List<DevSmsOut> sms);

  DevOutboxOut email(List<DevMailOut> email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevOutboxOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevOutboxOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevOutboxOut call({List<DevSmsOut> sms, List<DevMailOut> email});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDevOutboxOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDevOutboxOut.copyWith.fieldName(...)`
class _$DevOutboxOutCWProxyImpl implements _$DevOutboxOutCWProxy {
  const _$DevOutboxOutCWProxyImpl(this._value);

  final DevOutboxOut _value;

  @override
  DevOutboxOut sms(List<DevSmsOut> sms) => this(sms: sms);

  @override
  DevOutboxOut email(List<DevMailOut> email) => this(email: email);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DevOutboxOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DevOutboxOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DevOutboxOut call({
    Object? sms = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
  }) {
    return DevOutboxOut(
      sms: sms == const $CopyWithPlaceholder()
          ? _value.sms
          // ignore: cast_nullable_to_non_nullable
          : sms as List<DevSmsOut>,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as List<DevMailOut>,
    );
  }
}

extension $DevOutboxOutCopyWith on DevOutboxOut {
  /// Returns a callable class that can be used as follows: `instanceOfDevOutboxOut.copyWith(...)` or like so:`instanceOfDevOutboxOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DevOutboxOutCWProxy get copyWith => _$DevOutboxOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevOutboxOut _$DevOutboxOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DevOutboxOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sms', 'email']);
      final val = DevOutboxOut(
        sms: $checkedConvert(
          'sms',
          (v) => (v as List<dynamic>)
              .map((e) => DevSmsOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        email: $checkedConvert(
          'email',
          (v) => (v as List<dynamic>)
              .map((e) => DevMailOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DevOutboxOutToJson(DevOutboxOut instance) =>
    <String, dynamic>{
      'sms': instance.sms.map((e) => e.toJson()).toList(),
      'email': instance.email.map((e) => e.toJson()).toList(),
    };
