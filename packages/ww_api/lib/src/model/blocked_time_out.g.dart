// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_time_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BlockedTimeOutCWProxy {
  BlockedTimeOut id(String id);

  BlockedTimeOut fromTs(DateTime fromTs);

  BlockedTimeOut toTs(DateTime toTs);

  BlockedTimeOut reason(String reason);

  BlockedTimeOut serviceType(String? serviceType);

  BlockedTimeOut createdBy(String? createdBy);

  BlockedTimeOut affectedBookings(List<AffectedBookingOut>? affectedBookings);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BlockedTimeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BlockedTimeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BlockedTimeOut call({
    String id,
    DateTime fromTs,
    DateTime toTs,
    String reason,
    String? serviceType,
    String? createdBy,
    List<AffectedBookingOut>? affectedBookings,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBlockedTimeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBlockedTimeOut.copyWith.fieldName(...)`
class _$BlockedTimeOutCWProxyImpl implements _$BlockedTimeOutCWProxy {
  const _$BlockedTimeOutCWProxyImpl(this._value);

  final BlockedTimeOut _value;

  @override
  BlockedTimeOut id(String id) => this(id: id);

  @override
  BlockedTimeOut fromTs(DateTime fromTs) => this(fromTs: fromTs);

  @override
  BlockedTimeOut toTs(DateTime toTs) => this(toTs: toTs);

  @override
  BlockedTimeOut reason(String reason) => this(reason: reason);

  @override
  BlockedTimeOut serviceType(String? serviceType) =>
      this(serviceType: serviceType);

  @override
  BlockedTimeOut createdBy(String? createdBy) => this(createdBy: createdBy);

  @override
  BlockedTimeOut affectedBookings(List<AffectedBookingOut>? affectedBookings) =>
      this(affectedBookings: affectedBookings);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BlockedTimeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BlockedTimeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BlockedTimeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fromTs = const $CopyWithPlaceholder(),
    Object? toTs = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? serviceType = const $CopyWithPlaceholder(),
    Object? createdBy = const $CopyWithPlaceholder(),
    Object? affectedBookings = const $CopyWithPlaceholder(),
  }) {
    return BlockedTimeOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fromTs: fromTs == const $CopyWithPlaceholder()
          ? _value.fromTs
          // ignore: cast_nullable_to_non_nullable
          : fromTs as DateTime,
      toTs: toTs == const $CopyWithPlaceholder()
          ? _value.toTs
          // ignore: cast_nullable_to_non_nullable
          : toTs as DateTime,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      serviceType: serviceType == const $CopyWithPlaceholder()
          ? _value.serviceType
          // ignore: cast_nullable_to_non_nullable
          : serviceType as String?,
      createdBy: createdBy == const $CopyWithPlaceholder()
          ? _value.createdBy
          // ignore: cast_nullable_to_non_nullable
          : createdBy as String?,
      affectedBookings: affectedBookings == const $CopyWithPlaceholder()
          ? _value.affectedBookings
          // ignore: cast_nullable_to_non_nullable
          : affectedBookings as List<AffectedBookingOut>?,
    );
  }
}

extension $BlockedTimeOutCopyWith on BlockedTimeOut {
  /// Returns a callable class that can be used as follows: `instanceOfBlockedTimeOut.copyWith(...)` or like so:`instanceOfBlockedTimeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BlockedTimeOutCWProxy get copyWith => _$BlockedTimeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedTimeOut _$BlockedTimeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BlockedTimeOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'fromTs', 'toTs', 'reason', 'serviceType'],
      );
      final val = BlockedTimeOut(
        id: $checkedConvert('id', (v) => v as String),
        fromTs: $checkedConvert('fromTs', (v) => DateTime.parse(v as String)),
        toTs: $checkedConvert('toTs', (v) => DateTime.parse(v as String)),
        reason: $checkedConvert('reason', (v) => v as String),
        serviceType: $checkedConvert('serviceType', (v) => v as String?),
        createdBy: $checkedConvert('createdBy', (v) => v as String?),
        affectedBookings: $checkedConvert(
          'affectedBookings',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => AffectedBookingOut.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BlockedTimeOutToJson(BlockedTimeOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromTs': instance.fromTs.toIso8601String(),
      'toTs': instance.toTs.toIso8601String(),
      'reason': instance.reason,
      'serviceType': instance.serviceType,
      'createdBy': ?instance.createdBy,
      'affectedBookings': ?instance.affectedBookings
          ?.map((e) => e.toJson())
          .toList(),
    };
