// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingInCWProxy {
  BookingIn serviceId(String serviceId);

  BookingIn memberId(String memberId);

  BookingIn addressId(String addressId);

  BookingIn pickupAt(DateTime pickupAt);

  BookingIn appointmentAt(DateTime? appointmentAt);

  BookingIn hospitalId(String? hospitalId);

  BookingIn hospitalText(String? hospitalText);

  BookingIn doctorId(String? doctorId);

  BookingIn documentIds(List<String>? documentIds);

  BookingIn notes(String? notes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingIn call({
    String serviceId,
    String memberId,
    String addressId,
    DateTime pickupAt,
    DateTime? appointmentAt,
    String? hospitalId,
    String? hospitalText,
    String? doctorId,
    List<String>? documentIds,
    String? notes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingIn.copyWith.fieldName(...)`
class _$BookingInCWProxyImpl implements _$BookingInCWProxy {
  const _$BookingInCWProxyImpl(this._value);

  final BookingIn _value;

  @override
  BookingIn serviceId(String serviceId) => this(serviceId: serviceId);

  @override
  BookingIn memberId(String memberId) => this(memberId: memberId);

  @override
  BookingIn addressId(String addressId) => this(addressId: addressId);

  @override
  BookingIn pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  BookingIn appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  BookingIn hospitalId(String? hospitalId) => this(hospitalId: hospitalId);

  @override
  BookingIn hospitalText(String? hospitalText) =>
      this(hospitalText: hospitalText);

  @override
  BookingIn doctorId(String? doctorId) => this(doctorId: doctorId);

  @override
  BookingIn documentIds(List<String>? documentIds) =>
      this(documentIds: documentIds);

  @override
  BookingIn notes(String? notes) => this(notes: notes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingIn call({
    Object? serviceId = const $CopyWithPlaceholder(),
    Object? memberId = const $CopyWithPlaceholder(),
    Object? addressId = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
    Object? hospitalId = const $CopyWithPlaceholder(),
    Object? hospitalText = const $CopyWithPlaceholder(),
    Object? doctorId = const $CopyWithPlaceholder(),
    Object? documentIds = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
  }) {
    return BookingIn(
      serviceId: serviceId == const $CopyWithPlaceholder()
          ? _value.serviceId
          // ignore: cast_nullable_to_non_nullable
          : serviceId as String,
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String,
      addressId: addressId == const $CopyWithPlaceholder()
          ? _value.addressId
          // ignore: cast_nullable_to_non_nullable
          : addressId as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      appointmentAt: appointmentAt == const $CopyWithPlaceholder()
          ? _value.appointmentAt
          // ignore: cast_nullable_to_non_nullable
          : appointmentAt as DateTime?,
      hospitalId: hospitalId == const $CopyWithPlaceholder()
          ? _value.hospitalId
          // ignore: cast_nullable_to_non_nullable
          : hospitalId as String?,
      hospitalText: hospitalText == const $CopyWithPlaceholder()
          ? _value.hospitalText
          // ignore: cast_nullable_to_non_nullable
          : hospitalText as String?,
      doctorId: doctorId == const $CopyWithPlaceholder()
          ? _value.doctorId
          // ignore: cast_nullable_to_non_nullable
          : doctorId as String?,
      documentIds: documentIds == const $CopyWithPlaceholder()
          ? _value.documentIds
          // ignore: cast_nullable_to_non_nullable
          : documentIds as List<String>?,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String?,
    );
  }
}

extension $BookingInCopyWith on BookingIn {
  /// Returns a callable class that can be used as follows: `instanceOfBookingIn.copyWith(...)` or like so:`instanceOfBookingIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingInCWProxy get copyWith => _$BookingInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingIn _$BookingInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'BookingIn',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const ['serviceId', 'memberId', 'addressId', 'pickupAt'],
    );
    final val = BookingIn(
      serviceId: $checkedConvert('serviceId', (v) => v as String),
      memberId: $checkedConvert('memberId', (v) => v as String),
      addressId: $checkedConvert('addressId', (v) => v as String),
      pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
      appointmentAt: $checkedConvert(
        'appointmentAt',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      hospitalId: $checkedConvert('hospitalId', (v) => v as String?),
      hospitalText: $checkedConvert('hospitalText', (v) => v as String? ?? ''),
      doctorId: $checkedConvert('doctorId', (v) => v as String?),
      documentIds: $checkedConvert(
        'documentIds',
        (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
      ),
      notes: $checkedConvert('notes', (v) => v as String? ?? ''),
    );
    return val;
  },
);

Map<String, dynamic> _$BookingInToJson(BookingIn instance) => <String, dynamic>{
  'serviceId': instance.serviceId,
  'memberId': instance.memberId,
  'addressId': instance.addressId,
  'pickupAt': instance.pickupAt.toIso8601String(),
  'appointmentAt': ?instance.appointmentAt?.toIso8601String(),
  'hospitalId': ?instance.hospitalId,
  'hospitalText': ?instance.hospitalText,
  'doctorId': ?instance.doctorId,
  'documentIds': ?instance.documentIds,
  'notes': ?instance.notes,
};
