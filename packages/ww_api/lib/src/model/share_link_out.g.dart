// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share_link_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ShareLinkOutCWProxy {
  ShareLinkOut url(String url);

  ShareLinkOut expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShareLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShareLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ShareLinkOut call({String url, DateTime expiresAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfShareLinkOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfShareLinkOut.copyWith.fieldName(...)`
class _$ShareLinkOutCWProxyImpl implements _$ShareLinkOutCWProxy {
  const _$ShareLinkOutCWProxyImpl(this._value);

  final ShareLinkOut _value;

  @override
  ShareLinkOut url(String url) => this(url: url);

  @override
  ShareLinkOut expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ShareLinkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ShareLinkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ShareLinkOut call({
    Object? url = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return ShareLinkOut(
      url: url == const $CopyWithPlaceholder()
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $ShareLinkOutCopyWith on ShareLinkOut {
  /// Returns a callable class that can be used as follows: `instanceOfShareLinkOut.copyWith(...)` or like so:`instanceOfShareLinkOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ShareLinkOutCWProxy get copyWith => _$ShareLinkOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareLinkOut _$ShareLinkOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ShareLinkOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'expiresAt']);
      final val = ShareLinkOut(
        url: $checkedConvert('url', (v) => v as String),
        expiresAt: $checkedConvert(
          'expiresAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ShareLinkOutToJson(ShareLinkOut instance) =>
    <String, dynamic>{
      'url': instance.url,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
