// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_urls_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalUrlsOutCWProxy {
  LegalUrlsOut terms(String terms);

  LegalUrlsOut privacy(String privacy);

  LegalUrlsOut refunds(String refunds);

  LegalUrlsOut partnerTerms(String partnerTerms);

  LegalUrlsOut deleteAccount(String deleteAccount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalUrlsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalUrlsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalUrlsOut call({
    String terms,
    String privacy,
    String refunds,
    String partnerTerms,
    String deleteAccount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalUrlsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalUrlsOut.copyWith.fieldName(...)`
class _$LegalUrlsOutCWProxyImpl implements _$LegalUrlsOutCWProxy {
  const _$LegalUrlsOutCWProxyImpl(this._value);

  final LegalUrlsOut _value;

  @override
  LegalUrlsOut terms(String terms) => this(terms: terms);

  @override
  LegalUrlsOut privacy(String privacy) => this(privacy: privacy);

  @override
  LegalUrlsOut refunds(String refunds) => this(refunds: refunds);

  @override
  LegalUrlsOut partnerTerms(String partnerTerms) =>
      this(partnerTerms: partnerTerms);

  @override
  LegalUrlsOut deleteAccount(String deleteAccount) =>
      this(deleteAccount: deleteAccount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalUrlsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalUrlsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalUrlsOut call({
    Object? terms = const $CopyWithPlaceholder(),
    Object? privacy = const $CopyWithPlaceholder(),
    Object? refunds = const $CopyWithPlaceholder(),
    Object? partnerTerms = const $CopyWithPlaceholder(),
    Object? deleteAccount = const $CopyWithPlaceholder(),
  }) {
    return LegalUrlsOut(
      terms: terms == const $CopyWithPlaceholder()
          ? _value.terms
          // ignore: cast_nullable_to_non_nullable
          : terms as String,
      privacy: privacy == const $CopyWithPlaceholder()
          ? _value.privacy
          // ignore: cast_nullable_to_non_nullable
          : privacy as String,
      refunds: refunds == const $CopyWithPlaceholder()
          ? _value.refunds
          // ignore: cast_nullable_to_non_nullable
          : refunds as String,
      partnerTerms: partnerTerms == const $CopyWithPlaceholder()
          ? _value.partnerTerms
          // ignore: cast_nullable_to_non_nullable
          : partnerTerms as String,
      deleteAccount: deleteAccount == const $CopyWithPlaceholder()
          ? _value.deleteAccount
          // ignore: cast_nullable_to_non_nullable
          : deleteAccount as String,
    );
  }
}

extension $LegalUrlsOutCopyWith on LegalUrlsOut {
  /// Returns a callable class that can be used as follows: `instanceOfLegalUrlsOut.copyWith(...)` or like so:`instanceOfLegalUrlsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalUrlsOutCWProxy get copyWith => _$LegalUrlsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalUrlsOut _$LegalUrlsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalUrlsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'terms',
          'privacy',
          'refunds',
          'partnerTerms',
          'deleteAccount',
        ],
      );
      final val = LegalUrlsOut(
        terms: $checkedConvert('terms', (v) => v as String),
        privacy: $checkedConvert('privacy', (v) => v as String),
        refunds: $checkedConvert('refunds', (v) => v as String),
        partnerTerms: $checkedConvert('partnerTerms', (v) => v as String),
        deleteAccount: $checkedConvert('deleteAccount', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LegalUrlsOutToJson(LegalUrlsOut instance) =>
    <String, dynamic>{
      'terms': instance.terms,
      'privacy': instance.privacy,
      'refunds': instance.refunds,
      'partnerTerms': instance.partnerTerms,
      'deleteAccount': instance.deleteAccount,
    };
