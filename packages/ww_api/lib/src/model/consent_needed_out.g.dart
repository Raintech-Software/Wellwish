// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_needed_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConsentNeededOutCWProxy {
  ConsentNeededOut type(ConsentNeededOutTypeEnum type);

  ConsentNeededOut version(String version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentNeededOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentNeededOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentNeededOut call({ConsentNeededOutTypeEnum type, String version});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConsentNeededOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConsentNeededOut.copyWith.fieldName(...)`
class _$ConsentNeededOutCWProxyImpl implements _$ConsentNeededOutCWProxy {
  const _$ConsentNeededOutCWProxyImpl(this._value);

  final ConsentNeededOut _value;

  @override
  ConsentNeededOut type(ConsentNeededOutTypeEnum type) => this(type: type);

  @override
  ConsentNeededOut version(String version) => this(version: version);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentNeededOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentNeededOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentNeededOut call({
    Object? type = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return ConsentNeededOut(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as ConsentNeededOutTypeEnum,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as String,
    );
  }
}

extension $ConsentNeededOutCopyWith on ConsentNeededOut {
  /// Returns a callable class that can be used as follows: `instanceOfConsentNeededOut.copyWith(...)` or like so:`instanceOfConsentNeededOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConsentNeededOutCWProxy get copyWith => _$ConsentNeededOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentNeededOut _$ConsentNeededOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsentNeededOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type', 'version']);
      final val = ConsentNeededOut(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$ConsentNeededOutTypeEnumEnumMap, v),
        ),
        version: $checkedConvert('version', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ConsentNeededOutToJson(ConsentNeededOut instance) =>
    <String, dynamic>{
      'type': _$ConsentNeededOutTypeEnumEnumMap[instance.type]!,
      'version': instance.version,
    };

const _$ConsentNeededOutTypeEnumEnumMap = {
  ConsentNeededOutTypeEnum.TERMS: 'TERMS',
  ConsentNeededOutTypeEnum.PRIVACY: 'PRIVACY',
  ConsentNeededOutTypeEnum.HEALTH_DATA: 'HEALTH_DATA',
  ConsentNeededOutTypeEnum.PARTNER_TERMS: 'PARTNER_TERMS',
};
