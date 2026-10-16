// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TokenOutCWProxy {
  TokenOut accessToken(String accessToken);

  TokenOut refreshToken(String refreshToken);

  TokenOut expiresIn(int expiresIn);

  TokenOut tokenType(String? tokenType);

  TokenOut isNewUser(bool? isNewUser);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TokenOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TokenOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TokenOut call({
    String accessToken,
    String refreshToken,
    int expiresIn,
    String? tokenType,
    bool? isNewUser,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTokenOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTokenOut.copyWith.fieldName(...)`
class _$TokenOutCWProxyImpl implements _$TokenOutCWProxy {
  const _$TokenOutCWProxyImpl(this._value);

  final TokenOut _value;

  @override
  TokenOut accessToken(String accessToken) => this(accessToken: accessToken);

  @override
  TokenOut refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  TokenOut expiresIn(int expiresIn) => this(expiresIn: expiresIn);

  @override
  TokenOut tokenType(String? tokenType) => this(tokenType: tokenType);

  @override
  TokenOut isNewUser(bool? isNewUser) => this(isNewUser: isNewUser);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TokenOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TokenOut(...).copyWith(id: 12, name: "My name")
  /// ````
  TokenOut call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? tokenType = const $CopyWithPlaceholder(),
    Object? isNewUser = const $CopyWithPlaceholder(),
  }) {
    return TokenOut(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String,
      expiresIn: expiresIn == const $CopyWithPlaceholder()
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as int,
      tokenType: tokenType == const $CopyWithPlaceholder()
          ? _value.tokenType
          // ignore: cast_nullable_to_non_nullable
          : tokenType as String?,
      isNewUser: isNewUser == const $CopyWithPlaceholder()
          ? _value.isNewUser
          // ignore: cast_nullable_to_non_nullable
          : isNewUser as bool?,
    );
  }
}

extension $TokenOutCopyWith on TokenOut {
  /// Returns a callable class that can be used as follows: `instanceOfTokenOut.copyWith(...)` or like so:`instanceOfTokenOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TokenOutCWProxy get copyWith => _$TokenOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenOut _$TokenOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'TokenOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['accessToken', 'refreshToken', 'expiresIn'],
    );
    final val = TokenOut(
      accessToken: $checkedConvert('accessToken', (v) => v as String),
      refreshToken: $checkedConvert('refreshToken', (v) => v as String),
      expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
      tokenType: $checkedConvert('tokenType', (v) => v as String? ?? 'Bearer'),
      isNewUser: $checkedConvert('isNewUser', (v) => v as bool? ?? false),
    );
    return val;
  },
);

Map<String, dynamic> _$TokenOutToJson(TokenOut instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'expiresIn': instance.expiresIn,
  'tokenType': ?instance.tokenType,
  'isNewUser': ?instance.isNewUser,
};
