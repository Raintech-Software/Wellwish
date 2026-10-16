// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EmailInCWProxy {
  EmailIn email(String email);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmailIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmailIn(...).copyWith(id: 12, name: "My name")
  /// ````
  EmailIn call({String email});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEmailIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEmailIn.copyWith.fieldName(...)`
class _$EmailInCWProxyImpl implements _$EmailInCWProxy {
  const _$EmailInCWProxyImpl(this._value);

  final EmailIn _value;

  @override
  EmailIn email(String email) => this(email: email);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EmailIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EmailIn(...).copyWith(id: 12, name: "My name")
  /// ````
  EmailIn call({Object? email = const $CopyWithPlaceholder()}) {
    return EmailIn(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
    );
  }
}

extension $EmailInCopyWith on EmailIn {
  /// Returns a callable class that can be used as follows: `instanceOfEmailIn.copyWith(...)` or like so:`instanceOfEmailIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EmailInCWProxy get copyWith => _$EmailInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailIn _$EmailInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EmailIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['email']);
      final val = EmailIn(email: $checkedConvert('email', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$EmailInToJson(EmailIn instance) => <String, dynamic>{
  'email': instance.email,
};
