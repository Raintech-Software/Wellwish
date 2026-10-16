// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_step_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminStepInCWProxy {
  AdminStepIn step(AdminStepInStepEnum step);

  AdminStepIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminStepIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminStepIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminStepIn call({AdminStepInStepEnum step, String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminStepIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminStepIn.copyWith.fieldName(...)`
class _$AdminStepInCWProxyImpl implements _$AdminStepInCWProxy {
  const _$AdminStepInCWProxyImpl(this._value);

  final AdminStepIn _value;

  @override
  AdminStepIn step(AdminStepInStepEnum step) => this(step: step);

  @override
  AdminStepIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminStepIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminStepIn(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminStepIn call({
    Object? step = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
  }) {
    return AdminStepIn(
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as AdminStepInStepEnum,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $AdminStepInCopyWith on AdminStepIn {
  /// Returns a callable class that can be used as follows: `instanceOfAdminStepIn.copyWith(...)` or like so:`instanceOfAdminStepIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminStepInCWProxy get copyWith => _$AdminStepInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminStepIn _$AdminStepInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminStepIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['step', 'reason']);
      final val = AdminStepIn(
        step: $checkedConvert(
          'step',
          (v) => $enumDecode(_$AdminStepInStepEnumEnumMap, v),
        ),
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdminStepInToJson(AdminStepIn instance) =>
    <String, dynamic>{
      'step': _$AdminStepInStepEnumEnumMap[instance.step]!,
      'reason': instance.reason,
    };

const _$AdminStepInStepEnumEnumMap = {
  AdminStepInStepEnum.ON_THE_WAY: 'ON_THE_WAY',
  AdminStepInStepEnum.REACHED_PATIENT: 'REACHED_PATIENT',
  AdminStepInStepEnum.PICKED_UP: 'PICKED_UP',
  AdminStepInStepEnum.REACHED_HOSPITAL: 'REACHED_HOSPITAL',
  AdminStepInStepEnum.VISIT_DONE: 'VISIT_DONE',
  AdminStepInStepEnum.DROPPED_HOME: 'DROPPED_HOME',
  AdminStepInStepEnum.REACHED_HOME: 'REACHED_HOME',
  AdminStepInStepEnum.STARTED: 'STARTED',
  AdminStepInStepEnum.CARE_DONE: 'CARE_DONE',
  AdminStepInStepEnum.AT_PLACE: 'AT_PLACE',
  AdminStepInStepEnum.TASK_DONE: 'TASK_DONE',
  AdminStepInStepEnum.DELIVERED: 'DELIVERED',
  AdminStepInStepEnum.COMPLETED: 'COMPLETED',
};
