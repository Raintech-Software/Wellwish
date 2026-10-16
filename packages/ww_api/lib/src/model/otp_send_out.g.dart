// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_send_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpSendOutCWProxy {
  OtpSendOut expiresInSeconds(int expiresInSeconds);

  OtpSendOut resendAfterSeconds(int resendAfterSeconds);

  OtpSendOut length(int length);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpSendOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpSendOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpSendOut call({int expiresInSeconds, int resendAfterSeconds, int length});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpSendOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpSendOut.copyWith.fieldName(...)`
class _$OtpSendOutCWProxyImpl implements _$OtpSendOutCWProxy {
  const _$OtpSendOutCWProxyImpl(this._value);

  final OtpSendOut _value;

  @override
  OtpSendOut expiresInSeconds(int expiresInSeconds) =>
      this(expiresInSeconds: expiresInSeconds);

  @override
  OtpSendOut resendAfterSeconds(int resendAfterSeconds) =>
      this(resendAfterSeconds: resendAfterSeconds);

  @override
  OtpSendOut length(int length) => this(length: length);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpSendOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpSendOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpSendOut call({
    Object? expiresInSeconds = const $CopyWithPlaceholder(),
    Object? resendAfterSeconds = const $CopyWithPlaceholder(),
    Object? length = const $CopyWithPlaceholder(),
  }) {
    return OtpSendOut(
      expiresInSeconds: expiresInSeconds == const $CopyWithPlaceholder()
          ? _value.expiresInSeconds
          // ignore: cast_nullable_to_non_nullable
          : expiresInSeconds as int,
      resendAfterSeconds: resendAfterSeconds == const $CopyWithPlaceholder()
          ? _value.resendAfterSeconds
          // ignore: cast_nullable_to_non_nullable
          : resendAfterSeconds as int,
      length: length == const $CopyWithPlaceholder()
          ? _value.length
          // ignore: cast_nullable_to_non_nullable
          : length as int,
    );
  }
}

extension $OtpSendOutCopyWith on OtpSendOut {
  /// Returns a callable class that can be used as follows: `instanceOfOtpSendOut.copyWith(...)` or like so:`instanceOfOtpSendOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpSendOutCWProxy get copyWith => _$OtpSendOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpSendOut _$OtpSendOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'OtpSendOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['expiresInSeconds', 'resendAfterSeconds', 'length'],
    );
    final val = OtpSendOut(
      expiresInSeconds: $checkedConvert(
        'expiresInSeconds',
        (v) => (v as num).toInt(),
      ),
      resendAfterSeconds: $checkedConvert(
        'resendAfterSeconds',
        (v) => (v as num).toInt(),
      ),
      length: $checkedConvert('length', (v) => (v as num).toInt()),
    );
    return val;
  },
);

Map<String, dynamic> _$OtpSendOutToJson(OtpSendOut instance) =>
    <String, dynamic>{
      'expiresInSeconds': instance.expiresInSeconds,
      'resendAfterSeconds': instance.resendAfterSeconds,
      'length': instance.length,
    };
