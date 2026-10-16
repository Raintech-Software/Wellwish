// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentInCWProxy {
  DocumentIn docType(String docType);

  DocumentIn fileKey(String fileKey);

  DocumentIn number(String? number);

  DocumentIn expiresOn(DateTime? expiresOn);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentIn call({
    String docType,
    String fileKey,
    String? number,
    DateTime? expiresOn,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentIn.copyWith.fieldName(...)`
class _$DocumentInCWProxyImpl implements _$DocumentInCWProxy {
  const _$DocumentInCWProxyImpl(this._value);

  final DocumentIn _value;

  @override
  DocumentIn docType(String docType) => this(docType: docType);

  @override
  DocumentIn fileKey(String fileKey) => this(fileKey: fileKey);

  @override
  DocumentIn number(String? number) => this(number: number);

  @override
  DocumentIn expiresOn(DateTime? expiresOn) => this(expiresOn: expiresOn);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentIn call({
    Object? docType = const $CopyWithPlaceholder(),
    Object? fileKey = const $CopyWithPlaceholder(),
    Object? number = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
  }) {
    return DocumentIn(
      docType: docType == const $CopyWithPlaceholder()
          ? _value.docType
          // ignore: cast_nullable_to_non_nullable
          : docType as String,
      fileKey: fileKey == const $CopyWithPlaceholder()
          ? _value.fileKey
          // ignore: cast_nullable_to_non_nullable
          : fileKey as String,
      number: number == const $CopyWithPlaceholder()
          ? _value.number
          // ignore: cast_nullable_to_non_nullable
          : number as String?,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime?,
    );
  }
}

extension $DocumentInCopyWith on DocumentIn {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentIn.copyWith(...)` or like so:`instanceOfDocumentIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentInCWProxy get copyWith => _$DocumentInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentIn _$DocumentInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['docType', 'fileKey']);
      final val = DocumentIn(
        docType: $checkedConvert('docType', (v) => v as String),
        fileKey: $checkedConvert('fileKey', (v) => v as String),
        number: $checkedConvert('number', (v) => v as String? ?? ''),
        expiresOn: $checkedConvert(
          'expiresOn',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DocumentInToJson(DocumentIn instance) =>
    <String, dynamic>{
      'docType': instance.docType,
      'fileKey': instance.fileKey,
      'number': ?instance.number,
      'expiresOn': ?instance.expiresOn?.toIso8601String(),
    };
