// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_end_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TemporaryEndInCWProxy {
  TemporaryEndIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemporaryEndIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemporaryEndIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TemporaryEndIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTemporaryEndIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTemporaryEndIn.copyWith.fieldName(...)`
class _$TemporaryEndInCWProxyImpl implements _$TemporaryEndInCWProxy {
  const _$TemporaryEndInCWProxyImpl(this._value);

  final TemporaryEndIn _value;

  @override
  TemporaryEndIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemporaryEndIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemporaryEndIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TemporaryEndIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return TemporaryEndIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $TemporaryEndInCopyWith on TemporaryEndIn {
  /// Returns a callable class that can be used as follows: `instanceOfTemporaryEndIn.copyWith(...)` or like so:`instanceOfTemporaryEndIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TemporaryEndInCWProxy get copyWith => _$TemporaryEndInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemporaryEndIn _$TemporaryEndInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TemporaryEndIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = TemporaryEndIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TemporaryEndInToJson(TemporaryEndIn instance) =>
    <String, dynamic>{'reason': instance.reason};
