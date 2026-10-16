// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AlertOutCWProxy {
  AlertOut id(String id);

  AlertOut kind(String kind);

  AlertOut bookingId(String bookingId);

  AlertOut bookingCode(String bookingCode);

  AlertOut pickupAt(DateTime pickupAt);

  AlertOut details(Map<String, Object> details);

  AlertOut createdAt(DateTime createdAt);

  AlertOut acknowledgedAt(DateTime? acknowledgedAt);

  AlertOut partnerName(String partnerName);

  AlertOut phone(String phone);

  AlertOut alternatePhone(String alternatePhone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertOut call({
    String id,
    String kind,
    String bookingId,
    String bookingCode,
    DateTime pickupAt,
    Map<String, Object> details,
    DateTime createdAt,
    DateTime? acknowledgedAt,
    String partnerName,
    String phone,
    String alternatePhone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAlertOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAlertOut.copyWith.fieldName(...)`
class _$AlertOutCWProxyImpl implements _$AlertOutCWProxy {
  const _$AlertOutCWProxyImpl(this._value);

  final AlertOut _value;

  @override
  AlertOut id(String id) => this(id: id);

  @override
  AlertOut kind(String kind) => this(kind: kind);

  @override
  AlertOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  AlertOut bookingCode(String bookingCode) => this(bookingCode: bookingCode);

  @override
  AlertOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  AlertOut details(Map<String, Object> details) => this(details: details);

  @override
  AlertOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  AlertOut acknowledgedAt(DateTime? acknowledgedAt) =>
      this(acknowledgedAt: acknowledgedAt);

  @override
  AlertOut partnerName(String partnerName) => this(partnerName: partnerName);

  @override
  AlertOut phone(String phone) => this(phone: phone);

  @override
  AlertOut alternatePhone(String alternatePhone) =>
      this(alternatePhone: alternatePhone);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AlertOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AlertOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AlertOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? kind = const $CopyWithPlaceholder(),
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? bookingCode = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? details = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? acknowledgedAt = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? alternatePhone = const $CopyWithPlaceholder(),
  }) {
    return AlertOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      kind: kind == const $CopyWithPlaceholder()
          ? _value.kind
          // ignore: cast_nullable_to_non_nullable
          : kind as String,
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
      bookingCode: bookingCode == const $CopyWithPlaceholder()
          ? _value.bookingCode
          // ignore: cast_nullable_to_non_nullable
          : bookingCode as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      details: details == const $CopyWithPlaceholder()
          ? _value.details
          // ignore: cast_nullable_to_non_nullable
          : details as Map<String, Object>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      acknowledgedAt: acknowledgedAt == const $CopyWithPlaceholder()
          ? _value.acknowledgedAt
          // ignore: cast_nullable_to_non_nullable
          : acknowledgedAt as DateTime?,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      alternatePhone: alternatePhone == const $CopyWithPlaceholder()
          ? _value.alternatePhone
          // ignore: cast_nullable_to_non_nullable
          : alternatePhone as String,
    );
  }
}

extension $AlertOutCopyWith on AlertOut {
  /// Returns a callable class that can be used as follows: `instanceOfAlertOut.copyWith(...)` or like so:`instanceOfAlertOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AlertOutCWProxy get copyWith => _$AlertOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertOut _$AlertOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AlertOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'kind',
      'bookingId',
      'bookingCode',
      'pickupAt',
      'details',
      'createdAt',
      'acknowledgedAt',
      'partnerName',
      'phone',
      'alternatePhone',
    ],
  );
  final val = AlertOut(
    id: $checkedConvert('id', (v) => v as String),
    kind: $checkedConvert('kind', (v) => v as String),
    bookingId: $checkedConvert('bookingId', (v) => v as String),
    bookingCode: $checkedConvert('bookingCode', (v) => v as String),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    details: $checkedConvert(
      'details',
      (v) =>
          (v as Map<String, dynamic>).map((k, e) => MapEntry(k, e as Object)),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    acknowledgedAt: $checkedConvert(
      'acknowledgedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    partnerName: $checkedConvert('partnerName', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    alternatePhone: $checkedConvert('alternatePhone', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AlertOutToJson(AlertOut instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'bookingId': instance.bookingId,
  'bookingCode': instance.bookingCode,
  'pickupAt': instance.pickupAt.toIso8601String(),
  'details': instance.details,
  'createdAt': instance.createdAt.toIso8601String(),
  'acknowledgedAt': instance.acknowledgedAt?.toIso8601String(),
  'partnerName': instance.partnerName,
  'phone': instance.phone,
  'alternatePhone': instance.alternatePhone,
};
