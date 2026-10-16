// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_send_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OtpSendInCWProxy {
  OtpSendIn phone(String phone);

  OtpSendIn purpose(OtpSendInPurposeEnum purpose);

  OtpSendIn deviceId(String deviceId);

  OtpSendIn appHash(String? appHash);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpSendIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpSendIn(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpSendIn call({
    String phone,
    OtpSendInPurposeEnum purpose,
    String deviceId,
    String? appHash,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOtpSendIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOtpSendIn.copyWith.fieldName(...)`
class _$OtpSendInCWProxyImpl implements _$OtpSendInCWProxy {
  const _$OtpSendInCWProxyImpl(this._value);

  final OtpSendIn _value;

  @override
  OtpSendIn phone(String phone) => this(phone: phone);

  @override
  OtpSendIn purpose(OtpSendInPurposeEnum purpose) => this(purpose: purpose);

  @override
  OtpSendIn deviceId(String deviceId) => this(deviceId: deviceId);

  @override
  OtpSendIn appHash(String? appHash) => this(appHash: appHash);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OtpSendIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OtpSendIn(...).copyWith(id: 12, name: "My name")
  /// ````
  OtpSendIn call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? purpose = const $CopyWithPlaceholder(),
    Object? deviceId = const $CopyWithPlaceholder(),
    Object? appHash = const $CopyWithPlaceholder(),
  }) {
    return OtpSendIn(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as OtpSendInPurposeEnum,
      deviceId: deviceId == const $CopyWithPlaceholder()
          ? _value.deviceId
          // ignore: cast_nullable_to_non_nullable
          : deviceId as String,
      appHash: appHash == const $CopyWithPlaceholder()
          ? _value.appHash
          // ignore: cast_nullable_to_non_nullable
          : appHash as String?,
    );
  }
}

extension $OtpSendInCopyWith on OtpSendIn {
  /// Returns a callable class that can be used as follows: `instanceOfOtpSendIn.copyWith(...)` or like so:`instanceOfOtpSendIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OtpSendInCWProxy get copyWith => _$OtpSendInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpSendIn _$OtpSendInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OtpSendIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone', 'purpose', 'deviceId']);
      final val = OtpSendIn(
        phone: $checkedConvert('phone', (v) => v as String),
        purpose: $checkedConvert(
          'purpose',
          (v) => $enumDecode(_$OtpSendInPurposeEnumEnumMap, v),
        ),
        deviceId: $checkedConvert('deviceId', (v) => v as String),
        appHash: $checkedConvert('appHash', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$OtpSendInToJson(OtpSendIn instance) => <String, dynamic>{
  'phone': instance.phone,
  'purpose': _$OtpSendInPurposeEnumEnumMap[instance.purpose]!,
  'deviceId': instance.deviceId,
  'appHash': ?instance.appHash,
};

const _$OtpSendInPurposeEnumEnumMap = {
  OtpSendInPurposeEnum.login: 'login',
  OtpSendInPurposeEnum.partnerPrimary: 'partner_primary',
};
