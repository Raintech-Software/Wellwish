// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reason_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReasonInCWProxy {
  ReasonIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReasonIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReasonIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReasonIn.copyWith.fieldName(...)`
class _$ReasonInCWProxyImpl implements _$ReasonInCWProxy {
  const _$ReasonInCWProxyImpl(this._value);

  final ReasonIn _value;

  @override
  ReasonIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReasonIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return ReasonIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $ReasonInCopyWith on ReasonIn {
  /// Returns a callable class that can be used as follows: `instanceOfReasonIn.copyWith(...)` or like so:`instanceOfReasonIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReasonInCWProxy get copyWith => _$ReasonInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReasonIn _$ReasonInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ReasonIn',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['reason']);
    final val = ReasonIn(reason: $checkedConvert('reason', (v) => v as String));
    return val;
  },
);

Map<String, dynamic> _$ReasonInToJson(ReasonIn instance) => <String, dynamic>{
  'reason': instance.reason,
};
