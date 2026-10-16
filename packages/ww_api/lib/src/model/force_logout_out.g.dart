// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'force_logout_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ForceLogoutOutCWProxy {
  ForceLogoutOut sessionsEnded(int sessionsEnded);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForceLogoutOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForceLogoutOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ForceLogoutOut call({int sessionsEnded});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfForceLogoutOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfForceLogoutOut.copyWith.fieldName(...)`
class _$ForceLogoutOutCWProxyImpl implements _$ForceLogoutOutCWProxy {
  const _$ForceLogoutOutCWProxyImpl(this._value);

  final ForceLogoutOut _value;

  @override
  ForceLogoutOut sessionsEnded(int sessionsEnded) =>
      this(sessionsEnded: sessionsEnded);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ForceLogoutOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ForceLogoutOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ForceLogoutOut call({Object? sessionsEnded = const $CopyWithPlaceholder()}) {
    return ForceLogoutOut(
      sessionsEnded: sessionsEnded == const $CopyWithPlaceholder()
          ? _value.sessionsEnded
          // ignore: cast_nullable_to_non_nullable
          : sessionsEnded as int,
    );
  }
}

extension $ForceLogoutOutCopyWith on ForceLogoutOut {
  /// Returns a callable class that can be used as follows: `instanceOfForceLogoutOut.copyWith(...)` or like so:`instanceOfForceLogoutOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ForceLogoutOutCWProxy get copyWith => _$ForceLogoutOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForceLogoutOut _$ForceLogoutOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ForceLogoutOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sessionsEnded']);
      final val = ForceLogoutOut(
        sessionsEnded: $checkedConvert(
          'sessionsEnded',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ForceLogoutOutToJson(ForceLogoutOut instance) =>
    <String, dynamic>{'sessionsEnded': instance.sessionsEnded};
