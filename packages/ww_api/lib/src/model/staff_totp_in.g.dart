// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_totp_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffTotpInCWProxy {
  StaffTotpIn challengeToken(String challengeToken);

  StaffTotpIn code(String code);

  StaffTotpIn trustBrowser(bool? trustBrowser);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffTotpIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffTotpIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffTotpIn call({String challengeToken, String code, bool? trustBrowser});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffTotpIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffTotpIn.copyWith.fieldName(...)`
class _$StaffTotpInCWProxyImpl implements _$StaffTotpInCWProxy {
  const _$StaffTotpInCWProxyImpl(this._value);

  final StaffTotpIn _value;

  @override
  StaffTotpIn challengeToken(String challengeToken) =>
      this(challengeToken: challengeToken);

  @override
  StaffTotpIn code(String code) => this(code: code);

  @override
  StaffTotpIn trustBrowser(bool? trustBrowser) =>
      this(trustBrowser: trustBrowser);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffTotpIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffTotpIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffTotpIn call({
    Object? challengeToken = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? trustBrowser = const $CopyWithPlaceholder(),
  }) {
    return StaffTotpIn(
      challengeToken: challengeToken == const $CopyWithPlaceholder()
          ? _value.challengeToken
          // ignore: cast_nullable_to_non_nullable
          : challengeToken as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      trustBrowser: trustBrowser == const $CopyWithPlaceholder()
          ? _value.trustBrowser
          // ignore: cast_nullable_to_non_nullable
          : trustBrowser as bool?,
    );
  }
}

extension $StaffTotpInCopyWith on StaffTotpIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffTotpIn.copyWith(...)` or like so:`instanceOfStaffTotpIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffTotpInCWProxy get copyWith => _$StaffTotpInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffTotpIn _$StaffTotpInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'StaffTotpIn',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['challengeToken', 'code']);
    final val = StaffTotpIn(
      challengeToken: $checkedConvert('challengeToken', (v) => v as String),
      code: $checkedConvert('code', (v) => v as String),
      trustBrowser: $checkedConvert('trustBrowser', (v) => v as bool? ?? false),
    );
    return val;
  },
);

Map<String, dynamic> _$StaffTotpInToJson(StaffTotpIn instance) =>
    <String, dynamic>{
      'challengeToken': instance.challengeToken,
      'code': instance.code,
      'trustBrowser': ?instance.trustBrowser,
    };
