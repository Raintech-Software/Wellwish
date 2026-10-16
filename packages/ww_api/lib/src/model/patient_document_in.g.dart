// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_document_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientDocumentInCWProxy {
  PatientDocumentIn fileKey(String fileKey);

  PatientDocumentIn memberId(String memberId);

  PatientDocumentIn type(PatientDocumentInTypeEnum type);

  PatientDocumentIn title(String title);

  PatientDocumentIn date(DateTime? date);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentIn call({
    String fileKey,
    String memberId,
    PatientDocumentInTypeEnum type,
    String title,
    DateTime? date,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientDocumentIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientDocumentIn.copyWith.fieldName(...)`
class _$PatientDocumentInCWProxyImpl implements _$PatientDocumentInCWProxy {
  const _$PatientDocumentInCWProxyImpl(this._value);

  final PatientDocumentIn _value;

  @override
  PatientDocumentIn fileKey(String fileKey) => this(fileKey: fileKey);

  @override
  PatientDocumentIn memberId(String memberId) => this(memberId: memberId);

  @override
  PatientDocumentIn type(PatientDocumentInTypeEnum type) => this(type: type);

  @override
  PatientDocumentIn title(String title) => this(title: title);

  @override
  PatientDocumentIn date(DateTime? date) => this(date: date);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientDocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientDocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientDocumentIn call({
    Object? fileKey = const $CopyWithPlaceholder(),
    Object? memberId = const $CopyWithPlaceholder(),
    Object? type = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? date = const $CopyWithPlaceholder(),
  }) {
    return PatientDocumentIn(
      fileKey: fileKey == const $CopyWithPlaceholder()
          ? _value.fileKey
          // ignore: cast_nullable_to_non_nullable
          : fileKey as String,
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String,
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as PatientDocumentInTypeEnum,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      date: date == const $CopyWithPlaceholder()
          ? _value.date
          // ignore: cast_nullable_to_non_nullable
          : date as DateTime?,
    );
  }
}

extension $PatientDocumentInCopyWith on PatientDocumentIn {
  /// Returns a callable class that can be used as follows: `instanceOfPatientDocumentIn.copyWith(...)` or like so:`instanceOfPatientDocumentIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientDocumentInCWProxy get copyWith =>
      _$PatientDocumentInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientDocumentIn _$PatientDocumentInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientDocumentIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['fileKey', 'memberId', 'type', 'title', 'date'],
      );
      final val = PatientDocumentIn(
        fileKey: $checkedConvert('fileKey', (v) => v as String),
        memberId: $checkedConvert('memberId', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$PatientDocumentInTypeEnumEnumMap, v),
        ),
        title: $checkedConvert('title', (v) => v as String),
        date: $checkedConvert(
          'date',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatientDocumentInToJson(PatientDocumentIn instance) =>
    <String, dynamic>{
      'fileKey': instance.fileKey,
      'memberId': instance.memberId,
      'type': _$PatientDocumentInTypeEnumEnumMap[instance.type]!,
      'title': instance.title,
      'date': instance.date?.toIso8601String(),
    };

const _$PatientDocumentInTypeEnumEnumMap = {
  PatientDocumentInTypeEnum.PRESCRIPTION: 'PRESCRIPTION',
  PatientDocumentInTypeEnum.LAB_REPORT: 'LAB_REPORT',
  PatientDocumentInTypeEnum.SCAN: 'SCAN',
  PatientDocumentInTypeEnum.DISCHARGE: 'DISCHARGE',
  PatientDocumentInTypeEnum.ID: 'ID',
  PatientDocumentInTypeEnum.OTHER: 'OTHER',
};
