// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CheckoutOutCWProxy {
  CheckoutOut keyId(String keyId);

  CheckoutOut orderId(String orderId);

  CheckoutOut amountPaise(int amountPaise);

  CheckoutOut currency(String currency);

  CheckoutOut bookingCode(String bookingCode);

  CheckoutOut payBy(DateTime payBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckoutOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckoutOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckoutOut call({
    String keyId,
    String orderId,
    int amountPaise,
    String currency,
    String bookingCode,
    DateTime payBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCheckoutOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCheckoutOut.copyWith.fieldName(...)`
class _$CheckoutOutCWProxyImpl implements _$CheckoutOutCWProxy {
  const _$CheckoutOutCWProxyImpl(this._value);

  final CheckoutOut _value;

  @override
  CheckoutOut keyId(String keyId) => this(keyId: keyId);

  @override
  CheckoutOut orderId(String orderId) => this(orderId: orderId);

  @override
  CheckoutOut amountPaise(int amountPaise) => this(amountPaise: amountPaise);

  @override
  CheckoutOut currency(String currency) => this(currency: currency);

  @override
  CheckoutOut bookingCode(String bookingCode) => this(bookingCode: bookingCode);

  @override
  CheckoutOut payBy(DateTime payBy) => this(payBy: payBy);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckoutOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckoutOut(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckoutOut call({
    Object? keyId = const $CopyWithPlaceholder(),
    Object? orderId = const $CopyWithPlaceholder(),
    Object? amountPaise = const $CopyWithPlaceholder(),
    Object? currency = const $CopyWithPlaceholder(),
    Object? bookingCode = const $CopyWithPlaceholder(),
    Object? payBy = const $CopyWithPlaceholder(),
  }) {
    return CheckoutOut(
      keyId: keyId == const $CopyWithPlaceholder()
          ? _value.keyId
          // ignore: cast_nullable_to_non_nullable
          : keyId as String,
      orderId: orderId == const $CopyWithPlaceholder()
          ? _value.orderId
          // ignore: cast_nullable_to_non_nullable
          : orderId as String,
      amountPaise: amountPaise == const $CopyWithPlaceholder()
          ? _value.amountPaise
          // ignore: cast_nullable_to_non_nullable
          : amountPaise as int,
      currency: currency == const $CopyWithPlaceholder()
          ? _value.currency
          // ignore: cast_nullable_to_non_nullable
          : currency as String,
      bookingCode: bookingCode == const $CopyWithPlaceholder()
          ? _value.bookingCode
          // ignore: cast_nullable_to_non_nullable
          : bookingCode as String,
      payBy: payBy == const $CopyWithPlaceholder()
          ? _value.payBy
          // ignore: cast_nullable_to_non_nullable
          : payBy as DateTime,
    );
  }
}

extension $CheckoutOutCopyWith on CheckoutOut {
  /// Returns a callable class that can be used as follows: `instanceOfCheckoutOut.copyWith(...)` or like so:`instanceOfCheckoutOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CheckoutOutCWProxy get copyWith => _$CheckoutOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutOut _$CheckoutOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CheckoutOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'keyId',
          'orderId',
          'amountPaise',
          'currency',
          'bookingCode',
          'payBy',
        ],
      );
      final val = CheckoutOut(
        keyId: $checkedConvert('keyId', (v) => v as String),
        orderId: $checkedConvert('orderId', (v) => v as String),
        amountPaise: $checkedConvert('amountPaise', (v) => (v as num).toInt()),
        currency: $checkedConvert('currency', (v) => v as String),
        bookingCode: $checkedConvert('bookingCode', (v) => v as String),
        payBy: $checkedConvert('payBy', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$CheckoutOutToJson(CheckoutOut instance) =>
    <String, dynamic>{
      'keyId': instance.keyId,
      'orderId': instance.orderId,
      'amountPaise': instance.amountPaise,
      'currency': instance.currency,
      'bookingCode': instance.bookingCode,
      'payBy': instance.payBy.toIso8601String(),
    };
