// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_deletion_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerDeletionOutCWProxy {
  PartnerDeletionOut dueAt(DateTime dueAt);

  PartnerDeletionOut done(bool done);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerDeletionOut call({DateTime dueAt, bool done});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerDeletionOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerDeletionOut.copyWith.fieldName(...)`
class _$PartnerDeletionOutCWProxyImpl implements _$PartnerDeletionOutCWProxy {
  const _$PartnerDeletionOutCWProxyImpl(this._value);

  final PartnerDeletionOut _value;

  @override
  PartnerDeletionOut dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  PartnerDeletionOut done(bool done) => this(done: done);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerDeletionOut call({
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
  }) {
    return PartnerDeletionOut(
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as bool,
    );
  }
}

extension $PartnerDeletionOutCopyWith on PartnerDeletionOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerDeletionOut.copyWith(...)` or like so:`instanceOfPartnerDeletionOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerDeletionOutCWProxy get copyWith =>
      _$PartnerDeletionOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerDeletionOut _$PartnerDeletionOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerDeletionOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['dueAt', 'done']);
      final val = PartnerDeletionOut(
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        done: $checkedConvert('done', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PartnerDeletionOutToJson(PartnerDeletionOut instance) =>
    <String, dynamic>{
      'dueAt': instance.dueAt.toIso8601String(),
      'done': instance.done,
    };
