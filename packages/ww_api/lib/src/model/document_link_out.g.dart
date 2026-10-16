// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_link_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocumentLinkOutCWProxy {
  DocumentLinkOut url(String url);

  DocumentLinkOut mime(String mime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentLinkOut call({String url, String mime});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocumentLinkOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocumentLinkOut.copyWith.fieldName(...)`
class _$DocumentLinkOutCWProxyImpl implements _$DocumentLinkOutCWProxy {
  const _$DocumentLinkOutCWProxyImpl(this._value);

  final DocumentLinkOut _value;

  @override
  DocumentLinkOut url(String url) => this(url: url);

  @override
  DocumentLinkOut mime(String mime) => this(mime: mime);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocumentLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocumentLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocumentLinkOut call({
    Object? url = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
  }) {
    return DocumentLinkOut(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
    );
  }
}

extension $DocumentLinkOutCopyWith on DocumentLinkOut {
  /// Returns a callable class that can be used as follows: `instanceOfDocumentLinkOut.copyWith(...)` or like so:`instanceOfDocumentLinkOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocumentLinkOutCWProxy get copyWith => _$DocumentLinkOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentLinkOut _$DocumentLinkOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DocumentLinkOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'mime']);
      final val = DocumentLinkOut(
        url: $checkedConvert('url', (v) => v as String),
        mime: $checkedConvert('mime', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$DocumentLinkOutToJson(DocumentLinkOut instance) =>
    <String, dynamic>{'url': instance.url, 'mime': instance.mime};
