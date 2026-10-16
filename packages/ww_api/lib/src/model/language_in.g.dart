// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LanguageInCWProxy {
  LanguageIn language(LanguageInLanguageEnum language);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LanguageIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LanguageIn(...).copyWith(id: 12, name: "My name")
  /// ````
  LanguageIn call({LanguageInLanguageEnum language});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLanguageIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLanguageIn.copyWith.fieldName(...)`
class _$LanguageInCWProxyImpl implements _$LanguageInCWProxy {
  const _$LanguageInCWProxyImpl(this._value);

  final LanguageIn _value;

  @override
  LanguageIn language(LanguageInLanguageEnum language) =>
      this(language: language);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LanguageIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LanguageIn(...).copyWith(id: 12, name: "My name")
  /// ````
  LanguageIn call({Object? language = const $CopyWithPlaceholder()}) {
    return LanguageIn(
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as LanguageInLanguageEnum,
    );
  }
}

extension $LanguageInCopyWith on LanguageIn {
  /// Returns a callable class that can be used as follows: `instanceOfLanguageIn.copyWith(...)` or like so:`instanceOfLanguageIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LanguageInCWProxy get copyWith => _$LanguageInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageIn _$LanguageInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LanguageIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['language']);
      final val = LanguageIn(
        language: $checkedConvert(
          'language',
          (v) => $enumDecode(_$LanguageInLanguageEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LanguageInToJson(LanguageIn instance) =>
    <String, dynamic>{
      'language': _$LanguageInLanguageEnumEnumMap[instance.language]!,
    };

const _$LanguageInLanguageEnumEnumMap = {
  LanguageInLanguageEnum.en: 'en',
  LanguageInLanguageEnum.hi: 'hi',
  LanguageInLanguageEnum.or: 'or',
};
