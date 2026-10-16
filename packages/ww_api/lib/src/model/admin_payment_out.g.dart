// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_payment_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminPaymentOutCWProxy {
  AdminPaymentOut id(String id);

  AdminPaymentOut bookingId(String bookingId);

  AdminPaymentOut bookingCode(String bookingCode);

  AdminPaymentOut amountPaise(int amountPaise);

  AdminPaymentOut status(String status);

  AdminPaymentOut method(String method);

  AdminPaymentOut mode(String mode);

  AdminPaymentOut razorpayOrderId(String razorpayOrderId);

  AdminPaymentOut razorpayPaymentId(String razorpayPaymentId);

  AdminPaymentOut createdAt(DateTime createdAt);

  AdminPaymentOut capturedAt(DateTime? capturedAt);

  AdminPaymentOut failureReason(String failureReason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPaymentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPaymentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPaymentOut call({
    String id,
    String bookingId,
    String bookingCode,
    int amountPaise,
    String status,
    String method,
    String mode,
    String razorpayOrderId,
    String razorpayPaymentId,
    DateTime createdAt,
    DateTime? capturedAt,
    String failureReason,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminPaymentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminPaymentOut.copyWith.fieldName(...)`
class _$AdminPaymentOutCWProxyImpl implements _$AdminPaymentOutCWProxy {
  const _$AdminPaymentOutCWProxyImpl(this._value);

  final AdminPaymentOut _value;

  @override
  AdminPaymentOut id(String id) => this(id: id);

  @override
  AdminPaymentOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  AdminPaymentOut bookingCode(String bookingCode) =>
      this(bookingCode: bookingCode);

  @override
  AdminPaymentOut amountPaise(int amountPaise) =>
      this(amountPaise: amountPaise);

  @override
  AdminPaymentOut status(String status) => this(status: status);

  @override
  AdminPaymentOut method(String method) => this(method: method);

  @override
  AdminPaymentOut mode(String mode) => this(mode: mode);

  @override
  AdminPaymentOut razorpayOrderId(String razorpayOrderId) =>
      this(razorpayOrderId: razorpayOrderId);

  @override
  AdminPaymentOut razorpayPaymentId(String razorpayPaymentId) =>
      this(razorpayPaymentId: razorpayPaymentId);

  @override
  AdminPaymentOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AdminPaymentOut capturedAt(DateTime? capturedAt) =>
      this(capturedAt: capturedAt);

  @override
  AdminPaymentOut failureReason(String failureReason) =>
      this(failureReason: failureReason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminPaymentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminPaymentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminPaymentOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? bookingCode = const $CopyWithPlaceholder(),
    Object? amountPaise = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? method = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? razorpayOrderId = const $CopyWithPlaceholder(),
    Object? razorpayPaymentId = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? capturedAt = const $CopyWithPlaceholder(),
    Object? failureReason = const $CopyWithPlaceholder(),
  }) {
    return AdminPaymentOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
      bookingCode: bookingCode == const $CopyWithPlaceholder()
          ? _value.bookingCode
          // ignore: cast_nullable_to_non_nullable
          : bookingCode as String,
      amountPaise: amountPaise == const $CopyWithPlaceholder()
          ? _value.amountPaise
          // ignore: cast_nullable_to_non_nullable
          : amountPaise as int,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      method: method == const $CopyWithPlaceholder()
          ? _value.method
          // ignore: cast_nullable_to_non_nullable
          : method as String,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as String,
      razorpayOrderId: razorpayOrderId == const $CopyWithPlaceholder()
          ? _value.razorpayOrderId
          // ignore: cast_nullable_to_non_nullable
          : razorpayOrderId as String,
      razorpayPaymentId: razorpayPaymentId == const $CopyWithPlaceholder()
          ? _value.razorpayPaymentId
          // ignore: cast_nullable_to_non_nullable
          : razorpayPaymentId as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      capturedAt: capturedAt == const $CopyWithPlaceholder()
          ? _value.capturedAt
          // ignore: cast_nullable_to_non_nullable
          : capturedAt as DateTime?,
      failureReason: failureReason == const $CopyWithPlaceholder()
          ? _value.failureReason
          // ignore: cast_nullable_to_non_nullable
          : failureReason as String,
    );
  }
}

extension $AdminPaymentOutCopyWith on AdminPaymentOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminPaymentOut.copyWith(...)` or like so:`instanceOfAdminPaymentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminPaymentOutCWProxy get copyWith => _$AdminPaymentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminPaymentOut _$AdminPaymentOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminPaymentOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'bookingId',
      'bookingCode',
      'amountPaise',
      'status',
      'method',
      'mode',
      'razorpayOrderId',
      'razorpayPaymentId',
      'createdAt',
      'capturedAt',
      'failureReason',
    ],
  );
  final val = AdminPaymentOut(
    id: $checkedConvert('id', (v) => v as String),
    bookingId: $checkedConvert('bookingId', (v) => v as String),
    bookingCode: $checkedConvert('bookingCode', (v) => v as String),
    amountPaise: $checkedConvert('amountPaise', (v) => (v as num).toInt()),
    status: $checkedConvert('status', (v) => v as String),
    method: $checkedConvert('method', (v) => v as String),
    mode: $checkedConvert('mode', (v) => v as String),
    razorpayOrderId: $checkedConvert('razorpayOrderId', (v) => v as String),
    razorpayPaymentId: $checkedConvert('razorpayPaymentId', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    capturedAt: $checkedConvert(
      'capturedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    failureReason: $checkedConvert('failureReason', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AdminPaymentOutToJson(AdminPaymentOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'bookingCode': instance.bookingCode,
      'amountPaise': instance.amountPaise,
      'status': instance.status,
      'method': instance.method,
      'mode': instance.mode,
      'razorpayOrderId': instance.razorpayOrderId,
      'razorpayPaymentId': instance.razorpayPaymentId,
      'createdAt': instance.createdAt.toIso8601String(),
      'capturedAt': instance.capturedAt?.toIso8601String(),
      'failureReason': instance.failureReason,
    };
