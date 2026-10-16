// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VerifyInCWProxy {
  VerifyIn razorpayOrderId(String razorpayOrderId);

  VerifyIn razorpayPaymentId(String razorpayPaymentId);

  VerifyIn razorpaySignature(String razorpaySignature);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerifyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerifyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  VerifyIn call({
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVerifyIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVerifyIn.copyWith.fieldName(...)`
class _$VerifyInCWProxyImpl implements _$VerifyInCWProxy {
  const _$VerifyInCWProxyImpl(this._value);

  final VerifyIn _value;

  @override
  VerifyIn razorpayOrderId(String razorpayOrderId) =>
      this(razorpayOrderId: razorpayOrderId);

  @override
  VerifyIn razorpayPaymentId(String razorpayPaymentId) =>
      this(razorpayPaymentId: razorpayPaymentId);

  @override
  VerifyIn razorpaySignature(String razorpaySignature) =>
      this(razorpaySignature: razorpaySignature);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VerifyIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VerifyIn(...).copyWith(id: 12, name: "My name")
  /// ````
  VerifyIn call({
    Object? razorpayOrderId = const $CopyWithPlaceholder(),
    Object? razorpayPaymentId = const $CopyWithPlaceholder(),
    Object? razorpaySignature = const $CopyWithPlaceholder(),
  }) {
    return VerifyIn(
      razorpayOrderId: razorpayOrderId == const $CopyWithPlaceholder()
          ? _value.razorpayOrderId
          // ignore: cast_nullable_to_non_nullable
          : razorpayOrderId as String,
      razorpayPaymentId: razorpayPaymentId == const $CopyWithPlaceholder()
          ? _value.razorpayPaymentId
          // ignore: cast_nullable_to_non_nullable
          : razorpayPaymentId as String,
      razorpaySignature: razorpaySignature == const $CopyWithPlaceholder()
          ? _value.razorpaySignature
          // ignore: cast_nullable_to_non_nullable
          : razorpaySignature as String,
    );
  }
}

extension $VerifyInCopyWith on VerifyIn {
  /// Returns a callable class that can be used as follows: `instanceOfVerifyIn.copyWith(...)` or like so:`instanceOfVerifyIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VerifyInCWProxy get copyWith => _$VerifyInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyIn _$VerifyInFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('VerifyIn', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'razorpayOrderId',
      'razorpayPaymentId',
      'razorpaySignature',
    ],
  );
  final val = VerifyIn(
    razorpayOrderId: $checkedConvert('razorpayOrderId', (v) => v as String),
    razorpayPaymentId: $checkedConvert('razorpayPaymentId', (v) => v as String),
    razorpaySignature: $checkedConvert('razorpaySignature', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$VerifyInToJson(VerifyIn instance) => <String, dynamic>{
  'razorpayOrderId': instance.razorpayOrderId,
  'razorpayPaymentId': instance.razorpayPaymentId,
  'razorpaySignature': instance.razorpaySignature,
};
