// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_time_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BlockedTimeInCWProxy {
  BlockedTimeIn fromTs(DateTime fromTs);

  BlockedTimeIn toTs(DateTime toTs);

  BlockedTimeIn reason(String reason);

  BlockedTimeIn serviceType(BlockedTimeInServiceTypeEnum? serviceType);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BlockedTimeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BlockedTimeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BlockedTimeIn call({
    DateTime fromTs,
    DateTime toTs,
    String reason,
    BlockedTimeInServiceTypeEnum? serviceType,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBlockedTimeIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBlockedTimeIn.copyWith.fieldName(...)`
class _$BlockedTimeInCWProxyImpl implements _$BlockedTimeInCWProxy {
  const _$BlockedTimeInCWProxyImpl(this._value);

  final BlockedTimeIn _value;

  @override
  BlockedTimeIn fromTs(DateTime fromTs) => this(fromTs: fromTs);

  @override
  BlockedTimeIn toTs(DateTime toTs) => this(toTs: toTs);

  @override
  BlockedTimeIn reason(String reason) => this(reason: reason);

  @override
  BlockedTimeIn serviceType(BlockedTimeInServiceTypeEnum? serviceType) =>
      this(serviceType: serviceType);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BlockedTimeIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BlockedTimeIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BlockedTimeIn call({
    Object? fromTs = const $CopyWithPlaceholder(),
    Object? toTs = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? serviceType = const $CopyWithPlaceholder(),
  }) {
    return BlockedTimeIn(
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
          : serviceType as BlockedTimeInServiceTypeEnum?,
    );
  }
}

extension $BlockedTimeInCopyWith on BlockedTimeIn {
  /// Returns a callable class that can be used as follows: `instanceOfBlockedTimeIn.copyWith(...)` or like so:`instanceOfBlockedTimeIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BlockedTimeInCWProxy get copyWith => _$BlockedTimeInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockedTimeIn _$BlockedTimeInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BlockedTimeIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['fromTs', 'toTs', 'reason']);
      final val = BlockedTimeIn(
        fromTs: $checkedConvert('fromTs', (v) => DateTime.parse(v as String)),
        toTs: $checkedConvert('toTs', (v) => DateTime.parse(v as String)),
        reason: $checkedConvert('reason', (v) => v as String),
        serviceType: $checkedConvert(
          'serviceType',
          (v) => $enumDecodeNullable(_$BlockedTimeInServiceTypeEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BlockedTimeInToJson(
  BlockedTimeIn instance,
) => <String, dynamic>{
  'fromTs': instance.fromTs.toIso8601String(),
  'toTs': instance.toTs.toIso8601String(),
  'reason': instance.reason,
  'serviceType': ?_$BlockedTimeInServiceTypeEnumEnumMap[instance.serviceType],
};

const _$BlockedTimeInServiceTypeEnumEnumMap = {
  BlockedTimeInServiceTypeEnum.COMPANION: 'COMPANION',
  BlockedTimeInServiceTypeEnum.NURSE: 'NURSE',
};
