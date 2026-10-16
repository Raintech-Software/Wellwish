// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PhoneOutCWProxy {
  PhoneOut kind(String kind);

  PhoneOut phone(String phone);

  PhoneOut verified(bool verified);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneOut call({String kind, String phone, bool verified});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPhoneOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPhoneOut.copyWith.fieldName(...)`
class _$PhoneOutCWProxyImpl implements _$PhoneOutCWProxy {
  const _$PhoneOutCWProxyImpl(this._value);

  final PhoneOut _value;

  @override
  PhoneOut kind(String kind) => this(kind: kind);

  @override
  PhoneOut phone(String phone) => this(phone: phone);

  @override
  PhoneOut verified(bool verified) => this(verified: verified);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneOut call({
    Object? kind = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? verified = const $CopyWithPlaceholder(),
  }) {
    return PhoneOut(
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      verified: verified == const $CopyWithPlaceholder()
          ? _value.verified
          // ignore: cast_nullable_to_non_nullable
          : verified as bool,
    );
  }
}

extension $PhoneOutCopyWith on PhoneOut {
  /// Returns a callable class that can be used as follows: `instanceOfPhoneOut.copyWith(...)` or like so:`instanceOfPhoneOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PhoneOutCWProxy get copyWith => _$PhoneOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneOut _$PhoneOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PhoneOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['kind', 'phone', 'verified']);
      final val = PhoneOut(
        kind: $checkedConvert('kind', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        verified: $checkedConvert('verified', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PhoneOutToJson(PhoneOut instance) => <String, dynamic>{
  'kind': instance.kind,
  'phone': instance.phone,
  'verified': instance.verified,
};
