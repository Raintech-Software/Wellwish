// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpVerifyInCWProxy {
  OtpVerifyIn phone(String phone);

  OtpVerifyIn otp(String otp);

  OtpVerifyIn purpose(OtpVerifyInPurposeEnum purpose);

  OtpVerifyIn deviceId(String deviceId);

  OtpVerifyIn googleLinkToken(String? googleLinkToken);

  OtpVerifyIn language(OtpVerifyInLanguageEnum? language);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpVerifyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpVerifyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpVerifyIn call({
    String phone,
    String otp,
    OtpVerifyInPurposeEnum purpose,
    String deviceId,
    String? googleLinkToken,
    OtpVerifyInLanguageEnum? language,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpVerifyIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpVerifyIn.copyWith.fieldName(...)`
class _$OtpVerifyInCWProxyImpl implements _$OtpVerifyInCWProxy {
  const _$OtpVerifyInCWProxyImpl(this._value);

  final OtpVerifyIn _value;

  @override
  OtpVerifyIn phone(String phone) => this(phone: phone);

  @override
  OtpVerifyIn otp(String otp) => this(otp: otp);

  @override
  OtpVerifyIn purpose(OtpVerifyInPurposeEnum purpose) => this(purpose: purpose);

  @override
  OtpVerifyIn deviceId(String deviceId) => this(deviceId: deviceId);

  @override
  OtpVerifyIn googleLinkToken(String? googleLinkToken) =>
      this(googleLinkToken: googleLinkToken);

  @override
  OtpVerifyIn language(OtpVerifyInLanguageEnum? language) =>
      this(language: language);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpVerifyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpVerifyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpVerifyIn call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? otp = const $CopyWithPlaceholder(),
    Object? purpose = const $CopyWithPlaceholder(),
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? googleLinkToken = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
  }) {
    return OtpVerifyIn(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      otp: otp == const $CopyWithPlaceholder()
          ? _value.otp
          // ignore: cast_nullable_to_non_nullable
          : otp as String,
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as OtpVerifyInPurposeEnum,
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
      googleLinkToken: googleLinkToken == const $CopyWithPlaceholder()
          ? _value.googleLinkToken
          // ignore: cast_nullable_to_non_nullable
          : googleLinkToken as String?,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as OtpVerifyInLanguageEnum?,
    );
  }
}

extension $OtpVerifyInCopyWith on OtpVerifyIn {
  /// Returns a callable class that can be used as follows: `instanceOfOtpVerifyIn.copyWith(...)` or like so:`instanceOfOtpVerifyIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpVerifyInCWProxy get copyWith => _$OtpVerifyInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerifyIn _$OtpVerifyInFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('OtpVerifyIn', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['phone', 'otp', 'purpose', 'deviceId']);
  final val = OtpVerifyIn(
    phone: $checkedConvert('phone', (v) => v as String),
    otp: $checkedConvert('otp', (v) => v as String),
    purpose: $checkedConvert(
      'purpose',
      (v) => $enumDecode(_$OtpVerifyInPurposeEnumEnumMap, v),
    ),
    deviceId: $checkedConvert('deviceId', (v) => v as String),
    googleLinkToken: $checkedConvert('googleLinkToken', (v) => v as String?),
    language: $checkedConvert(
      'language',
      (v) => $enumDecodeNullable(_$OtpVerifyInLanguageEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$OtpVerifyInToJson(OtpVerifyIn instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp': instance.otp,
      'purpose': _$OtpVerifyInPurposeEnumEnumMap[instance.purpose]!,
      'deviceId': instance.deviceId,
      'googleLinkToken': ?instance.googleLinkToken,
      'language': ?_$OtpVerifyInLanguageEnumEnumMap[instance.language],
    };

const _$OtpVerifyInPurposeEnumEnumMap = {
  OtpVerifyInPurposeEnum.login: 'login',
  OtpVerifyInPurposeEnum.partnerPrimary: 'partner_primary',
};

const _$OtpVerifyInLanguageEnumEnumMap = {
  OtpVerifyInLanguageEnum.en: 'en',
  OtpVerifyInLanguageEnum.hi: 'hi',
  OtpVerifyInLanguageEnum.or: 'or',
};
