// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_refund_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingRefundOutCWProxy {
  BookingRefundOut amountPaise(int amountPaise);

  BookingRefundOut percent(int percent);

  BookingRefundOut status(String status);

  BookingRefundOut createdAt(DateTime createdAt);

  BookingRefundOut processedAt(DateTime? processedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingRefundOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingRefundOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingRefundOut call({
    int amountPaise,
    int percent,
    String status,
    DateTime createdAt,
    DateTime? processedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingRefundOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingRefundOut.copyWith.fieldName(...)`
class _$BookingRefundOutCWProxyImpl implements _$BookingRefundOutCWProxy {
  const _$BookingRefundOutCWProxyImpl(this._value);

  final BookingRefundOut _value;

  @override
  BookingRefundOut amountPaise(int amountPaise) =>
      this(amountPaise: amountPaise);

  @override
  BookingRefundOut percent(int percent) => this(percent: percent);

  @override
  BookingRefundOut status(String status) => this(status: status);

  @override
  BookingRefundOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  BookingRefundOut processedAt(DateTime? processedAt) =>
      this(processedAt: processedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingRefundOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingRefundOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingRefundOut call({
    Object? amountPaise = const $CopyWithPlaceholder(),
    Object? percent = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? processedAt = const $CopyWithPlaceholder(),
  }) {
    return BookingRefundOut(
      amountPaise: amountPaise == const $CopyWithPlaceholder()
          ? _value.amountPaise
          // ignore: cast_nullable_to_non_nullable
          : amountPaise as int,
      percent: percent == const $CopyWithPlaceholder()
          ? _value.percent
          // ignore: cast_nullable_to_non_nullable
          : percent as int,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      processedAt: processedAt == const $CopyWithPlaceholder()
          ? _value.processedAt
          // ignore: cast_nullable_to_non_nullable
          : processedAt as DateTime?,
    );
  }
}

extension $BookingRefundOutCopyWith on BookingRefundOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingRefundOut.copyWith(...)` or like so:`instanceOfBookingRefundOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingRefundOutCWProxy get copyWith => _$BookingRefundOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingRefundOut _$BookingRefundOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingRefundOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'amountPaise',
          'percent',
          'status',
          'createdAt',
          'processedAt',
        ],
      );
      final val = BookingRefundOut(
        amountPaise: $checkedConvert('amountPaise', (v) => (v as num).toInt()),
        percent: $checkedConvert('percent', (v) => (v as num).toInt()),
        status: $checkedConvert('status', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        processedAt: $checkedConvert(
          'processedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BookingRefundOutToJson(BookingRefundOut instance) =>
    <String, dynamic>{
      'amountPaise': instance.amountPaise,
      'percent': instance.percent,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'processedAt': instance.processedAt?.toIso8601String(),
    };
