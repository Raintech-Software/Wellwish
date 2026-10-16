// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CancelInCWProxy {
  CancelIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCancelIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCancelIn.copyWith.fieldName(...)`
class _$CancelInCWProxyImpl implements _$CancelInCWProxy {
  const _$CancelInCWProxyImpl(this._value);

  final CancelIn _value;

  @override
  CancelIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CancelIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CancelIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CancelIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return CancelIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $CancelInCopyWith on CancelIn {
  /// Returns a callable class that can be used as follows: `instanceOfCancelIn.copyWith(...)` or like so:`instanceOfCancelIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CancelInCWProxy get copyWith => _$CancelInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelIn _$CancelInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'CancelIn',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['reason']);
    final val = CancelIn(reason: $checkedConvert('reason', (v) => v as String));
    return val;
  },
);

Map<String, dynamic> _$CancelInToJson(CancelIn instance) => <String, dynamic>{
  'reason': instance.reason,
};
