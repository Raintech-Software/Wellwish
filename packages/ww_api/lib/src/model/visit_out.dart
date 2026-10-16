//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/step_done_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VisitOut {
  /// Returns a new [VisitOut] instance.
  VisitOut({

    required  this.steps,

    required  this.done,

    required  this.currentStep,

    required  this.nextStep,

    required  this.otpStep,

     this.otpRetryAt,

     this.noShowReadyAt,

    required  this.balanceCollectedPaise,

    required  this.balanceMode,
  });

      /// Every step of this visit type, in order
  @JsonKey(
    
    name: r'steps',
    required: true,
    includeIfNull: false,
  )


  final List<String> steps;



  @JsonKey(
    
    name: r'done',
    required: true,
    includeIfNull: false,
  )


  final List<StepDoneOut> done;



  @JsonKey(
    
    name: r'currentStep',
    required: true,
    includeIfNull: false,
  )


  final String currentStep;



  @JsonKey(
    
    name: r'nextStep',
    required: true,
    includeIfNull: true,
  )


  final String? nextStep;



      /// The step that needs the job OTP
  @JsonKey(
    
    name: r'otpStep',
    required: true,
    includeIfNull: false,
  )


  final String otpStep;



      /// After 4 wrong codes: the next try from then (5, 10, 20 min…)
  @JsonKey(
    
    name: r'otpRetryAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? otpRetryAt;



      /// From then, 'patient not available' (after a call attempt)
  @JsonKey(
    
    name: r'noShowReadyAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? noShowReadyAt;



  @JsonKey(
    
    name: r'balanceCollectedPaise',
    required: true,
    includeIfNull: true,
  )


  final int? balanceCollectedPaise;



  @JsonKey(
    
    name: r'balanceMode',
    required: true,
    includeIfNull: false,
  )


  final String balanceMode;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VisitOut &&
      other.steps == steps &&
      other.done == done &&
      other.currentStep == currentStep &&
      other.nextStep == nextStep &&
      other.otpStep == otpStep &&
      other.otpRetryAt == otpRetryAt &&
      other.noShowReadyAt == noShowReadyAt &&
      other.balanceCollectedPaise == balanceCollectedPaise &&
      other.balanceMode == balanceMode;

    @override
    int get hashCode =>
        steps.hashCode +
        done.hashCode +
        currentStep.hashCode +
        (nextStep == null ? 0 : nextStep.hashCode) +
        otpStep.hashCode +
        (otpRetryAt == null ? 0 : otpRetryAt.hashCode) +
        (noShowReadyAt == null ? 0 : noShowReadyAt.hashCode) +
        (balanceCollectedPaise == null ? 0 : balanceCollectedPaise.hashCode) +
        balanceMode.hashCode;

  factory VisitOut.fromJson(Map<String, dynamic> json) => _$VisitOutFromJson(json);

  Map<String, dynamic> toJson() => _$VisitOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

