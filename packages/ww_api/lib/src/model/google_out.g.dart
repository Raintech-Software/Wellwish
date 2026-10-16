// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GoogleOutCWProxy {
  GoogleOut status(GoogleOutStatusEnum status);

  GoogleOut tokens(TokenOut? tokens);

  GoogleOut googleLinkToken(String? googleLinkToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoogleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoogleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  GoogleOut call({
    GoogleOutStatusEnum status,
    TokenOut? tokens,
    String? googleLinkToken,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGoogleOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGoogleOut.copyWith.fieldName(...)`
class _$GoogleOutCWProxyImpl implements _$GoogleOutCWProxy {
  const _$GoogleOutCWProxyImpl(this._value);

  final GoogleOut _value;

  @override
  GoogleOut status(GoogleOutStatusEnum status) => this(status: status);

  @override
  GoogleOut tokens(TokenOut? tokens) => this(tokens: tokens);

  @override
  GoogleOut googleLinkToken(String? googleLinkToken) =>
      this(googleLinkToken: googleLinkToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GoogleOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GoogleOut(...).copyWith(id: 12, name: "My name")
  /// ````
  GoogleOut call({
    Object? status = const $CopyWithPlaceholder(),
    Object? tokens = const $CopyWithPlaceholder(),
    Object? googleLinkToken = const $CopyWithPlaceholder(),
  }) {
    return GoogleOut(
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as GoogleOutStatusEnum,
      tokens: tokens == const $CopyWithPlaceholder()
          ? _value.tokens
          // ignore: cast_nullable_to_non_nullable
          : tokens as TokenOut?,
      googleLinkToken: googleLinkToken == const $CopyWithPlaceholder()
          ? _value.googleLinkToken
          // ignore: cast_nullable_to_non_nullable
          : googleLinkToken as String?,
    );
  }
}

extension $GoogleOutCopyWith on GoogleOut {
  /// Returns a callable class that can be used as follows: `instanceOfGoogleOut.copyWith(...)` or like so:`instanceOfGoogleOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GoogleOutCWProxy get copyWith => _$GoogleOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleOut _$GoogleOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GoogleOut',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['status']);
    final val = GoogleOut(
      status: $checkedConvert(
        'status',
        (v) => $enumDecode(_$GoogleOutStatusEnumEnumMap, v),
      ),
      tokens: $checkedConvert(
        'tokens',
        (v) => v == null ? null : TokenOut.fromJson(v as Map<String, dynamic>),
      ),
      googleLinkToken: $checkedConvert('googleLinkToken', (v) => v as String?),
    );
    return val;
  },
);

Map<String, dynamic> _$GoogleOutToJson(GoogleOut instance) => <String, dynamic>{
  'status': _$GoogleOutStatusEnumEnumMap[instance.status]!,
  'tokens': ?instance.tokens?.toJson(),
  'googleLinkToken': ?instance.googleLinkToken,
};

const _$GoogleOutStatusEnumEnumMap = {
  GoogleOutStatusEnum.LOGGED_IN: 'LOGGED_IN',
  GoogleOutStatusEnum.PHONE_REQUIRED: 'PHONE_REQUIRED',
};
