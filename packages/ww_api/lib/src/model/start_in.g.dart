// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StartInCWProxy {
  StartIn role(StartInRoleEnum role);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StartIn call({StartInRoleEnum role});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStartIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStartIn.copyWith.fieldName(...)`
class _$StartInCWProxyImpl implements _$StartInCWProxy {
  const _$StartInCWProxyImpl(this._value);

  final StartIn _value;

  @override
  StartIn role(StartInRoleEnum role) => this(role: role);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StartIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StartIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StartIn call({Object? role = const $CopyWithPlaceholder()}) {
    return StartIn(
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as StartInRoleEnum,
    );
  }
}

extension $StartInCopyWith on StartIn {
  /// Returns a callable class that can be used as follows: `instanceOfStartIn.copyWith(...)` or like so:`instanceOfStartIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StartInCWProxy get copyWith => _$StartInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartIn _$StartInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StartIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['role']);
      final val = StartIn(
        role: $checkedConvert(
          'role',
          (v) => $enumDecode(_$StartInRoleEnumEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StartInToJson(StartIn instance) => <String, dynamic>{
  'role': _$StartInRoleEnumEnumMap[instance.role]!,
};

const _$StartInRoleEnumEnumMap = {
  StartInRoleEnum.COMPANION: 'COMPANION',
  StartInRoleEnum.NURSE: 'NURSE',
};
