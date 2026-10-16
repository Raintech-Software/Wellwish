// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PermissionOutCWProxy {
  PermissionOut code(String code);

  PermissionOut description(String description);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PermissionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PermissionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PermissionOut call({String code, String description});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPermissionOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPermissionOut.copyWith.fieldName(...)`
class _$PermissionOutCWProxyImpl implements _$PermissionOutCWProxy {
  const _$PermissionOutCWProxyImpl(this._value);

  final PermissionOut _value;

  @override
  PermissionOut code(String code) => this(code: code);

  @override
  PermissionOut description(String description) =>
      this(description: description);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PermissionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PermissionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PermissionOut call({
    Object? code = const $CopyWithPlaceholder(),
    Object? description = const $CopyWithPlaceholder(),
  }) {
    return PermissionOut(
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      description: description == const $CopyWithPlaceholder()
          ? _value.description
          // ignore: cast_nullable_to_non_nullable
          : description as String,
    );
  }
}

extension $PermissionOutCopyWith on PermissionOut {
  /// Returns a callable class that can be used as follows: `instanceOfPermissionOut.copyWith(...)` or like so:`instanceOfPermissionOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PermissionOutCWProxy get copyWith => _$PermissionOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionOut _$PermissionOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PermissionOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['code', 'description']);
      final val = PermissionOut(
        code: $checkedConvert('code', (v) => v as String),
        description: $checkedConvert('description', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PermissionOutToJson(PermissionOut instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
    };
