// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceInCWProxy {
  ServiceIn name(String name);

  ServiceIn nameHi(String? nameHi);

  ServiceIn nameOr(String? nameOr);

  ServiceIn description(String? description);

  ServiceIn descriptionHi(String? descriptionHi);

  ServiceIn descriptionOr(String? descriptionOr);

  ServiceIn partnerType(ServiceInPartnerTypeEnum partnerType);

  ServiceIn visitType(ServiceInVisitTypeEnum visitType);

  ServiceIn pricePaise(int pricePaise);

  ServiceIn bookingFeePaise(int bookingFeePaise);

  ServiceIn durationMin(int durationMin);

  ServiceIn docsRequired(bool? docsRequired);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceIn call({
    String name,
    String? nameHi,
    String? nameOr,
    String? description,
    String? descriptionHi,
    String? descriptionOr,
    ServiceInPartnerTypeEnum partnerType,
    ServiceInVisitTypeEnum visitType,
    int pricePaise,
    int bookingFeePaise,
    int durationMin,
    bool? docsRequired,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceIn.copyWith.fieldName(...)`
class _$ServiceInCWProxyImpl implements _$ServiceInCWProxy {
  const _$ServiceInCWProxyImpl(this._value);

  final ServiceIn _value;

  @override
  ServiceIn name(String name) => this(name: name);

  @override
  ServiceIn nameHi(String? nameHi) => this(nameHi: nameHi);

  @override
  ServiceIn nameOr(String? nameOr) => this(nameOr: nameOr);

  @override
  ServiceIn description(String? description) => this(description: description);

  @override
  ServiceIn descriptionHi(String? descriptionHi) =>
      this(descriptionHi: descriptionHi);

  @override
  ServiceIn descriptionOr(String? descriptionOr) =>
      this(descriptionOr: descriptionOr);

  @override
  ServiceIn partnerType(ServiceInPartnerTypeEnum partnerType) =>
      this(partnerType: partnerType);

  @override
  ServiceIn visitType(ServiceInVisitTypeEnum visitType) =>
      this(visitType: visitType);

  @override
  ServiceIn pricePaise(int pricePaise) => this(pricePaise: pricePaise);

  @override
  ServiceIn bookingFeePaise(int bookingFeePaise) =>
      this(bookingFeePaise: bookingFeePaise);

  @override
  ServiceIn durationMin(int durationMin) => this(durationMin: durationMin);

  @override
  ServiceIn docsRequired(bool? docsRequired) =>
      this(docsRequired: docsRequired);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceIn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? nameHi = const $CopyWithPlaceholder(),
    Object? nameOr = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
    Object? descriptionHi = const $CopyWithPlaceholder(),
    Object? descriptionOr = const $CopyWithPlaceholder(),
    Object? partnerType = const $CopyWithPlaceholder(),
    Object? visitType = const $CopyWithPlaceholder(),
    Object? pricePaise = const $CopyWithPlaceholder(),
    Object? bookingFeePaise = const $CopyWithPlaceholder(),
    Object? durationMin = const $CopyWithPlaceholder(),
    Object? docsRequired = const $CopyWithPlaceholder(),
  }) {
    return ServiceIn(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      nameHi: nameHi == const $CopyWithPlaceholder()
          ? _value.nameHi
          // ignore: cast_nullable_to_non_nullable
          : nameHi as String?,
      nameOr: nameOr == const $CopyWithPlaceholder()
          ? _value.nameOr
          // ignore: cast_nullable_to_non_nullable
          : nameOr as String?,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String?,
      descriptionHi: descriptionHi == const $CopyWithPlaceholder()
          ? _value.descriptionHi
          // ignore: cast_nullable_to_non_nullable
          : descriptionHi as String?,
      descriptionOr: descriptionOr == const $CopyWithPlaceholder()
          ? _value.descriptionOr
          // ignore: cast_nullable_to_non_nullable
          : descriptionOr as String?,
      partnerType: partnerType == const $CopyWithPlaceholder()
          ? _value.partnerType
          // ignore: cast_nullable_to_non_nullable
          : partnerType as ServiceInPartnerTypeEnum,
      visitType: visitType == const $CopyWithPlaceholder()
          ? _value.visitType
          // ignore: cast_nullable_to_non_nullable
          : visitType as ServiceInVisitTypeEnum,
      pricePaise: pricePaise == const $CopyWithPlaceholder()
          ? _value.pricePaise
          // ignore: cast_nullable_to_non_nullable
          : pricePaise as int,
      bookingFeePaise: bookingFeePaise == const $CopyWithPlaceholder()
          ? _value.bookingFeePaise
          // ignore: cast_nullable_to_non_nullable
          : bookingFeePaise as int,
      durationMin: durationMin == const $CopyWithPlaceholder()
          ? _value.durationMin
          // ignore: cast_nullable_to_non_nullable
          : durationMin as int,
      docsRequired: docsRequired == const $CopyWithPlaceholder()
          ? _value.docsRequired
          // ignore: cast_nullable_to_non_nullable
          : docsRequired as bool?,
    );
  }
}

extension $ServiceInCopyWith on ServiceIn {
  /// Returns a callable class that can be used as follows: `instanceOfServiceIn.copyWith(...)` or like so:`instanceOfServiceIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceInCWProxy get copyWith => _$ServiceInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceIn _$ServiceInFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('ServiceIn', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'name',
      'partnerType',
      'visitType',
      'pricePaise',
      'bookingFeePaise',
      'durationMin',
    ],
  );
  final val = ServiceIn(
    name: $checkedConvert('name', (v) => v as String),
    nameHi: $checkedConvert('nameHi', (v) => v as String? ?? ''),
    nameOr: $checkedConvert('nameOr', (v) => v as String? ?? ''),
    description: $checkedConvert('description', (v) => v as String? ?? ''),
    descriptionHi: $checkedConvert('descriptionHi', (v) => v as String? ?? ''),
    descriptionOr: $checkedConvert('descriptionOr', (v) => v as String? ?? ''),
    partnerType: $checkedConvert(
      'partnerType',
      (v) => $enumDecode(_$ServiceInPartnerTypeEnumEnumMap, v),
    ),
    visitType: $checkedConvert(
      'visitType',
      (v) => $enumDecode(_$ServiceInVisitTypeEnumEnumMap, v),
    ),
    pricePaise: $checkedConvert('pricePaise', (v) => (v as num).toInt()),
    bookingFeePaise: $checkedConvert(
      'bookingFeePaise',
      (v) => (v as num).toInt(),
    ),
    durationMin: $checkedConvert('durationMin', (v) => (v as num).toInt()),
    docsRequired: $checkedConvert('docsRequired', (v) => v as bool? ?? false),
  );
  return val;
});

