// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_email_code_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffEmailCodeInCWProxy {
  StaffEmailCodeIn challengeToken(String challengeToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffEmailCodeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffEmailCodeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffEmailCodeIn call({String challengeToken});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffEmailCodeIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffEmailCodeIn.copyWith.fieldName(...)`
class _$StaffEmailCodeInCWProxyImpl implements _$StaffEmailCodeInCWProxy {
  const _$StaffEmailCodeInCWProxyImpl(this._value);

  final StaffEmailCodeIn _value;

  @override
  StaffEmailCodeIn challengeToken(String challengeToken) =>
      this(challengeToken: challengeToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffEmailCodeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffEmailCodeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffEmailCodeIn call({
    Object? challengeToken = const $CopyWithPlaceholder(),
  }) {
    return StaffEmailCodeIn(
      challengeToken: challengeToken == const $CopyWithPlaceholder()
          ? _value.challengeToken
          // ignore: cast_nullable_to_non_nullable
          : challengeToken as String,
    );
  }
}

extension $StaffEmailCodeInCopyWith on StaffEmailCodeIn {
  /// Returns a callable class that can be used as follows: `instanceOfStaffEmailCodeIn.copyWith(...)` or like so:`instanceOfStaffEmailCodeIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffEmailCodeInCWProxy get copyWith => _$StaffEmailCodeInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffEmailCodeIn _$StaffEmailCodeInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffEmailCodeIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['challengeToken']);
      final val = StaffEmailCodeIn(
        challengeToken: $checkedConvert('challengeToken', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$StaffEmailCodeInToJson(StaffEmailCodeIn instance) =>
    <String, dynamic>{'challengeToken': instance.challengeToken};
