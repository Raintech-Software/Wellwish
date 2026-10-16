// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientRowOutCWProxy {
  PatientRowOut id(String id);

  PatientRowOut phone(String phone);

  PatientRowOut fullName(String fullName);

  PatientRowOut status(String status);

  PatientRowOut memberCount(int memberCount);

  PatientRowOut createdAt(DateTime createdAt);

  PatientRowOut deletionDueAt(DateTime? deletionDueAt);

  PatientRowOut blockedAt(DateTime? blockedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientRowOut call({
    String id,
    String phone,
    String fullName,
    String status,
    int memberCount,
    DateTime createdAt,
    DateTime? deletionDueAt,
    DateTime? blockedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientRowOut.copyWith.fieldName(...)`
class _$PatientRowOutCWProxyImpl implements _$PatientRowOutCWProxy {
  const _$PatientRowOutCWProxyImpl(this._value);

  final PatientRowOut _value;

  @override
  PatientRowOut id(String id) => this(id: id);

  @override
  PatientRowOut phone(String phone) => this(phone: phone);

  @override
  PatientRowOut fullName(String fullName) => this(fullName: fullName);

  @override
  PatientRowOut status(String status) => this(status: status);

  @override
  PatientRowOut memberCount(int memberCount) => this(memberCount: memberCount);

  @override
  PatientRowOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  PatientRowOut deletionDueAt(DateTime? deletionDueAt) =>
      this(deletionDueAt: deletionDueAt);

  @override
  PatientRowOut blockedAt(DateTime? blockedAt) => this(blockedAt: blockedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientRowOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? memberCount = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? deletionDueAt = const $CopyWithPlaceholder(),
    Object? blockedAt = const $CopyWithPlaceholder(),
  }) {
    return PatientRowOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      memberCount: memberCount == const $CopyWithPlaceholder()
          ? _value.memberCount
          // ignore: cast_nullable_to_non_nullable
          : memberCount as int,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      deletionDueAt: deletionDueAt == const $CopyWithPlaceholder()
          ? _value.deletionDueAt
          // ignore: cast_nullable_to_non_nullable
          : deletionDueAt as DateTime?,
      blockedAt: blockedAt == const $CopyWithPlaceholder()
          ? _value.blockedAt
          // ignore: cast_nullable_to_non_nullable
          : blockedAt as DateTime?,
    );
  }
}

extension $PatientRowOutCopyWith on PatientRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPatientRowOut.copyWith(...)` or like so:`instanceOfPatientRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientRowOutCWProxy get copyWith => _$PatientRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientRowOut _$PatientRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'phone',
          'fullName',
          'status',
          'memberCount',
          'createdAt',
          'deletionDueAt',
        ],
      );
      final val = PatientRowOut(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        memberCount: $checkedConvert('memberCount', (v) => (v as num).toInt()),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        deletionDueAt: $checkedConvert(
          'deletionDueAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        blockedAt: $checkedConvert(
          'blockedAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PatientRowOutToJson(PatientRowOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'status': instance.status,
      'memberCount': instance.memberCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'deletionDueAt': instance.deletionDueAt?.toIso8601String(),
      'blockedAt': ?instance.blockedAt?.toIso8601String(),
    };
