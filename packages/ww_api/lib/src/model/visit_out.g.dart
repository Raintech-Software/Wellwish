// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VisitOutCWProxy {
  VisitOut steps(List<String> steps);

  VisitOut done(List<StepDoneOut> done);

  VisitOut currentStep(String currentStep);

  VisitOut nextStep(String? nextStep);

  VisitOut otpStep(String otpStep);

  VisitOut otpRetryAt(DateTime? otpRetryAt);

  VisitOut noShowReadyAt(DateTime? noShowReadyAt);

  VisitOut balanceCollectedPaise(int? balanceCollectedPaise);

  VisitOut balanceMode(String balanceMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VisitOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VisitOut(...).copyWith(id: 12, name: "My name")
  /// ````
  VisitOut call({
    List<String> steps,
    List<StepDoneOut> done,
    String currentStep,
    String? nextStep,
    String otpStep,
    DateTime? otpRetryAt,
    DateTime? noShowReadyAt,
    int? balanceCollectedPaise,
    String balanceMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVisitOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVisitOut.copyWith.fieldName(...)`
class _$VisitOutCWProxyImpl implements _$VisitOutCWProxy {
  const _$VisitOutCWProxyImpl(this._value);

  final VisitOut _value;

  @override
  VisitOut steps(List<String> steps) => this(steps: steps);

  @override
  VisitOut done(List<StepDoneOut> done) => this(done: done);

  @override
  VisitOut currentStep(String currentStep) => this(currentStep: currentStep);

  @override
  VisitOut nextStep(String? nextStep) => this(nextStep: nextStep);

  @override
  VisitOut otpStep(String otpStep) => this(otpStep: otpStep);

  @override
  VisitOut otpRetryAt(DateTime? otpRetryAt) => this(otpRetryAt: otpRetryAt);

  @override
  VisitOut noShowReadyAt(DateTime? noShowReadyAt) =>
      this(noShowReadyAt: noShowReadyAt);

  @override
  VisitOut balanceCollectedPaise(int? balanceCollectedPaise) =>
      this(balanceCollectedPaise: balanceCollectedPaise);

  @override
  VisitOut balanceMode(String balanceMode) => this(balanceMode: balanceMode);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VisitOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VisitOut(...).copyWith(id: 12, name: "My name")
  /// ````
  VisitOut call({
    Object? steps = const $CopyWithPlaceholder(),
    Object? done = const $CopyWithPlaceholder(),
    Object? currentStep = const $CopyWithPlaceholder(),
    Object? nextStep = const $CopyWithPlaceholder(),
    Object? otpStep = const $CopyWithPlaceholder(),
    Object? otpRetryAt = const $CopyWithPlaceholder(),
    Object? noShowReadyAt = const $CopyWithPlaceholder(),
    Object? balanceCollectedPaise = const $CopyWithPlaceholder(),
    Object? balanceMode = const $CopyWithPlaceholder(),
  }) {
    return VisitOut(
      steps: steps == const $CopyWithPlaceholder()
          ? _value.steps
          // ignore: cast_nullable_to_non_nullable
          : steps as List<String>,
      done: done == const $CopyWithPlaceholder()
          ? _value.done
          // ignore: cast_nullable_to_non_nullable
          : done as List<StepDoneOut>,
      currentStep: currentStep == const $CopyWithPlaceholder()
          ? _value.currentStep
          // ignore: cast_nullable_to_non_nullable
          : currentStep as String,
      nextStep: nextStep == const $CopyWithPlaceholder()
          ? _value.nextStep
          // ignore: cast_nullable_to_non_nullable
          : nextStep as String?,
      otpStep: otpStep == const $CopyWithPlaceholder()
          ? _value.otpStep
          // ignore: cast_nullable_to_non_nullable
          : otpStep as String,
      otpRetryAt: otpRetryAt == const $CopyWithPlaceholder()
          ? _value.otpRetryAt
          // ignore: cast_nullable_to_non_nullable
          : otpRetryAt as DateTime?,
      noShowReadyAt: noShowReadyAt == const $CopyWithPlaceholder()
          ? _value.noShowReadyAt
          // ignore: cast_nullable_to_non_nullable
          : noShowReadyAt as DateTime?,
      balanceCollectedPaise:
          balanceCollectedPaise == const $CopyWithPlaceholder()
          ? _value.balanceCollectedPaise
          // ignore: cast_nullable_to_non_nullable
          : balanceCollectedPaise as int?,
      balanceMode: balanceMode == const $CopyWithPlaceholder()
          ? _value.balanceMode
          // ignore: cast_nullable_to_non_nullable
          : balanceMode as String,
    );
  }
}

extension $VisitOutCopyWith on VisitOut {
  /// Returns a callable class that can be used as follows: `instanceOfVisitOut.copyWith(...)` or like so:`instanceOfVisitOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VisitOutCWProxy get copyWith => _$VisitOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitOut _$VisitOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VisitOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'steps',
          'done',
          'currentStep',
          'nextStep',
          'otpStep',
          'balanceCollectedPaise',
          'balanceMode',
        ],
      );
      final val = VisitOut(
        steps: $checkedConvert(
          'steps',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        done: $checkedConvert(
          'done',
          (v) => (v as List<dynamic>)
              .map((e) => StepDoneOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        currentStep: $checkedConvert('currentStep', (v) => v as String),
        nextStep: $checkedConvert('nextStep', (v) => v as String?),
        otpStep: $checkedConvert('otpStep', (v) => v as String),
        otpRetryAt: $checkedConvert(
          'otpRetryAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        noShowReadyAt: $checkedConvert(
          'noShowReadyAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        balanceCollectedPaise: $checkedConvert(
          'balanceCollectedPaise',
          (v) => (v as num?)?.toInt(),
        ),
        balanceMode: $checkedConvert('balanceMode', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$VisitOutToJson(VisitOut instance) => <String, dynamic>{
  'steps': instance.steps,
  'done': instance.done.map((e) => e.toJson()).toList(),
  'currentStep': instance.currentStep,
  'nextStep': instance.nextStep,
  'otpStep': instance.otpStep,
  'otpRetryAt': ?instance.otpRetryAt?.toIso8601String(),
  'noShowReadyAt': ?instance.noShowReadyAt?.toIso8601String(),
  'balanceCollectedPaise': instance.balanceCollectedPaise,
  'balanceMode': instance.balanceMode,
};
