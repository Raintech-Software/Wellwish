// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affected_booking_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AffectedBookingOutCWProxy {
  AffectedBookingOut id(String id);

  AffectedBookingOut code(String code);

  AffectedBookingOut pickupAt(DateTime pickupAt);

  AffectedBookingOut status(String status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AffectedBookingOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AffectedBookingOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AffectedBookingOut call({
    String id,
    String code,
    DateTime pickupAt,
    String status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAffectedBookingOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAffectedBookingOut.copyWith.fieldName(...)`
class _$AffectedBookingOutCWProxyImpl implements _$AffectedBookingOutCWProxy {
  const _$AffectedBookingOutCWProxyImpl(this._value);

  final AffectedBookingOut _value;

  @override
  AffectedBookingOut id(String id) => this(id: id);

  @override
  AffectedBookingOut code(String code) => this(code: code);

  @override
  AffectedBookingOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  AffectedBookingOut status(String status) => this(status: status);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AffectedBookingOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AffectedBookingOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AffectedBookingOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return AffectedBookingOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
    );
  }
}

extension $AffectedBookingOutCopyWith on AffectedBookingOut {
  /// Returns a callable class that can be used as follows: `instanceOfAffectedBookingOut.copyWith(...)` or like so:`instanceOfAffectedBookingOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AffectedBookingOutCWProxy get copyWith =>
      _$AffectedBookingOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AffectedBookingOut _$AffectedBookingOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AffectedBookingOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['id', 'code', 'pickupAt', 'status']);
  final val = AffectedBookingOut(
    id: $checkedConvert('id', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    status: $checkedConvert('status', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$AffectedBookingOutToJson(AffectedBookingOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'pickupAt': instance.pickupAt.toIso8601String(),
      'status': instance.status,
    };
