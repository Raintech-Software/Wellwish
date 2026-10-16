// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_publish_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LegalPublishInCWProxy {
  LegalPublishIn expectedVersion(int expectedVersion);

  LegalPublishIn askAgain(bool askAgain);

  LegalPublishIn titleEn(String titleEn);

  LegalPublishIn titleHi(String? titleHi);

  LegalPublishIn titleOr(String? titleOr);

  LegalPublishIn bodyEn(String bodyEn);

  LegalPublishIn bodyHi(String? bodyHi);

  LegalPublishIn bodyOr(String? bodyOr);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalPublishIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalPublishIn(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalPublishIn call({
    int expectedVersion,
    bool askAgain,
    String titleEn,
    String? titleHi,
    String? titleOr,
    String bodyEn,
    String? bodyHi,
    String? bodyOr,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLegalPublishIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLegalPublishIn.copyWith.fieldName(...)`
class _$LegalPublishInCWProxyImpl implements _$LegalPublishInCWProxy {
  const _$LegalPublishInCWProxyImpl(this._value);

  final LegalPublishIn _value;

  @override
  LegalPublishIn expectedVersion(int expectedVersion) =>
      this(expectedVersion: expectedVersion);

  @override
  LegalPublishIn askAgain(bool askAgain) => this(askAgain: askAgain);

  @override
  LegalPublishIn titleEn(String titleEn) => this(titleEn: titleEn);

  @override
  LegalPublishIn titleHi(String? titleHi) => this(titleHi: titleHi);

  @override
  LegalPublishIn titleOr(String? titleOr) => this(titleOr: titleOr);

  @override
  LegalPublishIn bodyEn(String bodyEn) => this(bodyEn: bodyEn);

  @override
  LegalPublishIn bodyHi(String? bodyHi) => this(bodyHi: bodyHi);

  @override
  LegalPublishIn bodyOr(String? bodyOr) => this(bodyOr: bodyOr);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LegalPublishIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LegalPublishIn(...).copyWith(id: 12, name: "My name")
  /// ````
  LegalPublishIn call({
    Object? expectedVersion = const $CopyWithPlaceholder(),
    Object? askAgain = const $CopyWithPlaceholder(),
    Object? titleEn = const $CopyWithPlaceholder(),
    Object? titleHi = const $CopyWithPlaceholder(),
    Object? titleOr = const $CopyWithPlaceholder(),
    Object? bodyEn = const $CopyWithPlaceholder(),
    Object? bodyHi = const $CopyWithPlaceholder(),
    Object? bodyOr = const $CopyWithPlaceholder(),
  }) {
    return LegalPublishIn(
      expectedVersion: expectedVersion == const $CopyWithPlaceholder()
          ? _value.expectedVersion
          // ignore: cast_nullable_to_non_nullable
          : expectedVersion as int,
      askAgain: askAgain == const $CopyWithPlaceholder()
          ? _value.askAgain
          // ignore: cast_nullable_to_non_nullable
          : askAgain as bool,
      titleEn: titleEn == const $CopyWithPlaceholder()
          ? _value.titleEn
          // ignore: cast_nullable_to_non_nullable
          : titleEn as String,
      titleHi: titleHi == const $CopyWithPlaceholder()
          ? _value.titleHi
          // ignore: cast_nullable_to_non_nullable
          : titleHi as String?,
      titleOr: titleOr == const $CopyWithPlaceholder()
          ? _value.titleOr
          // ignore: cast_nullable_to_non_nullable
          : titleOr as String?,
      bodyEn: bodyEn == const $CopyWithPlaceholder()
          ? _value.bodyEn
          // ignore: cast_nullable_to_non_nullable
          : bodyEn as String,
      bodyHi: bodyHi == const $CopyWithPlaceholder()
          ? _value.bodyHi
          // ignore: cast_nullable_to_non_nullable
          : bodyHi as String?,
      bodyOr: bodyOr == const $CopyWithPlaceholder()
          ? _value.bodyOr
          // ignore: cast_nullable_to_non_nullable
          : bodyOr as String?,
    );
  }
}

extension $LegalPublishInCopyWith on LegalPublishIn {
  /// Returns a callable class that can be used as follows: `instanceOfLegalPublishIn.copyWith(...)` or like so:`instanceOfLegalPublishIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LegalPublishInCWProxy get copyWith => _$LegalPublishInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LegalPublishIn _$LegalPublishInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LegalPublishIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'expectedVersion',
          'askAgain',
          'titleEn',
          'bodyEn',
        ],
      );
      final val = LegalPublishIn(
        expectedVersion: $checkedConvert(
          'expectedVersion',
          (v) => (v as num).toInt(),
        ),
        askAgain: $checkedConvert('askAgain', (v) => v as bool),
        titleEn: $checkedConvert('titleEn', (v) => v as String),
        titleHi: $checkedConvert('titleHi', (v) => v as String? ?? ''),
        titleOr: $checkedConvert('titleOr', (v) => v as String? ?? ''),
        bodyEn: $checkedConvert('bodyEn', (v) => v as String),
        bodyHi: $checkedConvert('bodyHi', (v) => v as String? ?? ''),
        bodyOr: $checkedConvert('bodyOr', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$LegalPublishInToJson(LegalPublishIn instance) =>
    <String, dynamic>{
      'expectedVersion': instance.expectedVersion,
      'askAgain': instance.askAgain,
      'titleEn': instance.titleEn,
      'titleHi': ?instance.titleHi,
      'titleOr': ?instance.titleOr,
      'bodyEn': instance.bodyEn,
      'bodyHi': ?instance.bodyHi,
      'bodyOr': ?instance.bodyOr,
    };
