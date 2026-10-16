// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_summary_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalSummaryOutCWProxy {
  LegalSummaryOut kind(LegalSummaryOutKindEnum kind);

  LegalSummaryOut title(String title);

  LegalSummaryOut version(int version);

  LegalSummaryOut consentVersion(String consentVersion);

  LegalSummaryOut askedAgain(bool askedAgain);

  LegalSummaryOut languages(List<String> languages);

  LegalSummaryOut publishedAt(DateTime publishedAt);

  LegalSummaryOut publishedBy(String? publishedBy);

  LegalSummaryOut publicUrl(String publicUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalSummaryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalSummaryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalSummaryOut call({
    LegalSummaryOutKindEnum kind,
    String title,
    int version,
    String consentVersion,
    bool askedAgain,
    List<String> languages,
    DateTime publishedAt,
    String? publishedBy,
    String publicUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalSummaryOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalSummaryOut.copyWith.fieldName(...)`
class _$LegalSummaryOutCWProxyImpl implements _$LegalSummaryOutCWProxy {
  const _$LegalSummaryOutCWProxyImpl(this._value);

  final LegalSummaryOut _value;

  @override
  LegalSummaryOut kind(LegalSummaryOutKindEnum kind) => this(kind: kind);

  @override
  LegalSummaryOut title(String title) => this(title: title);

  @override
  LegalSummaryOut version(int version) => this(version: version);

  @override
  LegalSummaryOut consentVersion(String consentVersion) =>
      this(consentVersion: consentVersion);

  @override
  LegalSummaryOut askedAgain(bool askedAgain) => this(askedAgain: askedAgain);

  @override
  LegalSummaryOut languages(List<String> languages) =>
      this(languages: languages);

  @override
  LegalSummaryOut publishedAt(DateTime publishedAt) =>
      this(publishedAt: publishedAt);

  @override
  LegalSummaryOut publishedBy(String? publishedBy) =>
      this(publishedBy: publishedBy);

  @override
  LegalSummaryOut publicUrl(String publicUrl) => this(publicUrl: publicUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalSummaryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalSummaryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalSummaryOut call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? title = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
    Object? consentVersion = const $CopyWithPlaceholder(),
    Object? askedAgain = const $CopyWithPlaceholder(),
    Object? languages = const $CopyWithPlaceholder(),
    Object? publishedAt = const $CopyWithPlaceholder(),
    Object? publishedBy = const $CopyWithPlaceholder(),
    Object? publicUrl = const $CopyWithPlaceholder(),
  }) {
    return LegalSummaryOut(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as LegalSummaryOutKindEnum,
      title: title == const $CopyWithPlaceholder()
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : title as String,
      version: version == const $CopyWithPlaceholder()
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
      consentVersion: consentVersion == const $CopyWithPlaceholder()
          ? _value.consentVersion
          // ignore: cast_nullable_to_non_nullable
          : consentVersion as String,
      askedAgain: askedAgain == const $CopyWithPlaceholder()
          ? _value.askedAgain
          // ignore: cast_nullable_to_non_nullable
          : askedAgain as bool,
      languages: languages == const $CopyWithPlaceholder()
          ? _value.languages
          // ignore: cast_nullable_to_non_nullable
          : languages as List<String>,
      publishedAt: publishedAt == const $CopyWithPlaceholder()
          ? _value.publishedAt
          // ignore: cast_nullable_to_non_nullable
          : publishedAt as DateTime,
      publishedBy: publishedBy == const $CopyWithPlaceholder()
          ? _value.publishedBy
          // ignore: cast_nullable_to_non_nullable
          : publishedBy as String?,
      publicUrl: publicUrl == const $CopyWithPlaceholder()
          ? _value.publicUrl
          // ignore: cast_nullable_to_non_nullable
          : publicUrl as String,
    );
  }
}

extension $LegalSummaryOutCopyWith on LegalSummaryOut {
  /// Returns a callable class that can be used as follows: `instanceOfLegalSummaryOut.copyWith(...)` or like so:`instanceOfLegalSummaryOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalSummaryOutCWProxy get copyWith => _$LegalSummaryOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalSummaryOut _$LegalSummaryOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalSummaryOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'kind',
          'title',
          'version',
          'consentVersion',
          'askedAgain',
          'languages',
          'publishedAt',
          'publicUrl',
        ],
      );
      final val = LegalSummaryOut(
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$LegalSummaryOutKindEnumEnumMap, v),
        ),
        title: $checkedConvert('title', (v) => v as String),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        consentVersion: $checkedConvert('consentVersion', (v) => v as String),
        askedAgain: $checkedConvert('askedAgain', (v) => v as bool),
        languages: $checkedConvert(
          'languages',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        publishedAt: $checkedConvert(
          'publishedAt',
          (v) => DateTime.parse(v as String),
        ),
        publishedBy: $checkedConvert('publishedBy', (v) => v as String?),
        publicUrl: $checkedConvert('publicUrl', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LegalSummaryOutToJson(LegalSummaryOut instance) =>
    <String, dynamic>{
      'kind': _$LegalSummaryOutKindEnumEnumMap[instance.kind]!,
      'title': instance.title,
      'version': instance.version,
      'consentVersion': instance.consentVersion,
      'askedAgain': instance.askedAgain,
      'languages': instance.languages,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'publishedBy': ?instance.publishedBy,
      'publicUrl': instance.publicUrl,
    };

const _$LegalSummaryOutKindEnumEnumMap = {
  LegalSummaryOutKindEnum.TERMS: 'TERMS',
  LegalSummaryOutKindEnum.PRIVACY: 'PRIVACY',
  LegalSummaryOutKindEnum.REFUNDS: 'REFUNDS',
  LegalSummaryOutKindEnum.PARTNER_TERMS: 'PARTNER_TERMS',
};
