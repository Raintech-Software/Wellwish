// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selfie_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SelfieInCWProxy {
  SelfieIn fileKey(String fileKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SelfieIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SelfieIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SelfieIn call({String fileKey});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSelfieIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSelfieIn.copyWith.fieldName(...)`
class _$SelfieInCWProxyImpl implements _$SelfieInCWProxy {
  const _$SelfieInCWProxyImpl(this._value);

  final SelfieIn _value;

  @override
  SelfieIn fileKey(String fileKey) => this(fileKey: fileKey);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SelfieIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SelfieIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SelfieIn call({Object? fileKey = const $CopyWithPlaceholder()}) {
    return SelfieIn(
      fileKey: fileKey == const $CopyWithPlaceholder()
          ? _value.fileKey
          // ignore: cast_nullable_to_non_nullable
          : fileKey as String,
    );
  }
}

extension $SelfieInCopyWith on SelfieIn {
  /// Returns a callable class that can be used as follows: `instanceOfSelfieIn.copyWith(...)` or like so:`instanceOfSelfieIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SelfieInCWProxy get copyWith => _$SelfieInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfieIn _$SelfieInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SelfieIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['fileKey']);
      final val = SelfieIn(
        fileKey: $checkedConvert('fileKey', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SelfieInToJson(SelfieIn instance) => <String, dynamic>{
  'fileKey': instance.fileKey,
};
