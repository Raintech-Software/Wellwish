// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_link_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FileLinkOutCWProxy {
  FileLinkOut url(String url);

  FileLinkOut mime(String mime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FileLinkOut call({String url, String mime});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFileLinkOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFileLinkOut.copyWith.fieldName(...)`
class _$FileLinkOutCWProxyImpl implements _$FileLinkOutCWProxy {
  const _$FileLinkOutCWProxyImpl(this._value);

  final FileLinkOut _value;

  @override
  FileLinkOut url(String url) => this(url: url);

  @override
  FileLinkOut mime(String mime) => this(mime: mime);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FileLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FileLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  FileLinkOut call({
    Object? url = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
  }) {
    return FileLinkOut(
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

extension $FileLinkOutCopyWith on FileLinkOut {
  /// Returns a callable class that can be used as follows: `instanceOfFileLinkOut.copyWith(...)` or like so:`instanceOfFileLinkOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FileLinkOutCWProxy get copyWith => _$FileLinkOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileLinkOut _$FileLinkOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FileLinkOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'mime']);
      final val = FileLinkOut(
        url: $checkedConvert('url', (v) => v as String),
        mime: $checkedConvert('mime', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$FileLinkOutToJson(FileLinkOut instance) =>
    <String, dynamic>{'url': instance.url, 'mime': instance.mime};
