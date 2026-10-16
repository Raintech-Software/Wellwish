// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway_keys_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GatewayKeysOutCWProxy {
  GatewayKeysOut source_(String source_);

  GatewayKeysOut keyId(String keyId);

  GatewayKeysOut mode(String mode);

  GatewayKeysOut keySecretSet(bool keySecretSet);

  GatewayKeysOut keySecretLast4(String keySecretLast4);

  GatewayKeysOut webhookSecretSet(bool webhookSecretSet);

  GatewayKeysOut webhookSecretLast4(String webhookSecretLast4);

  GatewayKeysOut webhookPath(String webhookPath);

  GatewayKeysOut updatedAt(DateTime? updatedAt);

  GatewayKeysOut updatedBy(String updatedBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GatewayKeysOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GatewayKeysOut(...).copyWith(id: 12, name: "My name")
  /// ````
  GatewayKeysOut call({
    String source_,
    String keyId,
    String mode,
    bool keySecretSet,
    String keySecretLast4,
    bool webhookSecretSet,
    String webhookSecretLast4,
    String webhookPath,
    DateTime? updatedAt,
    String updatedBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGatewayKeysOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGatewayKeysOut.copyWith.fieldName(...)`
class _$GatewayKeysOutCWProxyImpl implements _$GatewayKeysOutCWProxy {
  const _$GatewayKeysOutCWProxyImpl(this._value);

  final GatewayKeysOut _value;

  @override
  GatewayKeysOut source_(String source_) => this(source_: source_);

  @override
  GatewayKeysOut keyId(String keyId) => this(keyId: keyId);

  @override
  GatewayKeysOut mode(String mode) => this(mode: mode);

  @override
  GatewayKeysOut keySecretSet(bool keySecretSet) =>
      this(keySecretSet: keySecretSet);

  @override
  GatewayKeysOut keySecretLast4(String keySecretLast4) =>
      this(keySecretLast4: keySecretLast4);

  @override
  GatewayKeysOut webhookSecretSet(bool webhookSecretSet) =>
      this(webhookSecretSet: webhookSecretSet);

  @override
  GatewayKeysOut webhookSecretLast4(String webhookSecretLast4) =>
      this(webhookSecretLast4: webhookSecretLast4);

  @override
  GatewayKeysOut webhookPath(String webhookPath) =>
      this(webhookPath: webhookPath);

  @override
  GatewayKeysOut updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override
  GatewayKeysOut updatedBy(String updatedBy) => this(updatedBy: updatedBy);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GatewayKeysOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GatewayKeysOut(...).copyWith(id: 12, name: "My name")
  /// ````
  GatewayKeysOut call({
    Object? source_ = const $CopyWithPlaceholder(),
    Object? keyId = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? keySecretSet = const $CopyWithPlaceholder(),
    Object? keySecretLast4 = const $CopyWithPlaceholder(),
    Object? webhookSecretSet = const $CopyWithPlaceholder(),
    Object? webhookSecretLast4 = const $CopyWithPlaceholder(),
    Object? webhookPath = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
    Object? updatedBy = const $CopyWithPlaceholder(),
  }) {
    return GatewayKeysOut(
      source_: source_ == const $CopyWithPlaceholder()
          ? _value.source_
          // ignore: cast_nullable_to_non_nullable
          : source_ as String,
      keyId: keyId == const $CopyWithPlaceholder()
          ? _value.keyId
          // ignore: cast_nullable_to_non_nullable
          : keyId as String,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as String,
      keySecretSet: keySecretSet == const $CopyWithPlaceholder()
          ? _value.keySecretSet
          // ignore: cast_nullable_to_non_nullable
          : keySecretSet as bool,
      keySecretLast4: keySecretLast4 == const $CopyWithPlaceholder()
          ? _value.keySecretLast4
          // ignore: cast_nullable_to_non_nullable
          : keySecretLast4 as String,
      webhookSecretSet: webhookSecretSet == const $CopyWithPlaceholder()
          ? _value.webhookSecretSet
          // ignore: cast_nullable_to_non_nullable
          : webhookSecretSet as bool,
      webhookSecretLast4: webhookSecretLast4 == const $CopyWithPlaceholder()
          ? _value.webhookSecretLast4
          // ignore: cast_nullable_to_non_nullable
          : webhookSecretLast4 as String,
      webhookPath: webhookPath == const $CopyWithPlaceholder()
          ? _value.webhookPath
          // ignore: cast_nullable_to_non_nullable
          : webhookPath as String,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
      updatedBy: updatedBy == const $CopyWithPlaceholder()
          ? _value.updatedBy
          // ignore: cast_nullable_to_non_nullable
          : updatedBy as String,
    );
  }
}

extension $GatewayKeysOutCopyWith on GatewayKeysOut {
  /// Returns a callable class that can be used as follows: `instanceOfGatewayKeysOut.copyWith(...)` or like so:`instanceOfGatewayKeysOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GatewayKeysOutCWProxy get copyWith => _$GatewayKeysOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GatewayKeysOut _$GatewayKeysOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GatewayKeysOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'source',
          'keyId',
          'mode',
          'keySecretSet',
          'keySecretLast4',
          'webhookSecretSet',
          'webhookSecretLast4',
          'webhookPath',
          'updatedAt',
          'updatedBy',
        ],
      );
      final val = GatewayKeysOut(
        source_: $checkedConvert('source', (v) => v as String),
        keyId: $checkedConvert('keyId', (v) => v as String),
        mode: $checkedConvert('mode', (v) => v as String),
        keySecretSet: $checkedConvert('keySecretSet', (v) => v as bool),
        keySecretLast4: $checkedConvert('keySecretLast4', (v) => v as String),
        webhookSecretSet: $checkedConvert('webhookSecretSet', (v) => v as bool),
        webhookSecretLast4: $checkedConvert(
          'webhookSecretLast4',
          (v) => v as String,
        ),
        webhookPath: $checkedConvert('webhookPath', (v) => v as String),
        updatedAt: $checkedConvert(
          'updatedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        updatedBy: $checkedConvert('updatedBy', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'source_': 'source'});

Map<String, dynamic> _$GatewayKeysOutToJson(GatewayKeysOut instance) =>
    <String, dynamic>{
      'source': instance.source_,
      'keyId': instance.keyId,
      'mode': instance.mode,
      'keySecretSet': instance.keySecretSet,
      'keySecretLast4': instance.keySecretLast4,
      'webhookSecretSet': instance.webhookSecretSet,
      'webhookSecretLast4': instance.webhookSecretLast4,
      'webhookPath': instance.webhookPath,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updatedBy': instance.updatedBy,
    };
