// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_codes_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecoveryCodesOutCWProxy {
  RecoveryCodesOut codes(List<String> codes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryCodesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryCodesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryCodesOut call({List<String> codes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecoveryCodesOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecoveryCodesOut.copyWith.fieldName(...)`
class _$RecoveryCodesOutCWProxyImpl implements _$RecoveryCodesOutCWProxy {
  const _$RecoveryCodesOutCWProxyImpl(this._value);

  final RecoveryCodesOut _value;

  @override
  RecoveryCodesOut codes(List<String> codes) => this(codes: codes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryCodesOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryCodesOut(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryCodesOut call({Object? codes = const $CopyWithPlaceholder()}) {
    return RecoveryCodesOut(
      codes: codes == const $CopyWithPlaceholder()
          ? _value.codes
          // ignore: cast_nullable_to_non_nullable
          : codes as List<String>,
    );
  }
}

extension $RecoveryCodesOutCopyWith on RecoveryCodesOut {
  /// Returns a callable class that can be used as follows: `instanceOfRecoveryCodesOut.copyWith(...)` or like so:`instanceOfRecoveryCodesOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecoveryCodesOutCWProxy get copyWith => _$RecoveryCodesOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryCodesOut _$RecoveryCodesOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RecoveryCodesOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['codes']);
      final val = RecoveryCodesOut(
        codes: $checkedConvert(
          'codes',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RecoveryCodesOutToJson(RecoveryCodesOut instance) =>
    <String, dynamic>{'codes': instance.codes};
