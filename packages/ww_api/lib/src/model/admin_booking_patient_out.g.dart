// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_booking_patient_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminBookingPatientOutCWProxy {
  AdminBookingPatientOut id(String id);

  AdminBookingPatientOut fullName(String fullName);

  AdminBookingPatientOut phone(String phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingPatientOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingPatientOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingPatientOut call({String id, String fullName, String phone});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminBookingPatientOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminBookingPatientOut.copyWith.fieldName(...)`
class _$AdminBookingPatientOutCWProxyImpl
    implements _$AdminBookingPatientOutCWProxy {
  const _$AdminBookingPatientOutCWProxyImpl(this._value);

  final AdminBookingPatientOut _value;

  @override
  AdminBookingPatientOut id(String id) => this(id: id);

  @override
  AdminBookingPatientOut fullName(String fullName) => this(fullName: fullName);

  @override
  AdminBookingPatientOut phone(String phone) => this(phone: phone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingPatientOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingPatientOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingPatientOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
  }) {
    return AdminBookingPatientOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
    );
  }
}

extension $AdminBookingPatientOutCopyWith on AdminBookingPatientOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminBookingPatientOut.copyWith(...)` or like so:`instanceOfAdminBookingPatientOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminBookingPatientOutCWProxy get copyWith =>
      _$AdminBookingPatientOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminBookingPatientOut _$AdminBookingPatientOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminBookingPatientOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'fullName', 'phone']);
  final val = AdminBookingPatientOut(
    id: $checkedConvert('id', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AdminBookingPatientOutToJson(
  AdminBookingPatientOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'phone': instance.phone,
};
