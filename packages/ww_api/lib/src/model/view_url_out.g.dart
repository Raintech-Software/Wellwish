// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_url_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ViewUrlOutCWProxy {
  ViewUrlOut url(String url);

  ViewUrlOut mime(String mime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ViewUrlOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ViewUrlOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ViewUrlOut call({String url, String mime});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfViewUrlOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfViewUrlOut.copyWith.fieldName(...)`
class _$ViewUrlOutCWProxyImpl implements _$ViewUrlOutCWProxy {
  const _$ViewUrlOutCWProxyImpl(this._value);

  final ViewUrlOut _value;

  @override
  ViewUrlOut url(String url) => this(url: url);

  @override
  ViewUrlOut mime(String mime) => this(mime: mime);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ViewUrlOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ViewUrlOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ViewUrlOut call({
    Object? url = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
  }) {
    return ViewUrlOut(
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

extension $ViewUrlOutCopyWith on ViewUrlOut {
  /// Returns a callable class that can be used as follows: `instanceOfViewUrlOut.copyWith(...)` or like so:`instanceOfViewUrlOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ViewUrlOutCWProxy get copyWith => _$ViewUrlOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewUrlOut _$ViewUrlOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ViewUrlOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'mime']);
      final val = ViewUrlOut(
        url: $checkedConvert('url', (v) => v as String),
        mime: $checkedConvert('mime', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ViewUrlOutToJson(ViewUrlOut instance) =>
    <String, dynamic>{'url': instance.url, 'mime': instance.mime};
