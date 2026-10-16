// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_recovery_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffRecoveryInCWProxy {
  StaffRecoveryIn challengeToken(String challengeToken);

  StaffRecoveryIn code(String code);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffRecoveryIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffRecoveryIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffRecoveryIn call({String challengeToken, String code});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffRecoveryIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffRecoveryIn.copyWith.fieldName(...)`
class _$StaffRecoveryInCWProxyImpl implements _$StaffRecoveryInCWProxy {
  const _$StaffRecoveryInCWProxyImpl(this._value);

  final StaffRecoveryIn _value;

  @override
  StaffRecoveryIn challengeToken(String challengeToken) =>
      this(challengeToken: challengeToken);

  @override
  StaffRecoveryIn code(String code) => this(code: code);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffRecoveryIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffRecoveryIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffRecoveryIn call({
    Object? challengeToken = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
  }) {
    return StaffRecoveryIn(
      challengeToken: challengeToken == const $CopyWithPlaceholder()
          ? _value.challengeToken
          // ignore: cast_nullable_to_non_nullable
          : challengeToken as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
    );
  }
}

extension $StaffRecoveryInCopyWith on StaffRecoveryIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffRecoveryIn.copyWith(...)` or like so:`instanceOfStaffRecoveryIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffRecoveryInCWProxy get copyWith => _$StaffRecoveryInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffRecoveryIn _$StaffRecoveryInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffRecoveryIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['challengeToken', 'code']);
      final val = StaffRecoveryIn(
        challengeToken: $checkedConvert('challengeToken', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffRecoveryInToJson(StaffRecoveryIn instance) =>
    <String, dynamic>{
      'challengeToken': instance.challengeToken,
      'code': instance.code,
    };
