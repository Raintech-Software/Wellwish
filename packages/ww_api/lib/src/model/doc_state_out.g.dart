// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_state_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DocStateOutCWProxy {
  DocStateOut required_(RequiredDocumentOut required_);

  DocStateOut status(String status);

  DocStateOut document(DocumentOut? document);

  DocStateOut replacement(DocumentOut? replacement);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocStateOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocStateOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocStateOut call({
    RequiredDocumentOut required_,
    String status,
    DocumentOut? document,
    DocumentOut? replacement,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDocStateOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDocStateOut.copyWith.fieldName(...)`
class _$DocStateOutCWProxyImpl implements _$DocStateOutCWProxy {
  const _$DocStateOutCWProxyImpl(this._value);

  final DocStateOut _value;

  @override
  DocStateOut required_(RequiredDocumentOut required_) =>
      this(required_: required_);

  @override
  DocStateOut status(String status) => this(status: status);

  @override
  DocStateOut document(DocumentOut? document) => this(document: document);

  @override
  DocStateOut replacement(DocumentOut? replacement) =>
      this(replacement: replacement);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DocStateOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DocStateOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DocStateOut call({
    Object? required_ = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? document = const $CopyWithPlaceholder(),
    Object? replacement = const $CopyWithPlaceholder(),
  }) {
    return DocStateOut(
      required_: required_ == const $CopyWithPlaceholder()
          ? _value.required_
          // ignore: cast_nullable_to_non_nullable
          : required_ as RequiredDocumentOut,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      document: document == const $CopyWithPlaceholder()
          ? _value.document
          // ignore: cast_nullable_to_non_nullable
          : document as DocumentOut?,
      replacement: replacement == const $CopyWithPlaceholder()
          ? _value.replacement
          // ignore: cast_nullable_to_non_nullable
          : replacement as DocumentOut?,
    );
  }
}

extension $DocStateOutCopyWith on DocStateOut {
  /// Returns a callable class that can be used as follows: `instanceOfDocStateOut.copyWith(...)` or like so:`instanceOfDocStateOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DocStateOutCWProxy get copyWith => _$DocStateOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocStateOut _$DocStateOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'DocStateOut',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['required', 'status', 'document']);
    final val = DocStateOut(
      required_: $checkedConvert(
        'required',
        (v) => RequiredDocumentOut.fromJson(v as Map<String, dynamic>),
      ),
      status: $checkedConvert('status', (v) => v as String),
      document: $checkedConvert(
        'document',
        (v) =>
            v == null ? null : DocumentOut.fromJson(v as Map<String, dynamic>),
      ),
      replacement: $checkedConvert(
        'replacement',
        (v) =>
            v == null ? null : DocumentOut.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'required_': 'required'},
);

Map<String, dynamic> _$DocStateOutToJson(DocStateOut instance) =>
    <String, dynamic>{
      'required': instance.required_.toJson(),
      'status': instance.status,
      'document': instance.document?.toJson(),
      'replacement': ?instance.replacement?.toJson(),
    };
