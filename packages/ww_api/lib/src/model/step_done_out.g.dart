// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_done_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StepDoneOutCWProxy {
  StepDoneOut step(String step);

  StepDoneOut at(DateTime at);

  StepDoneOut by(String by);

  StepDoneOut far(bool far);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepDoneOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepDoneOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StepDoneOut call({String step, DateTime at, String by, bool far});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStepDoneOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStepDoneOut.copyWith.fieldName(...)`
class _$StepDoneOutCWProxyImpl implements _$StepDoneOutCWProxy {
  const _$StepDoneOutCWProxyImpl(this._value);

  final StepDoneOut _value;

  @override
  StepDoneOut step(String step) => this(step: step);

  @override
  StepDoneOut at(DateTime at) => this(at: at);

  @override
  StepDoneOut by(String by) => this(by: by);

  @override
  StepDoneOut far(bool far) => this(far: far);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepDoneOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepDoneOut(...).copyWith(id: 12, name: "My name")
  /// ````
  StepDoneOut call({
    Object? step = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? by = const $CopyWithPlaceholder(),
    Object? far = const $CopyWithPlaceholder(),
  }) {
    return StepDoneOut(
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      by: by == const $CopyWithPlaceholder()
          ? _value.by
          // ignore: cast_nullable_to_non_nullable
          : by as String,
      far: far == const $CopyWithPlaceholder()
          ? _value.far
          // ignore: cast_nullable_to_non_nullable
          : far as bool,
    );
  }
}

extension $StepDoneOutCopyWith on StepDoneOut {
  /// Returns a callable class that can be used as follows: `instanceOfStepDoneOut.copyWith(...)` or like so:`instanceOfStepDoneOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StepDoneOutCWProxy get copyWith => _$StepDoneOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepDoneOut _$StepDoneOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StepDoneOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['step', 'at', 'by', 'far']);
      final val = StepDoneOut(
        step: $checkedConvert('step', (v) => v as String),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        by: $checkedConvert('by', (v) => v as String),
        far: $checkedConvert('far', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$StepDoneOutToJson(StepDoneOut instance) =>
    <String, dynamic>{
      'step': instance.step,
      'at': instance.at.toIso8601String(),
      'by': instance.by,
      'far': instance.far,
    };
