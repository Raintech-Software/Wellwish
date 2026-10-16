//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_timeline_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingTimelineOut {
  /// Returns a new [BookingTimelineOut] instance.
  BookingTimelineOut({

    required  this.status,

    required  this.event,

     this.step = '',

    required  this.at,
  });

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
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingTimelineOut &&
      other.status == status &&
      other.event == event &&
      other.step == step &&
      other.at == at;

    @override
    int get hashCode =>
        status.hashCode +
        event.hashCode +
        step.hashCode +
        at.hashCode;

  factory BookingTimelineOut.fromJson(Map<String, dynamic> json) => _$BookingTimelineOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingTimelineOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

