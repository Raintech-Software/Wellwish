// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_version_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalVersionOutCWProxy {
  LegalVersionOut version(int version);

  LegalVersionOut askedAgain(bool askedAgain);

  LegalVersionOut publishedAt(DateTime publishedAt);

  LegalVersionOut publishedBy(String? publishedBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersionOut call({
    int version,
    bool askedAgain,
    DateTime publishedAt,
    String? publishedBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalVersionOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalVersionOut.copyWith.fieldName(...)`
class _$LegalVersionOutCWProxyImpl implements _$LegalVersionOutCWProxy {
  const _$LegalVersionOutCWProxyImpl(this._value);

  final LegalVersionOut _value;

  @override
  LegalVersionOut version(int version) => this(version: version);

  @override
  LegalVersionOut askedAgain(bool askedAgain) => this(askedAgain: askedAgain);

  @override
  LegalVersionOut publishedAt(DateTime publishedAt) =>
      this(publishedAt: publishedAt);

  @override
  LegalVersionOut publishedBy(String? publishedBy) =>
      this(publishedBy: publishedBy);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalVersionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalVersionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalVersionOut call({
    Object? version = const $CopyWithPlaceholder(),
    Object? askedAgain = const $CopyWithPlaceholder(),
    Object? publishedAt = const $CopyWithPlaceholder(),
    Object? publishedBy = const $CopyWithPlaceholder(),
  }) {
    return LegalVersionOut(
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      askedAgain: askedAgain == const $CopyWithPlaceholder()
          ? _value.askedAgain
          // ignore: cast_nullable_to_non_nullable
          : askedAgain as bool,
      publishedAt: publishedAt == const $CopyWithPlaceholder()
          ? _value.publishedAt
          // ignore: cast_nullable_to_non_nullable
          : publishedAt as DateTime,
      publishedBy: publishedBy == const $CopyWithPlaceholder()
          ? _value.publishedBy
          // ignore: cast_nullable_to_non_nullable
          : publishedBy as String?,
    );
  }
}

extension $LegalVersionOutCopyWith on LegalVersionOut {
  /// Returns a callable class that can be used as follows: `instanceOfLegalVersionOut.copyWith(...)` or like so:`instanceOfLegalVersionOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalVersionOutCWProxy get copyWith => _$LegalVersionOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalVersionOut _$LegalVersionOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalVersionOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'version',
          'askedAgain',
          'publishedAt',
          'publishedBy',
        ],
      );
      final val = LegalVersionOut(
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        askedAgain: $checkedConvert('askedAgain', (v) => v as bool),
        publishedAt: $checkedConvert(
          'publishedAt',
          (v) => DateTime.parse(v as String),
        ),
        publishedBy: $checkedConvert('publishedBy', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LegalVersionOutToJson(LegalVersionOut instance) =>
    <String, dynamic>{
      'version': instance.version,
      'askedAgain': instance.askedAgain,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'publishedBy': instance.publishedBy,
    };
