// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_document_filter.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientDocumentFilterCWProxy {
  PatientDocumentFilter memberId(String? memberId);

  PatientDocumentFilter type(PatientDocumentFilterTypeEnum? type);

  PatientDocumentFilter group(PatientDocumentFilterGroupEnum? group);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentFilter call({
    String? memberId,
    PatientDocumentFilterTypeEnum? type,
    PatientDocumentFilterGroupEnum? group,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientDocumentFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientDocumentFilter.copyWith.fieldName(...)`
class _$PatientDocumentFilterCWProxyImpl
    implements _$PatientDocumentFilterCWProxy {
  const _$PatientDocumentFilterCWProxyImpl(this._value);

  final PatientDocumentFilter _value;

  @override
  PatientDocumentFilter memberId(String? memberId) => this(memberId: memberId);

  @override
  PatientDocumentFilter type(PatientDocumentFilterTypeEnum? type) =>
      this(type: type);

  @override
  PatientDocumentFilter group(PatientDocumentFilterGroupEnum? group) =>
      this(group: group);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentFilter call({
    Object? memberId = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? group = const $CopyWithPlaceholder(),
  }) {
    return PatientDocumentFilter(
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String?,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PatientDocumentFilterTypeEnum?,
      group: group == const $CopyWithPlaceholder()
          ? _value.group
          // ignore: cast_nullable_to_non_nullable
          : group as PatientDocumentFilterGroupEnum?,
    );
  }
}

extension $PatientDocumentFilterCopyWith on PatientDocumentFilter {
  /// Returns a callable class that can be used as follows: `instanceOfPatientDocumentFilter.copyWith(...)` or like so:`instanceOfPatientDocumentFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientDocumentFilterCWProxy get copyWith =>
      _$PatientDocumentFilterCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDocumentFilter _$PatientDocumentFilterFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PatientDocumentFilter', json, ($checkedConvert) {
  final val = PatientDocumentFilter(
    memberId: $checkedConvert('memberId', (v) => v as String?),
    type: $checkedConvert(
      'type',
      (v) => $enumDecodeNullable(_$PatientDocumentFilterTypeEnumEnumMap, v),
    ),
    group: $checkedConvert(
      'group',
      (v) => $enumDecodeNullable(_$PatientDocumentFilterGroupEnumEnumMap, v),
    ),
  );
  return val;
});

Map<String, dynamic> _$PatientDocumentFilterToJson(
  PatientDocumentFilter instance,
) => <String, dynamic>{
  'memberId': ?instance.memberId,
  'type': ?_$PatientDocumentFilterTypeEnumEnumMap[instance.type],
  'group': ?_$PatientDocumentFilterGroupEnumEnumMap[instance.group],
};

const _$PatientDocumentFilterTypeEnumEnumMap = {
  PatientDocumentFilterTypeEnum.PRESCRIPTION: 'PRESCRIPTION',
  PatientDocumentFilterTypeEnum.LAB_REPORT: 'LAB_REPORT',
  PatientDocumentFilterTypeEnum.SCAN: 'SCAN',
  PatientDocumentFilterTypeEnum.DISCHARGE: 'DISCHARGE',
  PatientDocumentFilterTypeEnum.ID: 'ID',
  PatientDocumentFilterTypeEnum.OTHER: 'OTHER',
};

const _$PatientDocumentFilterGroupEnumEnumMap = {
  PatientDocumentFilterGroupEnum.reports: 'reports',
  PatientDocumentFilterGroupEnum.prescriptions: 'prescriptions',
};
