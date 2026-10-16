//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_step_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminStepIn {
  /// Returns a new [AdminStepIn] instance.
  AdminStepIn({

    required  this.step,

    required  this.reason,
  });

  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final AdminStepInStepEnum step;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminStepIn &&
      other.step == step &&
      other.reason == reason;

    @override
    int get hashCode =>
        step.hashCode +
        reason.hashCode;

  factory AdminStepIn.fromJson(Map<String, dynamic> json) => _$AdminStepInFromJson(json);

  Map<String, dynamic> toJson() => _$AdminStepInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminStepInStepEnum {
@JsonValue(r'ON_THE_WAY')
ON_THE_WAY(r'ON_THE_WAY'),
@JsonValue(r'REACHED_PATIENT')
REACHED_PATIENT(r'REACHED_PATIENT'),
@JsonValue(r'PICKED_UP')
PICKED_UP(r'PICKED_UP'),
@JsonValue(r'REACHED_HOSPITAL')
REACHED_HOSPITAL(r'REACHED_HOSPITAL'),
@JsonValue(r'VISIT_DONE')
VISIT_DONE(r'VISIT_DONE'),
@JsonValue(r'DROPPED_HOME')
DROPPED_HOME(r'DROPPED_HOME'),
@JsonValue(r'REACHED_HOME')
REACHED_HOME(r'REACHED_HOME'),
@JsonValue(r'STARTED')
STARTED(r'STARTED'),
@JsonValue(r'CARE_DONE')
CARE_DONE(r'CARE_DONE'),
@JsonValue(r'AT_PLACE')
AT_PLACE(r'AT_PLACE'),
@JsonValue(r'TASK_DONE')
TASK_DONE(r'TASK_DONE'),
@JsonValue(r'DELIVERED')
DELIVERED(r'DELIVERED'),
@JsonValue(r'COMPLETED')
COMPLETED(r'COMPLETED');

const AdminStepInStepEnum(this.value);

final String value;

@override
String toString() => value;
}


