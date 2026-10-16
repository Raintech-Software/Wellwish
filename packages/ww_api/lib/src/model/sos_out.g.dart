// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SosOutCWProxy {
  SosOut id(String id);

  SosOut status(String status);

  SosOut createdAt(DateTime createdAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SosOut call({String id, String status, DateTime createdAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSosOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSosOut.copyWith.fieldName(...)`
class _$SosOutCWProxyImpl implements _$SosOutCWProxy {
  const _$SosOutCWProxyImpl(this._value);

  final SosOut _value;

  @override
  SosOut id(String id) => this(id: id);

  @override
  SosOut status(String status) => this(status: status);

  @override
  SosOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SosOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return SosOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
    );
  }
}

extension $SosOutCopyWith on SosOut {
  /// Returns a callable class that can be used as follows: `instanceOfSosOut.copyWith(...)` or like so:`instanceOfSosOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SosOutCWProxy get copyWith => _$SosOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosOut _$SosOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SosOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'status', 'createdAt']);
      final val = SosOut(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SosOutToJson(SosOut instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};
