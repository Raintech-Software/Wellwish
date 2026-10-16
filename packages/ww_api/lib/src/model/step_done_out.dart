//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'step_done_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StepDoneOut {
  /// Returns a new [StepDoneOut] instance.
  StepDoneOut({

    required  this.step,

    required  this.at,

    required  this.by,

    required  this.far,
  });

  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final String step;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



      /// PARTNER, or STAFF when an admin marked it
  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final String by;



      /// Marked more than 300 m from the place
  @JsonKey(
    
    name: r'far',
    required: true,
    includeIfNull: false,
  )


  final bool far;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StepDoneOut &&
      other.step == step &&
      other.at == at &&
      other.by == by &&
      other.far == far;

    @override
    int get hashCode =>
        step.hashCode +
        at.hashCode +
        by.hashCode +
        far.hashCode;

  factory StepDoneOut.fromJson(Map<String, dynamic> json) => _$StepDoneOutFromJson(json);

  Map<String, dynamic> toJson() => _$StepDoneOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

