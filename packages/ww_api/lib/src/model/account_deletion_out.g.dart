// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_deletion_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AccountDeletionOutCWProxy {
  AccountDeletionOut id(String id);

  AccountDeletionOut phoneLast4(String phoneLast4);

  AccountDeletionOut status(String status);

  AccountDeletionOut createdAt(DateTime createdAt);

  AccountDeletionOut dueAt(DateTime dueAt);

  AccountDeletionOut cancelledAt(DateTime? cancelledAt);

  AccountDeletionOut doneAt(DateTime? doneAt);

  AccountDeletionOut keptPartner(bool keptPartner);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AccountDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AccountDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AccountDeletionOut call({
    String id,
    String phoneLast4,
    String status,
    DateTime createdAt,
    DateTime dueAt,
    DateTime? cancelledAt,
    DateTime? doneAt,
    bool keptPartner,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAccountDeletionOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAccountDeletionOut.copyWith.fieldName(...)`
class _$AccountDeletionOutCWProxyImpl implements _$AccountDeletionOutCWProxy {
  const _$AccountDeletionOutCWProxyImpl(this._value);

  final AccountDeletionOut _value;

  @override
  AccountDeletionOut id(String id) => this(id: id);

  @override
  AccountDeletionOut phoneLast4(String phoneLast4) =>
      this(phoneLast4: phoneLast4);

  @override
  AccountDeletionOut status(String status) => this(status: status);

  @override
  AccountDeletionOut createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  AccountDeletionOut dueAt(DateTime dueAt) => this(dueAt: dueAt);

  @override
  AccountDeletionOut cancelledAt(DateTime? cancelledAt) =>
      this(cancelledAt: cancelledAt);

  @override
  AccountDeletionOut doneAt(DateTime? doneAt) => this(doneAt: doneAt);

  @override
  AccountDeletionOut keptPartner(bool keptPartner) =>
      this(keptPartner: keptPartner);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AccountDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AccountDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AccountDeletionOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phoneLast4 = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? dueAt = const $CopyWithPlaceholder(),
    Object? cancelledAt = const $CopyWithPlaceholder(),
    Object? doneAt = const $CopyWithPlaceholder(),
    Object? keptPartner = const $CopyWithPlaceholder(),
  }) {
    return AccountDeletionOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phoneLast4: phoneLast4 == const $CopyWithPlaceholder()
          ? _value.phoneLast4
          // ignore: cast_nullable_to_non_nullable
          : phoneLast4 as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      dueAt: dueAt == const $CopyWithPlaceholder()
          ? _value.dueAt
          // ignore: cast_nullable_to_non_nullable
          : dueAt as DateTime,
      cancelledAt: cancelledAt == const $CopyWithPlaceholder()
          ? _value.cancelledAt
          // ignore: cast_nullable_to_non_nullable
          : cancelledAt as DateTime?,
      doneAt: doneAt == const $CopyWithPlaceholder()
          ? _value.doneAt
          // ignore: cast_nullable_to_non_nullable
          : doneAt as DateTime?,
      keptPartner: keptPartner == const $CopyWithPlaceholder()
          ? _value.keptPartner
          // ignore: cast_nullable_to_non_nullable
          : keptPartner as bool,
    );
  }
}

extension $AccountDeletionOutCopyWith on AccountDeletionOut {
  /// Returns a callable class that can be used as follows: `instanceOfAccountDeletionOut.copyWith(...)` or like so:`instanceOfAccountDeletionOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AccountDeletionOutCWProxy get copyWith =>
      _$AccountDeletionOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDeletionOut _$AccountDeletionOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountDeletionOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phoneLast4',
          'status',
          'createdAt',
          'dueAt',
          'cancelledAt',
          'doneAt',
          'keptPartner',
        ],
      );
      final val = AccountDeletionOut(
        id: $checkedConvert('id', (v) => v as String),
        phoneLast4: $checkedConvert('phoneLast4', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        dueAt: $checkedConvert('dueAt', (v) => DateTime.parse(v as String)),
        cancelledAt: $checkedConvert(
          'cancelledAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        doneAt: $checkedConvert(
          'doneAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        keptPartner: $checkedConvert('keptPartner', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AccountDeletionOutToJson(AccountDeletionOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneLast4': instance.phoneLast4,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'dueAt': instance.dueAt.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'doneAt': instance.doneAt?.toIso8601String(),
      'keptPartner': instance.keptPartner,
    };
