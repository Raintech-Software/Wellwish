// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway_keys_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GatewayKeysInCWProxy {
  GatewayKeysIn keyId(String keyId);

  GatewayKeysIn keySecret(String? keySecret);

  GatewayKeysIn webhookSecret(String? webhookSecret);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GatewayKeysIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GatewayKeysIn(...).copyWith(id: 12, name: "My name")
  /// ````
  GatewayKeysIn call({String keyId, String? keySecret, String? webhookSecret});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGatewayKeysIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGatewayKeysIn.copyWith.fieldName(...)`
class _$GatewayKeysInCWProxyImpl implements _$GatewayKeysInCWProxy {
  const _$GatewayKeysInCWProxyImpl(this._value);

  final GatewayKeysIn _value;

  @override
  GatewayKeysIn keyId(String keyId) => this(keyId: keyId);

  @override
  GatewayKeysIn keySecret(String? keySecret) => this(keySecret: keySecret);

  @override
  GatewayKeysIn webhookSecret(String? webhookSecret) =>
      this(webhookSecret: webhookSecret);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GatewayKeysIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GatewayKeysIn(...).copyWith(id: 12, name: "My name")
  /// ````
  GatewayKeysIn call({
    Object? keyId = const $CopyWithPlaceholder(),
    Object? keySecret = const $CopyWithPlaceholder(),
    Object? webhookSecret = const $CopyWithPlaceholder(),
  }) {
    return GatewayKeysIn(
      keyId: keyId == const $CopyWithPlaceholder()
          ? _value.keyId
          // ignore: cast_nullable_to_non_nullable
          : keyId as String,
      keySecret: keySecret == const $CopyWithPlaceholder()
          ? _value.keySecret
          // ignore: cast_nullable_to_non_nullable
          : keySecret as String?,
      webhookSecret: webhookSecret == const $CopyWithPlaceholder()
          ? _value.webhookSecret
          // ignore: cast_nullable_to_non_nullable
          : webhookSecret as String?,
    );
  }
}

extension $GatewayKeysInCopyWith on GatewayKeysIn {
  /// Returns a callable class that can be used as follows: `instanceOfGatewayKeysIn.copyWith(...)` or like so:`instanceOfGatewayKeysIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GatewayKeysInCWProxy get copyWith => _$GatewayKeysInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatewayKeysIn _$GatewayKeysInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GatewayKeysIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['keyId']);
      final val = GatewayKeysIn(
        keyId: $checkedConvert('keyId', (v) => v as String),
        keySecret: $checkedConvert('keySecret', (v) => v as String? ?? ''),
        webhookSecret: $checkedConvert(
          'webhookSecret',
          (v) => v as String? ?? '',
        ),
      );
      return val;
    });

Map<String, dynamic> _$GatewayKeysInToJson(GatewayKeysIn instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'keySecret': ?instance.keySecret,
      'webhookSecret': ?instance.webhookSecret,
    };
