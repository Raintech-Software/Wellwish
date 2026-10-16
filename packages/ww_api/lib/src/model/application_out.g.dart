// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ApplicationOutCWProxy {
  ApplicationOut id(String id);

  ApplicationOut status(String status);

  ApplicationOut submittedAt(DateTime submittedAt);

  ApplicationOut firstSubmittedAt(DateTime firstSubmittedAt);

  ApplicationOut notes(String notes);

  ApplicationOut claimedBy(String? claimedBy);

  ApplicationOut claimedUntil(DateTime? claimedUntil);

  ApplicationOut decidedBy(String? decidedBy);

  ApplicationOut decidedAt(DateTime? decidedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationOut call({
    String id,
    String status,
    DateTime submittedAt,
    DateTime firstSubmittedAt,
    String notes,
    String? claimedBy,
    DateTime? claimedUntil,
    String? decidedBy,
    DateTime? decidedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfApplicationOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfApplicationOut.copyWith.fieldName(...)`
class _$ApplicationOutCWProxyImpl implements _$ApplicationOutCWProxy {
  const _$ApplicationOutCWProxyImpl(this._value);

  final ApplicationOut _value;

  @override
  ApplicationOut id(String id) => this(id: id);

  @override
  ApplicationOut status(String status) => this(status: status);

  @override
  ApplicationOut submittedAt(DateTime submittedAt) =>
      this(submittedAt: submittedAt);

  @override
  ApplicationOut firstSubmittedAt(DateTime firstSubmittedAt) =>
      this(firstSubmittedAt: firstSubmittedAt);

  @override
  ApplicationOut notes(String notes) => this(notes: notes);

  @override
  ApplicationOut claimedBy(String? claimedBy) => this(claimedBy: claimedBy);

  @override
  ApplicationOut claimedUntil(DateTime? claimedUntil) =>
      this(claimedUntil: claimedUntil);

  @override
  ApplicationOut decidedBy(String? decidedBy) => this(decidedBy: decidedBy);

  @override
  ApplicationOut decidedAt(DateTime? decidedAt) => this(decidedAt: decidedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ApplicationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ApplicationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  ApplicationOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? submittedAt = const $CopyWithPlaceholder(),
    Object? firstSubmittedAt = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? claimedBy = const $CopyWithPlaceholder(),
    Object? claimedUntil = const $CopyWithPlaceholder(),
    Object? decidedBy = const $CopyWithPlaceholder(),
    Object? decidedAt = const $CopyWithPlaceholder(),
  }) {
    return ApplicationOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      submittedAt: submittedAt == const $CopyWithPlaceholder()
          ? _value.submittedAt
          // ignore: cast_nullable_to_non_nullable
          : submittedAt as DateTime,
      firstSubmittedAt: firstSubmittedAt == const $CopyWithPlaceholder()
          ? _value.firstSubmittedAt
          // ignore: cast_nullable_to_non_nullable
          : firstSubmittedAt as DateTime,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
      claimedBy: claimedBy == const $CopyWithPlaceholder()
          ? _value.claimedBy
          // ignore: cast_nullable_to_non_nullable
          : claimedBy as String?,
      claimedUntil: claimedUntil == const $CopyWithPlaceholder()
          ? _value.claimedUntil
          // ignore: cast_nullable_to_non_nullable
          : claimedUntil as DateTime?,
      decidedBy: decidedBy == const $CopyWithPlaceholder()
          ? _value.decidedBy
          // ignore: cast_nullable_to_non_nullable
          : decidedBy as String?,
      decidedAt: decidedAt == const $CopyWithPlaceholder()
          ? _value.decidedAt
          // ignore: cast_nullable_to_non_nullable
          : decidedAt as DateTime?,
    );
  }
}

extension $ApplicationOutCopyWith on ApplicationOut {
  /// Returns a callable class that can be used as follows: `instanceOfApplicationOut.copyWith(...)` or like so:`instanceOfApplicationOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ApplicationOutCWProxy get copyWith => _$ApplicationOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicationOut _$ApplicationOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ApplicationOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'status',
          'submittedAt',
          'firstSubmittedAt',
          'notes',
          'claimedBy',
          'claimedUntil',
          'decidedBy',
          'decidedAt',
        ],
      );
      final val = ApplicationOut(
        id: $checkedConvert('id', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        submittedAt: $checkedConvert(
          'submittedAt',
          (v) => DateTime.parse(v as String),
        ),
        firstSubmittedAt: $checkedConvert(
          'firstSubmittedAt',
          (v) => DateTime.parse(v as String),
        ),
        notes: $checkedConvert('notes', (v) => v as String),
        claimedBy: $checkedConvert('claimedBy', (v) => v as String?),
        claimedUntil: $checkedConvert(
          'claimedUntil',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        decidedBy: $checkedConvert('decidedBy', (v) => v as String?),
        decidedAt: $checkedConvert(
          'decidedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ApplicationOutToJson(ApplicationOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'firstSubmittedAt': instance.firstSubmittedAt.toIso8601String(),
      'notes': instance.notes,
      'claimedBy': instance.claimedBy,
      'claimedUntil': instance.claimedUntil?.toIso8601String(),
      'decidedBy': instance.decidedBy,
      'decidedAt': instance.decidedAt?.toIso8601String(),
    };
