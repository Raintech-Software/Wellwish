// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentOutCWProxy {
  DocumentOut id(String id);

  DocumentOut docType(String docType);

  DocumentOut status(String status);

  DocumentOut mime(String mime);

  DocumentOut numberMasked(String numberMasked);

  DocumentOut expiresOn(DateTime? expiresOn);

  DocumentOut rejectReason(String rejectReason);

  DocumentOut isCurrent(bool isCurrent);

  DocumentOut reviewedBy(String? reviewedBy);

  DocumentOut reviewedAt(DateTime? reviewedAt);

  DocumentOut createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentOut call({
    String id,
    String docType,
    String status,
    String mime,
    String numberMasked,
    DateTime? expiresOn,
    String rejectReason,
    bool isCurrent,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime createdAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentOut.copyWith.fieldName(...)`
class _$DocumentOutCWProxyImpl implements _$DocumentOutCWProxy {
  const _$DocumentOutCWProxyImpl(this._value);

  final DocumentOut _value;

  @override
  DocumentOut id(String id) => this(id: id);

  @override
  DocumentOut docType(String docType) => this(docType: docType);

  @override
  DocumentOut status(String status) => this(status: status);

  @override
  DocumentOut mime(String mime) => this(mime: mime);

  @override
  DocumentOut numberMasked(String numberMasked) =>
      this(numberMasked: numberMasked);

  @override
  DocumentOut expiresOn(DateTime? expiresOn) => this(expiresOn: expiresOn);

  @override
  DocumentOut rejectReason(String rejectReason) =>
      this(rejectReason: rejectReason);

  @override
  DocumentOut isCurrent(bool isCurrent) => this(isCurrent: isCurrent);

  @override
  DocumentOut reviewedBy(String? reviewedBy) => this(reviewedBy: reviewedBy);

  @override
  DocumentOut reviewedAt(DateTime? reviewedAt) => this(reviewedAt: reviewedAt);

  @override
  DocumentOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? docType = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? numberMasked = const $CopyWithPlaceholder(),
    Object? expiresOn = const $CopyWithPlaceholder(),
    Object? rejectReason = const $CopyWithPlaceholder(),
    Object? isCurrent = const $CopyWithPlaceholder(),
    Object? reviewedBy = const $CopyWithPlaceholder(),
    Object? reviewedAt = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return DocumentOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      docType: docType == const $CopyWithPlaceholder()
          ? _value.docType
          // ignore: cast_nullable_to_non_nullable
          : docType as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
      numberMasked: numberMasked == const $CopyWithPlaceholder()
          ? _value.numberMasked
          // ignore: cast_nullable_to_non_nullable
          : numberMasked as String,
      expiresOn: expiresOn == const $CopyWithPlaceholder()
          ? _value.expiresOn
          // ignore: cast_nullable_to_non_nullable
          : expiresOn as DateTime?,
      rejectReason: rejectReason == const $CopyWithPlaceholder()
          ? _value.rejectReason
          // ignore: cast_nullable_to_non_nullable
          : rejectReason as String,
      isCurrent: isCurrent == const $CopyWithPlaceholder()
          ? _value.isCurrent
          // ignore: cast_nullable_to_non_nullable
          : isCurrent as bool,
      reviewedBy: reviewedBy == const $CopyWithPlaceholder()
          ? _value.reviewedBy
          // ignore: cast_nullable_to_non_nullable
          : reviewedBy as String?,
      reviewedAt: reviewedAt == const $CopyWithPlaceholder()
          ? _value.reviewedAt
          // ignore: cast_nullable_to_non_nullable
          : reviewedAt as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $DocumentOutCopyWith on DocumentOut {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentOut.copyWith(...)` or like so:`instanceOfDocumentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentOutCWProxy get copyWith => _$DocumentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentOut _$DocumentOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'docType',
          'status',
          'mime',
          'numberMasked',
          'expiresOn',
          'rejectReason',
          'isCurrent',
          'reviewedBy',
          'reviewedAt',
          'createdAt',
        ],
      );
      final val = DocumentOut(
        id: $checkedConvert('id', (v) => v as String),
        docType: $checkedConvert('docType', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        mime: $checkedConvert('mime', (v) => v as String),
        numberMasked: $checkedConvert('numberMasked', (v) => v as String),
        expiresOn: $checkedConvert(
          'expiresOn',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        rejectReason: $checkedConvert('rejectReason', (v) => v as String),
        isCurrent: $checkedConvert('isCurrent', (v) => v as bool),
        reviewedBy: $checkedConvert('reviewedBy', (v) => v as String?),
        reviewedAt: $checkedConvert(
          'reviewedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DocumentOutToJson(DocumentOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'docType': instance.docType,
      'status': instance.status,
      'mime': instance.mime,
      'numberMasked': instance.numberMasked,
      'expiresOn': instance.expiresOn?.toIso8601String(),
      'rejectReason': instance.rejectReason,
      'isCurrent': instance.isCurrent,
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
