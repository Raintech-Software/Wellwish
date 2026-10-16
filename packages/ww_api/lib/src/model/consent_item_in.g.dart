// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_item_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConsentItemInCWProxy {
  ConsentItemIn type(ConsentItemInTypeEnum type);

  ConsentItemIn version(String version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentItemIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentItemIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentItemIn call({ConsentItemInTypeEnum type, String version});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConsentItemIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConsentItemIn.copyWith.fieldName(...)`
class _$ConsentItemInCWProxyImpl implements _$ConsentItemInCWProxy {
  const _$ConsentItemInCWProxyImpl(this._value);

  final ConsentItemIn _value;

  @override
  ConsentItemIn type(ConsentItemInTypeEnum type) => this(type: type);

  @override
  ConsentItemIn version(String version) => this(version: version);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentItemIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentItemIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentItemIn call({
    Object? type = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return ConsentItemIn(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as ConsentItemInTypeEnum,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String,
    );
  }
}

extension $ConsentItemInCopyWith on ConsentItemIn {
  /// Returns a callable class that can be used as follows: `instanceOfConsentItemIn.copyWith(...)` or like so:`instanceOfConsentItemIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConsentItemInCWProxy get copyWith => _$ConsentItemInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentItemIn _$ConsentItemInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsentItemIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type', 'version']);
      final val = ConsentItemIn(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$ConsentItemInTypeEnumEnumMap, v),
        ),
        version: $checkedConvert('version', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ConsentItemInToJson(ConsentItemIn instance) =>
    <String, dynamic>{
      'type': _$ConsentItemInTypeEnumEnumMap[instance.type]!,
      'version': instance.version,
    };

const _$ConsentItemInTypeEnumEnumMap = {
  ConsentItemInTypeEnum.TERMS: 'TERMS',
  ConsentItemInTypeEnum.PRIVACY: 'PRIVACY',
  ConsentItemInTypeEnum.HEALTH_DATA: 'HEALTH_DATA',
  ConsentItemInTypeEnum.PARTNER_TERMS: 'PARTNER_TERMS',
};
