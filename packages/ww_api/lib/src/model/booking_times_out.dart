//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_day_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_times_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingTimesOut {
  /// Returns a new [BookingTimesOut] instance.
  BookingTimesOut({

    required  this.date,

    required  this.times,

    required  this.days,

    required  this.timeStepMin,

    required  this.travelBufferMin,
  });

      /// The date the times are for
  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: false,
  )


  final DateTime date;



      /// Times that can be picked, soonest first
  @JsonKey(
    
    name: r'times',
    required: true,
    includeIfNull: false,
  )


  final List<DateTime> times;



      /// Every date in the booking window
  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final List<BookingDayOut> days;



  @JsonKey(
    
    name: r'timeStepMin',
    required: true,
    includeIfNull: false,
  )


  final int timeStepMin;



      /// Suggested pickup = doctor appointment minus this
  @JsonKey(
    
    name: r'travelBufferMin',
    required: true,
    includeIfNull: false,
  )


  final int travelBufferMin;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingTimesOut &&
      other.date == date &&
      other.times == times &&
      other.days == days &&
      other.timeStepMin == timeStepMin &&
      other.travelBufferMin == travelBufferMin;

    @override
    int get hashCode =>
        date.hashCode +
        times.hashCode +
        days.hashCode +
        timeStepMin.hashCode +
        travelBufferMin.hashCode;

  factory BookingTimesOut.fromJson(Map<String, dynamic> json) => _$BookingTimesOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingTimesOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

