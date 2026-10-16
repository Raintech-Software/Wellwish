//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/vitals_in.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'step_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StepIn {
  /// Returns a new [StepIn] instance.
  StepIn({

     this.lat,

     this.lng,

     this.accuracy,

     this.clientTs,

     this.mock = false,

    required  this.step,

     this.otp = '',

     this.note = '',

     this.vitals,
  });

  @JsonKey(
    
    name: r'lat',
    required: false,
    includeIfNull: false,
  )


  final String? lat;



  @JsonKey(
    
    name: r'lng',
    required: false,
    includeIfNull: false,
  )


  final String? lng;



      /// Metres
          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'accuracy',
    required: false,
    includeIfNull: false,
  )


  final num? accuracy;



      /// When it was tapped on the phone
  @JsonKey(
    
    name: r'clientTs',
    required: false,
    includeIfNull: false,
  )


  final DateTime? clientTs;



      /// Android said it is a fake (mock) location: not kept, admin told
  @JsonKey(
    defaultValue: false,
    name: r'mock',
    required: false,
    includeIfNull: false,
  )


  final bool? mock;



  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final StepInStepEnum step;



      /// At the OTP step
  @JsonKey(
    defaultValue: '',
    name: r'otp',
    required: false,
    includeIfNull: false,
  )


  final String? otp;



      /// The care note at CARE_DONE (nurses)
  @JsonKey(
    defaultValue: '',
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



  @JsonKey(
    
    name: r'vitals',
    required: false,
    includeIfNull: false,
  )


  final VitalsIn? vitals;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StepIn &&
      other.lat == lat &&
      other.lng == lng &&
      other.accuracy == accuracy &&
      other.clientTs == clientTs &&
      other.mock == mock &&
      other.step == step &&
      other.otp == otp &&
      other.note == note &&
      other.vitals == vitals;

    @override
    int get hashCode =>
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        (accuracy == null ? 0 : accuracy.hashCode) +
        (clientTs == null ? 0 : clientTs.hashCode) +
        mock.hashCode +
        step.hashCode +
        otp.hashCode +
        note.hashCode +
        (vitals == null ? 0 : vitals.hashCode);

  factory StepIn.fromJson(Map<String, dynamic> json) => _$StepInFromJson(json);

  Map<String, dynamic> toJson() => _$StepInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum StepInStepEnum {
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

const StepInStepEnum(this.value);

final String value;

@override
String toString() => value;
}