Map<String, dynamic> _$ServiceInToJson(ServiceIn instance) => <String, dynamic>{
  'name': instance.name,
  'nameHi': ?instance.nameHi,
  'nameOr': ?instance.nameOr,
  'description': ?instance.description,
  'descriptionHi': ?instance.descriptionHi,
  'descriptionOr': ?instance.descriptionOr,
  'partnerType': _$ServiceInPartnerTypeEnumEnumMap[instance.partnerType]!,
  'visitType': _$ServiceInVisitTypeEnumEnumMap[instance.visitType]!,
  'pricePaise': instance.pricePaise,
  'bookingFeePaise': instance.bookingFeePaise,
  'durationMin': instance.durationMin,
  'docsRequired': ?instance.docsRequired,
};

const _$ServiceInPartnerTypeEnumEnumMap = {
  ServiceInPartnerTypeEnum.COMPANION: 'COMPANION',
  ServiceInPartnerTypeEnum.NURSE: 'NURSE',
};

const _$ServiceInVisitTypeEnumEnumMap = {
  ServiceInVisitTypeEnum.HOSPITAL_VISIT: 'HOSPITAL_VISIT',
  ServiceInVisitTypeEnum.HOME_VISIT: 'HOME_VISIT',
  ServiceInVisitTypeEnum.ERRAND: 'ERRAND',
};
