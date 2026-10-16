// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_note_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminNoteInCWProxy {
  AdminNoteIn reason(String reason);

  AdminNoteIn expectedAssignmentId(String? expectedAssignmentId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminNoteIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminNoteIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminNoteIn call({String reason, String? expectedAssignmentId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminNoteIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminNoteIn.copyWith.fieldName(...)`
class _$AdminNoteInCWProxyImpl implements _$AdminNoteInCWProxy {
  const _$AdminNoteInCWProxyImpl(this._value);

  final AdminNoteIn _value;

  @override
  AdminNoteIn reason(String reason) => this(reason: reason);

  @override
  AdminNoteIn expectedAssignmentId(String? expectedAssignmentId) =>
      this(expectedAssignmentId: expectedAssignmentId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminNoteIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminNoteIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminNoteIn call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? expectedAssignmentId = const $CopyWithPlaceholder(),
  }) {
    return AdminNoteIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      expectedAssignmentId: expectedAssignmentId == const $CopyWithPlaceholder()
          ? _value.expectedAssignmentId
          // ignore: cast_nullable_to_non_nullable
          : expectedAssignmentId as String?,
    );
  }
}

extension $AdminNoteInCopyWith on AdminNoteIn {
  /// Returns a callable class that can be used as follows: `instanceOfAdminNoteIn.copyWith(...)` or like so:`instanceOfAdminNoteIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminNoteInCWProxy get copyWith => _$AdminNoteInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminNoteIn _$AdminNoteInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminNoteIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason', 'expectedAssignmentId']);
      final val = AdminNoteIn(
        reason: $checkedConvert('reason', (v) => v as String),
        expectedAssignmentId: $checkedConvert(
          'expectedAssignmentId',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$AdminNoteInToJson(AdminNoteIn instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'expectedAssignmentId': instance.expectedAssignmentId,
    };
