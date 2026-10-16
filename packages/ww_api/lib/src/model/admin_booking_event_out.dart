//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_booking_event_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminBookingEventOut {
  /// Returns a new [AdminBookingEventOut] instance.
  AdminBookingEventOut({

    required  this.fromStatus,

    required  this.status,

    required  this.event,

     this.step = '',

    required  this.actorType,

    required  this.note,

    required  this.at,
  });

  @JsonKey(
    
    name: r'fromStatus',
    required: true,
    includeIfNull: false,
  )


  final String fromStatus;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'event',
    required: true,
    includeIfNull: false,
  )


  final String event;



      /// The job step (event START, STEP, COMPLETE)
  @JsonKey(
    defaultValue: '',
    name: r'step',
    required: false,
    includeIfNull: false,
  )


  final String? step;



  @JsonKey(
    
    name: r'actorType',
    required: true,
    includeIfNull: false,
  )


  final String actorType;



  @JsonKey(
    
    name: r'note',
    required: true,
    includeIfNull: false,
  )


  final String note;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminBookingEventOut &&
      other.fromStatus == fromStatus &&
      other.status == status &&
      other.event == event &&
      other.step == step &&
      other.actorType == actorType &&
      other.note == note &&
      other.at == at;

    @override
    int get hashCode =>
        fromStatus.hashCode +
        status.hashCode +
        event.hashCode +
        step.hashCode +
        actorType.hashCode +
        note.hashCode +
        at.hashCode;

  factory AdminBookingEventOut.fromJson(Map<String, dynamic> json) => _$AdminBookingEventOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminBookingEventOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

