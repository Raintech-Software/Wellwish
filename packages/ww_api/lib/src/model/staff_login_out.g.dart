// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_login_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffLoginOutCWProxy {
  StaffLoginOut step(StaffLoginOutStepEnum step);

  StaffLoginOut challengeToken(String? challengeToken);

  StaffLoginOut otpauthUri(String? otpauthUri);

  StaffLoginOut secret(String? secret);

  StaffLoginOut signedIn(StaffTokenOut? signedIn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffLoginOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffLoginOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffLoginOut call({
    StaffLoginOutStepEnum step,
    String? challengeToken,
    String? otpauthUri,
    String? secret,
    StaffTokenOut? signedIn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffLoginOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffLoginOut.copyWith.fieldName(...)`
class _$StaffLoginOutCWProxyImpl implements _$StaffLoginOutCWProxy {
  const _$StaffLoginOutCWProxyImpl(this._value);

  final StaffLoginOut _value;

  @override
  StaffLoginOut step(StaffLoginOutStepEnum step) => this(step: step);

  @override
  StaffLoginOut challengeToken(String? challengeToken) =>
      this(challengeToken: challengeToken);

  @override
  StaffLoginOut otpauthUri(String? otpauthUri) => this(otpauthUri: otpauthUri);

  @override
  StaffLoginOut secret(String? secret) => this(secret: secret);

  @override
  StaffLoginOut signedIn(StaffTokenOut? signedIn) => this(signedIn: signedIn);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffLoginOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffLoginOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffLoginOut call({
    Object? step = const $CopyWithPlaceholder(),
    Object? challengeToken = const $CopyWithPlaceholder(),
    Object? otpauthUri = const $CopyWithPlaceholder(),
    Object? secret = const $CopyWithPlaceholder(),
    Object? signedIn = const $CopyWithPlaceholder(),
  }) {
    return StaffLoginOut(
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as StaffLoginOutStepEnum,
      challengeToken: challengeToken == const $CopyWithPlaceholder()
          ? _value.challengeToken
          // ignore: cast_nullable_to_non_nullable
          : challengeToken as String?,
      otpauthUri: otpauthUri == const $CopyWithPlaceholder()
          ? _value.otpauthUri
          // ignore: cast_nullable_to_non_nullable
          : otpauthUri as String?,
      secret: secret == const $CopyWithPlaceholder()
          ? _value.secret
          // ignore: cast_nullable_to_non_nullable
          : secret as String?,
      signedIn: signedIn == const $CopyWithPlaceholder()
          ? _value.signedIn
          // ignore: cast_nullable_to_non_nullable
          : signedIn as StaffTokenOut?,
    );
  }
}

extension $StaffLoginOutCopyWith on StaffLoginOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffLoginOut.copyWith(...)` or like so:`instanceOfStaffLoginOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffLoginOutCWProxy get copyWith => _$StaffLoginOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffLoginOut _$StaffLoginOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffLoginOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['step']);
      final val = StaffLoginOut(
        step: $checkedConvert(
          'step',
          (v) => $enumDecode(_$StaffLoginOutStepEnumEnumMap, v),
        ),
        challengeToken: $checkedConvert(
          'challengeToken',
          (v) => v as String? ?? '',
        ),
        otpauthUri: $checkedConvert('otpauthUri', (v) => v as String?),
        secret: $checkedConvert('secret', (v) => v as String?),
        signedIn: $checkedConvert(
          'signedIn',
          (v) => v == null
              ? null
              : StaffTokenOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffLoginOutToJson(StaffLoginOut instance) =>
    <String, dynamic>{
      'step': _$StaffLoginOutStepEnumEnumMap[instance.step]!,
      'challengeToken': ?instance.challengeToken,
      'otpauthUri': ?instance.otpauthUri,
      'secret': ?instance.secret,
      'signedIn': ?instance.signedIn?.toJson(),
    };

const _$StaffLoginOutStepEnumEnumMap = {
  StaffLoginOutStepEnum.TOTP_SETUP: 'TOTP_SETUP',
  StaffLoginOutStepEnum.TOTP: 'TOTP',
  StaffLoginOutStepEnum.SIGNED_IN: 'SIGNED_IN',
};
