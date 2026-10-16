// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_token_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StaffTokenOutCWProxy {
  StaffTokenOut accessToken(String accessToken);

  StaffTokenOut expiresIn(int expiresIn);

  StaffTokenOut staff(StaffMeOut staff);

  StaffTokenOut recoveryCodes(List<String>? recoveryCodes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffTokenOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffTokenOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffTokenOut call({
    String accessToken,
    int expiresIn,
    StaffMeOut staff,
    List<String>? recoveryCodes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStaffTokenOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStaffTokenOut.copyWith.fieldName(...)`
class _$StaffTokenOutCWProxyImpl implements _$StaffTokenOutCWProxy {
  const _$StaffTokenOutCWProxyImpl(this._value);

  final StaffTokenOut _value;

  @override
  StaffTokenOut accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  StaffTokenOut expiresIn(int expiresIn) => this(expiresIn: expiresIn);

  @override
  StaffTokenOut staff(StaffMeOut staff) => this(staff: staff);

  @override
  StaffTokenOut recoveryCodes(List<String>? recoveryCodes) =>
      this(recoveryCodes: recoveryCodes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StaffTokenOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StaffTokenOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StaffTokenOut call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? expiresIn = const $CopyWithPlaceholder(),
    Object? staff = const $CopyWithPlaceholder(),
    Object? recoveryCodes = const $CopyWithPlaceholder(),
  }) {
    return StaffTokenOut(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String,
      expiresIn: expiresIn == const $CopyWithPlaceholder()
          ? _value.expiresIn
          // ignore: cast_nullable_to_non_nullable
          : expiresIn as int,
      staff: staff == const $CopyWithPlaceholder()
          ? _value.staff
          // ignore: cast_nullable_to_non_nullable
          : staff as StaffMeOut,
      recoveryCodes: recoveryCodes == const $CopyWithPlaceholder()
          ? _value.recoveryCodes
          // ignore: cast_nullable_to_non_nullable
          : recoveryCodes as List<String>?,
    );
  }
}

extension $StaffTokenOutCopyWith on StaffTokenOut {
  /// Returns a callable class that can be used as follows: `instanceOfStaffTokenOut.copyWith(...)` or like so:`instanceOfStaffTokenOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StaffTokenOutCWProxy get copyWith => _$StaffTokenOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffTokenOut _$StaffTokenOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StaffTokenOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['accessToken', 'expiresIn', 'staff'],
      );
      final val = StaffTokenOut(
        accessToken: $checkedConvert('accessToken', (v) => v as String),
        expiresIn: $checkedConvert('expiresIn', (v) => (v as num).toInt()),
        staff: $checkedConvert(
          'staff',
          (v) => StaffMeOut.fromJson(v as Map<String, dynamic>),
        ),
        recoveryCodes: $checkedConvert(
          'recoveryCodes',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StaffTokenOutToJson(StaffTokenOut instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresIn,
      'staff': instance.staff.toJson(),
      'recoveryCodes': ?instance.recoveryCodes,
    };
