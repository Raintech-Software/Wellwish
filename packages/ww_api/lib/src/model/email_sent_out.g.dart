// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_sent_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EmailSentOutCWProxy {
  EmailSentOut resendAfterSeconds(int resendAfterSeconds);

  EmailSentOut expiresInSeconds(int expiresInSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmailSentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmailSentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  EmailSentOut call({int resendAfterSeconds, int expiresInSeconds});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEmailSentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEmailSentOut.copyWith.fieldName(...)`
class _$EmailSentOutCWProxyImpl implements _$EmailSentOutCWProxy {
  const _$EmailSentOutCWProxyImpl(this._value);

  final EmailSentOut _value;

  @override
  EmailSentOut resendAfterSeconds(int resendAfterSeconds) =>
      this(resendAfterSeconds: resendAfterSeconds);

  @override
  EmailSentOut expiresInSeconds(int expiresInSeconds) =>
      this(expiresInSeconds: expiresInSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmailSentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmailSentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  EmailSentOut call({
    Object? resendAfterSeconds = const $CopyWithPlaceholder(),
    Object? expiresInSeconds = const $CopyWithPlaceholder(),
  }) {
    return EmailSentOut(
      resendAfterSeconds: resendAfterSeconds == const $CopyWithPlaceholder()
          ? _value.resendAfterSeconds
          // ignore: cast_nullable_to_non_nullable
          : resendAfterSeconds as int,
      expiresInSeconds: expiresInSeconds == const $CopyWithPlaceholder()
          ? _value.expiresInSeconds
          // ignore: cast_nullable_to_non_nullable
          : expiresInSeconds as int,
    );
  }
}

extension $EmailSentOutCopyWith on EmailSentOut {
  /// Returns a callable class that can be used as follows: `instanceOfEmailSentOut.copyWith(...)` or like so:`instanceOfEmailSentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EmailSentOutCWProxy get copyWith => _$EmailSentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailSentOut _$EmailSentOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EmailSentOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['resendAfterSeconds', 'expiresInSeconds'],
      );
      final val = EmailSentOut(
        resendAfterSeconds: $checkedConvert(
          'resendAfterSeconds',
          (v) => (v as num).toInt(),
        ),
        expiresInSeconds: $checkedConvert(
          'expiresInSeconds',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$EmailSentOutToJson(EmailSentOut instance) =>
    <String, dynamic>{
      'resendAfterSeconds': instance.resendAfterSeconds,
      'expiresInSeconds': instance.expiresInSeconds,
    };
