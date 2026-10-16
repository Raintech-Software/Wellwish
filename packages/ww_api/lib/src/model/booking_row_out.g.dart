// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingRowOutCWProxy {
  BookingRowOut id(String id);

  BookingRowOut code(String code);

  BookingRowOut status(String status);

  BookingRowOut service(BookingServiceOut service);

  BookingRowOut memberName(String memberName);

  BookingRowOut pickupAt(DateTime pickupAt);

  BookingRowOut appointmentAt(DateTime? appointmentAt);

  BookingRowOut hospitalName(String hospitalName);

  BookingRowOut createdAt(DateTime createdAt);

  BookingRowOut payBy(DateTime? payBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingRowOut call({
    String id,
    String code,
    String status,
    BookingServiceOut service,
    String memberName,
    DateTime pickupAt,
    DateTime? appointmentAt,
    String hospitalName,
    DateTime createdAt,
    DateTime? payBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingRowOut.copyWith.fieldName(...)`
class _$BookingRowOutCWProxyImpl implements _$BookingRowOutCWProxy {
  const _$BookingRowOutCWProxyImpl(this._value);

  final BookingRowOut _value;

  @override
  BookingRowOut id(String id) => this(id: id);

  @override
  BookingRowOut code(String code) => this(code: code);

  @override
  BookingRowOut status(String status) => this(status: status);

  @override
  BookingRowOut service(BookingServiceOut service) => this(service: service);

  @override
  BookingRowOut memberName(String memberName) => this(memberName: memberName);

  @override
  BookingRowOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  BookingRowOut appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  BookingRowOut hospitalName(String hospitalName) =>
      this(hospitalName: hospitalName);

  @override
  BookingRowOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  BookingRowOut payBy(DateTime? payBy) => this(payBy: payBy);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingRowOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
    Object? hospitalName = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? payBy = const $CopyWithPlaceholder(),
  }) {
    return BookingRowOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      service: service == const $CopyWithPlaceholder()
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as BookingServiceOut,
      memberName: memberName == const $CopyWithPlaceholder()
          ? _value.memberName
          // ignore: cast_nullable_to_non_nullable
          : memberName as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      appointmentAt: appointmentAt == const $CopyWithPlaceholder()
          ? _value.appointmentAt
          // ignore: cast_nullable_to_non_nullable
          : appointmentAt as DateTime?,
      hospitalName: hospitalName == const $CopyWithPlaceholder()
          ? _value.hospitalName
          // ignore: cast_nullable_to_non_nullable
          : hospitalName as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      payBy: payBy == const $CopyWithPlaceholder()
          ? _value.payBy
          // ignore: cast_nullable_to_non_nullable
          : payBy as DateTime?,
    );
  }
}

extension $BookingRowOutCopyWith on BookingRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingRowOut.copyWith(...)` or like so:`instanceOfBookingRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingRowOutCWProxy get copyWith => _$BookingRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRowOut _$BookingRowOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookingRowOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'code',
      'status',
      'service',
      'memberName',
      'pickupAt',
      'appointmentAt',
      'hospitalName',
      'createdAt',
    ],
  );
  final val = BookingRowOut(
    id: $checkedConvert('id', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    service: $checkedConvert(
      'service',
      (v) => BookingServiceOut.fromJson(v as Map<String, dynamic>),
    ),
    memberName: $checkedConvert('memberName', (v) => v as String),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    appointmentAt: $checkedConvert(
      'appointmentAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    hospitalName: $checkedConvert('hospitalName', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    payBy: $checkedConvert(
      'payBy',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$BookingRowOutToJson(BookingRowOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'service': instance.service.toJson(),
      'memberName': instance.memberName,
      'pickupAt': instance.pickupAt.toIso8601String(),
      'appointmentAt': instance.appointmentAt?.toIso8601String(),
      'hospitalName': instance.hospitalName,
      'createdAt': instance.createdAt.toIso8601String(),
      'payBy': ?instance.payBy?.toIso8601String(),
    };
