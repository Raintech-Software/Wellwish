// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deletion_request_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeletionRequestOutCWProxy {
  DeletionRequestOut dueAt(DateTime dueAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionRequestOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionRequestOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionRequestOut call({DateTime dueAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeletionRequestOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeletionRequestOut.copyWith.fieldName(...)`
class _$DeletionRequestOutCWProxyImpl implements _$DeletionRequestOutCWProxy {
  const _$DeletionRequestOutCWProxyImpl(this._value);

  final DeletionRequestOut _value;

  @override
  DeletionRequestOut dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeletionRequestOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeletionRequestOut(...).copyWith(id: 12, name: "My name")
  /// ````
  DeletionRequestOut call({Object? dueAt = const $CopyWithPlaceholder()}) {
    return DeletionRequestOut(
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime,
    );
  }
}

extension $DeletionRequestOutCopyWith on DeletionRequestOut {
  /// Returns a callable class that can be used as follows: `instanceOfDeletionRequestOut.copyWith(...)` or like so:`instanceOfDeletionRequestOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeletionRequestOutCWProxy get copyWith =>
      _$DeletionRequestOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeletionRequestOut _$DeletionRequestOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeletionRequestOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['dueAt']);
      final val = DeletionRequestOut(
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
      );
      return val;
    });

Map<String, dynamic> _$DeletionRequestOutToJson(DeletionRequestOut instance) =>
    <String, dynamic>{'dueAt': instance.dueAt.toIso8601String()};
