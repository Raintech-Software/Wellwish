// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_upload_url_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentUploadUrlInCWProxy {
  DocumentUploadUrlIn type(DocumentUploadUrlInTypeEnum type);

  DocumentUploadUrlIn mime(String mime);

  DocumentUploadUrlIn sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUploadUrlIn call({
    DocumentUploadUrlInTypeEnum type,
    String mime,
    int sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentUploadUrlIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentUploadUrlIn.copyWith.fieldName(...)`
class _$DocumentUploadUrlInCWProxyImpl implements _$DocumentUploadUrlInCWProxy {
  const _$DocumentUploadUrlInCWProxyImpl(this._value);

  final DocumentUploadUrlIn _value;

  @override
  DocumentUploadUrlIn type(DocumentUploadUrlInTypeEnum type) =>
      this(type: type);

  @override
  DocumentUploadUrlIn mime(String mime) => this(mime: mime);

  @override
  DocumentUploadUrlIn sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentUploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentUploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentUploadUrlIn call({
    Object? type = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return DocumentUploadUrlIn(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DocumentUploadUrlInTypeEnum,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as int,
    );
  }
}

extension $DocumentUploadUrlInCopyWith on DocumentUploadUrlIn {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentUploadUrlIn.copyWith(...)` or like so:`instanceOfDocumentUploadUrlIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentUploadUrlInCWProxy get copyWith =>
      _$DocumentUploadUrlInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentUploadUrlIn _$DocumentUploadUrlInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentUploadUrlIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['type', 'mime', 'sizeBytes']);
      final val = DocumentUploadUrlIn(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$DocumentUploadUrlInTypeEnumEnumMap, v),
        ),
        mime: $checkedConvert('mime', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$DocumentUploadUrlInToJson(
  DocumentUploadUrlIn instance,
) => <String, dynamic>{
  'type': _$DocumentUploadUrlInTypeEnumEnumMap[instance.type]!,
  'mime': instance.mime,
  'sizeBytes': instance.sizeBytes,
};

const _$DocumentUploadUrlInTypeEnumEnumMap = {
  DocumentUploadUrlInTypeEnum.PRESCRIPTION: 'PRESCRIPTION',
  DocumentUploadUrlInTypeEnum.LAB_REPORT: 'LAB_REPORT',
  DocumentUploadUrlInTypeEnum.SCAN: 'SCAN',
  DocumentUploadUrlInTypeEnum.DISCHARGE: 'DISCHARGE',
  DocumentUploadUrlInTypeEnum.ID: 'ID',
  DocumentUploadUrlInTypeEnum.OTHER: 'OTHER',
};
