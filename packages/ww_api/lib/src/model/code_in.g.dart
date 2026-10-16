// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CodeInCWProxy {
  CodeIn code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CodeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CodeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CodeIn call({String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCodeIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCodeIn.copyWith.fieldName(...)`
class _$CodeInCWProxyImpl implements _$CodeInCWProxy {
  const _$CodeInCWProxyImpl(this._value);

  final CodeIn _value;

  @override
  CodeIn code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CodeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CodeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CodeIn call({Object? code = const $CopyWithPlaceholder()}) {
    return CodeIn(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $CodeInCopyWith on CodeIn {
  /// Returns a callable class that can be used as follows: `instanceOfCodeIn.copyWith(...)` or like so:`instanceOfCodeIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CodeInCWProxy get copyWith => _$CodeInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeIn _$CodeInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CodeIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code']);
      final val = CodeIn(code: $checkedConvert('code', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$CodeInToJson(CodeIn instance) => <String, dynamic>{
  'code': instance.code,
};
