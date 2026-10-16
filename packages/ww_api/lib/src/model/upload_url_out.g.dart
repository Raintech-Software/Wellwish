// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_url_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadUrlOutCWProxy {
  UploadUrlOut fileKey(String fileKey);

  UploadUrlOut uploadUrl(String uploadUrl);

  UploadUrlOut uploadFields(Map<String, String> uploadFields);

  UploadUrlOut mime(String mime);

  UploadUrlOut maxBytes(int maxBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadUrlOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadUrlOut(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadUrlOut call({
    String fileKey,
    String uploadUrl,
    Map<String, String> uploadFields,
    String mime,
    int maxBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadUrlOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadUrlOut.copyWith.fieldName(...)`
class _$UploadUrlOutCWProxyImpl implements _$UploadUrlOutCWProxy {
  const _$UploadUrlOutCWProxyImpl(this._value);

  final UploadUrlOut _value;

  @override
  UploadUrlOut fileKey(String fileKey) => this(fileKey: fileKey);

  @override
  UploadUrlOut uploadUrl(String uploadUrl) => this(uploadUrl: uploadUrl);

  @override
  UploadUrlOut uploadFields(Map<String, String> uploadFields) =>
      this(uploadFields: uploadFields);

  @override
  UploadUrlOut mime(String mime) => this(mime: mime);

  @override
  UploadUrlOut maxBytes(int maxBytes) => this(maxBytes: maxBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadUrlOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadUrlOut(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadUrlOut call({
    Object? fileKey = const $CopyWithPlaceholder(),
    Object? uploadUrl = const $CopyWithPlaceholder(),
    Object? uploadFields = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? maxBytes = const $CopyWithPlaceholder(),
  }) {
    return UploadUrlOut(
      fileKey: fileKey == const $CopyWithPlaceholder()
          ? _value.fileKey
          // ignore: cast_nullable_to_non_nullable
          : fileKey as String,
      uploadUrl: uploadUrl == const $CopyWithPlaceholder()
          ? _value.uploadUrl
          // ignore: cast_nullable_to_non_nullable
          : uploadUrl as String,
      uploadFields: uploadFields == const $CopyWithPlaceholder()
          ? _value.uploadFields
          // ignore: cast_nullable_to_non_nullable
          : uploadFields as Map<String, String>,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
      maxBytes: maxBytes == const $CopyWithPlaceholder()
          ? _value.maxBytes
          // ignore: cast_nullable_to_non_nullable
          : maxBytes as int,
    );
  }
}

extension $UploadUrlOutCopyWith on UploadUrlOut {
  /// Returns a callable class that can be used as follows: `instanceOfUploadUrlOut.copyWith(...)` or like so:`instanceOfUploadUrlOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadUrlOutCWProxy get copyWith => _$UploadUrlOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadUrlOut _$UploadUrlOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadUrlOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'fileKey',
          'uploadUrl',
          'uploadFields',
          'mime',
          'maxBytes',
        ],
      );
      final val = UploadUrlOut(
        fileKey: $checkedConvert('fileKey', (v) => v as String),
        uploadUrl: $checkedConvert('uploadUrl', (v) => v as String),
        uploadFields: $checkedConvert(
          'uploadFields',
          (v) => Map<String, String>.from(v as Map),
        ),
        mime: $checkedConvert('mime', (v) => v as String),
        maxBytes: $checkedConvert('maxBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$UploadUrlOutToJson(UploadUrlOut instance) =>
    <String, dynamic>{
      'fileKey': instance.fileKey,
      'uploadUrl': instance.uploadUrl,
      'uploadFields': instance.uploadFields,
      'mime': instance.mime,
      'maxBytes': instance.maxBytes,
    };
