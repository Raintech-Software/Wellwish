// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_email_code_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffEmailCodeOutCWProxy {
  StaffEmailCodeOut challengeToken(String challengeToken);

  StaffEmailCodeOut emailMasked(String emailMasked);

  StaffEmailCodeOut resendAfterSeconds(int resendAfterSeconds);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffEmailCodeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffEmailCodeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffEmailCodeOut call({
    String challengeToken,
    String emailMasked,
    int resendAfterSeconds,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffEmailCodeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffEmailCodeOut.copyWith.fieldName(...)`
class _$StaffEmailCodeOutCWProxyImpl implements _$StaffEmailCodeOutCWProxy {
  const _$StaffEmailCodeOutCWProxyImpl(this._value);

  final StaffEmailCodeOut _value;

  @override
  StaffEmailCodeOut challengeToken(String challengeToken) =>
      this(challengeToken: challengeToken);

  @override
  StaffEmailCodeOut emailMasked(String emailMasked) =>
      this(emailMasked: emailMasked);

  @override
  StaffEmailCodeOut resendAfterSeconds(int resendAfterSeconds) =>
      this(resendAfterSeconds: resendAfterSeconds);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffEmailCodeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffEmailCodeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffEmailCodeOut call({
    Object? challengeToken = const $CopyWithPlaceholder(),
    Object? emailMasked = const $CopyWithPlaceholder(),
    Object? resendAfterSeconds = const $CopyWithPlaceholder(),
  }) {
    return StaffEmailCodeOut(
      challengeToken: challengeToken == const $CopyWithPlaceholder()
          ? _value.challengeToken
          // ignore: cast_nullable_to_non_nullable
          : challengeToken as String,
      emailMasked: emailMasked == const $CopyWithPlaceholder()
          ? _value.emailMasked
          // ignore: cast_nullable_to_non_nullable
          : emailMasked as String,
      resendAfterSeconds: resendAfterSeconds == const $CopyWithPlaceholder()
          ? _value.resendAfterSeconds
          // ignore: cast_nullable_to_non_nullable
          : resendAfterSeconds as int,
    );
  }
}

extension $StaffEmailCodeOutCopyWith on StaffEmailCodeOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffEmailCodeOut.copyWith(...)` or like so:`instanceOfStaffEmailCodeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffEmailCodeOutCWProxy get copyWith =>
      _$StaffEmailCodeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffEmailCodeOut _$StaffEmailCodeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffEmailCodeOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'challengeToken',
          'emailMasked',
          'resendAfterSeconds',
        ],
      );
      final val = StaffEmailCodeOut(
        challengeToken: $checkedConvert('challengeToken', (v) => v as String),
        emailMasked: $checkedConvert('emailMasked', (v) => v as String),
        resendAfterSeconds: $checkedConvert(
          'resendAfterSeconds',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffEmailCodeOutToJson(StaffEmailCodeOut instance) =>
    <String, dynamic>{
      'challengeToken': instance.challengeToken,
      'emailMasked': instance.emailMasked,
      'resendAfterSeconds': instance.resendAfterSeconds,
    };
