// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppConfigOutCWProxy {
  AppConfigOut minVersions(AppVersionsOut minVersions);

  AppConfigOut storeUrls(AppVersionsOut storeUrls);

  AppConfigOut supportPhone(String supportPhone);

  AppConfigOut refundPercent(int refundPercent);

  AppConfigOut accountDeletionDays(int accountDeletionDays);

  AppConfigOut legalUrls(LegalUrlsOut legalUrls);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigOut call({
    AppVersionsOut minVersions,
    AppVersionsOut storeUrls,
    String supportPhone,
    int refundPercent,
    int accountDeletionDays,
    LegalUrlsOut legalUrls,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppConfigOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppConfigOut.copyWith.fieldName(...)`
class _$AppConfigOutCWProxyImpl implements _$AppConfigOutCWProxy {
  const _$AppConfigOutCWProxyImpl(this._value);

  final AppConfigOut _value;

  @override
  AppConfigOut minVersions(AppVersionsOut minVersions) =>
      this(minVersions: minVersions);

  @override
  AppConfigOut storeUrls(AppVersionsOut storeUrls) =>
      this(storeUrls: storeUrls);

  @override
  AppConfigOut supportPhone(String supportPhone) =>
      this(supportPhone: supportPhone);

  @override
  AppConfigOut refundPercent(int refundPercent) =>
      this(refundPercent: refundPercent);

  @override
  AppConfigOut accountDeletionDays(int accountDeletionDays) =>
      this(accountDeletionDays: accountDeletionDays);

  @override
  AppConfigOut legalUrls(LegalUrlsOut legalUrls) => this(legalUrls: legalUrls);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppConfigOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppConfigOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AppConfigOut call({
    Object? minVersions = const $CopyWithPlaceholder(),
    Object? storeUrls = const $CopyWithPlaceholder(),
    Object? supportPhone = const $CopyWithPlaceholder(),
    Object? refundPercent = const $CopyWithPlaceholder(),
    Object? accountDeletionDays = const $CopyWithPlaceholder(),
    Object? legalUrls = const $CopyWithPlaceholder(),
  }) {
    return AppConfigOut(
      minVersions: minVersions == const $CopyWithPlaceholder()
          ? _value.minVersions
          // ignore: cast_nullable_to_non_nullable
          : minVersions as AppVersionsOut,
      storeUrls: storeUrls == const $CopyWithPlaceholder()
          ? _value.storeUrls
          // ignore: cast_nullable_to_non_nullable
          : storeUrls as AppVersionsOut,
      supportPhone: supportPhone == const $CopyWithPlaceholder()
          ? _value.supportPhone
          // ignore: cast_nullable_to_non_nullable
          : supportPhone as String,
      refundPercent: refundPercent == const $CopyWithPlaceholder()
          ? _value.refundPercent
          // ignore: cast_nullable_to_non_nullable
          : refundPercent as int,
      accountDeletionDays: accountDeletionDays == const $CopyWithPlaceholder()
          ? _value.accountDeletionDays
          // ignore: cast_nullable_to_non_nullable
          : accountDeletionDays as int,
      legalUrls: legalUrls == const $CopyWithPlaceholder()
          ? _value.legalUrls
          // ignore: cast_nullable_to_non_nullable
          : legalUrls as LegalUrlsOut,
    );
  }
}

extension $AppConfigOutCopyWith on AppConfigOut {
  /// Returns a callable class that can be used as follows: `instanceOfAppConfigOut.copyWith(...)` or like so:`instanceOfAppConfigOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppConfigOutCWProxy get copyWith => _$AppConfigOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfigOut _$AppConfigOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AppConfigOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'minVersions',
          'storeUrls',
          'supportPhone',
          'refundPercent',
          'accountDeletionDays',
          'legalUrls',
        ],
      );
      final val = AppConfigOut(
        minVersions: $checkedConvert(
          'minVersions',
          (v) => AppVersionsOut.fromJson(v as Map<String, dynamic>),
        ),
        storeUrls: $checkedConvert(
          'storeUrls',
          (v) => AppVersionsOut.fromJson(v as Map<String, dynamic>),
        ),
        supportPhone: $checkedConvert('supportPhone', (v) => v as String),
        refundPercent: $checkedConvert(
          'refundPercent',
          (v) => (v as num).toInt(),
        ),
        accountDeletionDays: $checkedConvert(
          'accountDeletionDays',
          (v) => (v as num).toInt(),
        ),
        legalUrls: $checkedConvert(
          'legalUrls',
          (v) => LegalUrlsOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AppConfigOutToJson(AppConfigOut instance) =>
    <String, dynamic>{
      'minVersions': instance.minVersions.toJson(),
      'storeUrls': instance.storeUrls.toJson(),
      'supportPhone': instance.supportPhone,
      'refundPercent': instance.refundPercent,
      'accountDeletionDays': instance.accountDeletionDays,
      'legalUrls': instance.legalUrls.toJson(),
    };
