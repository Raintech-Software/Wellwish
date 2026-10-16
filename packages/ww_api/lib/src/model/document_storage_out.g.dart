// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_storage_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentStorageOutCWProxy {
  DocumentStorageOut usedBytes(int usedBytes);

  DocumentStorageOut quotaBytes(int quotaBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentStorageOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentStorageOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentStorageOut call({int usedBytes, int quotaBytes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentStorageOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentStorageOut.copyWith.fieldName(...)`
class _$DocumentStorageOutCWProxyImpl implements _$DocumentStorageOutCWProxy {
  const _$DocumentStorageOutCWProxyImpl(this._value);

  final DocumentStorageOut _value;

  @override
  DocumentStorageOut usedBytes(int usedBytes) => this(usedBytes: usedBytes);

  @override
  DocumentStorageOut quotaBytes(int quotaBytes) => this(quotaBytes: quotaBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentStorageOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentStorageOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentStorageOut call({
    Object? usedBytes = const $CopyWithPlaceholder(),
    Object? quotaBytes = const $CopyWithPlaceholder(),
  }) {
    return DocumentStorageOut(
      usedBytes: usedBytes == const $CopyWithPlaceholder()
          ? _value.usedBytes
          // ignore: cast_nullable_to_non_nullable
          : usedBytes as int,
      quotaBytes: quotaBytes == const $CopyWithPlaceholder()
          ? _value.quotaBytes
          // ignore: cast_nullable_to_non_nullable
          : quotaBytes as int,
    );
  }
}

extension $DocumentStorageOutCopyWith on DocumentStorageOut {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentStorageOut.copyWith(...)` or like so:`instanceOfDocumentStorageOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentStorageOutCWProxy get copyWith =>
      _$DocumentStorageOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentStorageOut _$DocumentStorageOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentStorageOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['usedBytes', 'quotaBytes']);
      final val = DocumentStorageOut(
        usedBytes: $checkedConvert('usedBytes', (v) => (v as num).toInt()),
        quotaBytes: $checkedConvert('quotaBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$DocumentStorageOutToJson(DocumentStorageOut instance) =>
    <String, dynamic>{
      'usedBytes': instance.usedBytes,
      'quotaBytes': instance.quotaBytes,
    };
