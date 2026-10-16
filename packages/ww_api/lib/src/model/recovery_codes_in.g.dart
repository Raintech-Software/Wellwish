// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_codes_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecoveryCodesInCWProxy {
  RecoveryCodesIn password(String password);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryCodesIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryCodesIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryCodesIn call({String password});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecoveryCodesIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecoveryCodesIn.copyWith.fieldName(...)`
class _$RecoveryCodesInCWProxyImpl implements _$RecoveryCodesInCWProxy {
  const _$RecoveryCodesInCWProxyImpl(this._value);

  final RecoveryCodesIn _value;

  @override
  RecoveryCodesIn password(String password) => this(password: password);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryCodesIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryCodesIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryCodesIn call({Object? password = const $CopyWithPlaceholder()}) {
    return RecoveryCodesIn(
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String,
    );
  }
}

extension $RecoveryCodesInCopyWith on RecoveryCodesIn {
  /// Returns a callable class that can be used as follows: `instanceOfRecoveryCodesIn.copyWith(...)` or like so:`instanceOfRecoveryCodesIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecoveryCodesInCWProxy get copyWith => _$RecoveryCodesInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryCodesIn _$RecoveryCodesInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RecoveryCodesIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['password']);
      final val = RecoveryCodesIn(
        password: $checkedConvert('password', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RecoveryCodesInToJson(RecoveryCodesIn instance) =>
    <String, dynamic>{'password': instance.password};
