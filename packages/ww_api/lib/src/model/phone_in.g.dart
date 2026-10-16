// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PhoneInCWProxy {
  PhoneIn phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneIn call({String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPhoneIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPhoneIn.copyWith.fieldName(...)`
class _$PhoneInCWProxyImpl implements _$PhoneInCWProxy {
  const _$PhoneInCWProxyImpl(this._value);

  final PhoneIn _value;

  @override
  PhoneIn phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PhoneIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PhoneIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PhoneIn call({Object? phone = const $CopyWithPlaceholder()}) {
    return PhoneIn(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $PhoneInCopyWith on PhoneIn {
  /// Returns a callable class that can be used as follows: `instanceOfPhoneIn.copyWith(...)` or like so:`instanceOfPhoneIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PhoneInCWProxy get copyWith => _$PhoneInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneIn _$PhoneInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PhoneIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['phone']);
      final val = PhoneIn(phone: $checkedConvert('phone', (v) => v as String));
      return val;
    });

Map<String, dynamic> _$PhoneInToJson(PhoneIn instance) => <String, dynamic>{
  'phone': instance.phone,
};
