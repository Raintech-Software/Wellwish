// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssignInCWProxy {
  AssignIn partnerId(String partnerId);

  AssignIn expectedAssignmentId(String? expectedAssignmentId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignIn call({String partnerId, String? expectedAssignmentId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAssignIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAssignIn.copyWith.fieldName(...)`
class _$AssignInCWProxyImpl implements _$AssignInCWProxy {
  const _$AssignInCWProxyImpl(this._value);

  final AssignIn _value;

  @override
  AssignIn partnerId(String partnerId) => this(partnerId: partnerId);

  @override
  AssignIn expectedAssignmentId(String? expectedAssignmentId) =>
      this(expectedAssignmentId: expectedAssignmentId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignIn call({
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? expectedAssignmentId = const $CopyWithPlaceholder(),
  }) {
    return AssignIn(
      partnerId: partnerId == const $CopyWithPlaceholder()
          ? _value.partnerId
          // ignore: cast_nullable_to_non_nullable
          : partnerId as String,
      expectedAssignmentId: expectedAssignmentId == const $CopyWithPlaceholder()
          ? _value.expectedAssignmentId
          // ignore: cast_nullable_to_non_nullable
          : expectedAssignmentId as String?,
    );
  }
}

extension $AssignInCopyWith on AssignIn {
  /// Returns a callable class that can be used as follows: `instanceOfAssignIn.copyWith(...)` or like so:`instanceOfAssignIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssignInCWProxy get copyWith => _$AssignInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignIn _$AssignInFromJson(Map<String, dynamic> json) => $checkedCreate(
  'AssignIn',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['partnerId', 'expectedAssignmentId']);
    final val = AssignIn(
      partnerId: $checkedConvert('partnerId', (v) => v as String),
      expectedAssignmentId: $checkedConvert(
        'expectedAssignmentId',
        (v) => v as String?,
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$AssignInToJson(AssignIn instance) => <String, dynamic>{
  'partnerId': instance.partnerId,
  'expectedAssignmentId': instance.expectedAssignmentId,
};
