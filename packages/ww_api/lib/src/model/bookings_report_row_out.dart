//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookings_report_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingsReportRowOut {
  /// Returns a new [BookingsReportRowOut] instance.
  BookingsReportRowOut({

     this.date,

    required  this.booked,

    required  this.completed,

    required  this.cancelled,

    required  this.noShow,

    required  this.open,
  });

      /// India date of the visit; null on the total
  @JsonKey(
    
    name: r'date',
    required: false,
    includeIfNull: false,
  )


  final DateTime? date;



      /// Paid bookings
  @JsonKey(
    
    name: r'booked',
    required: true,
    includeIfNull: false,
  )


  final int booked;



  @JsonKey(
    
    name: r'completed',
    required: true,
    includeIfNull: false,
  )


  final int completed;



  @JsonKey(
    
    name: r'cancelled',
    required: true,
    includeIfNull: false,
  )


  final int cancelled;



      /// Patient not available
  @JsonKey(
    
    name: r'noShow',
    required: true,
    includeIfNull: false,
  )


  final int noShow;



      /// Not finished yet
  @JsonKey(
    
    name: r'open',
    required: true,
    includeIfNull: false,
  )


  final int open;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingsReportRowOut &&
      other.date == date &&
      other.booked == booked &&
      other.completed == completed &&
      other.cancelled == cancelled &&
      other.noShow == noShow &&
      other.open == open;

    @override
    int get hashCode =>
        (date == null ? 0 : date.hashCode) +
        booked.hashCode +
        completed.hashCode +
        cancelled.hashCode +
        noShow.hashCode +
        open.hashCode;

  factory BookingsReportRowOut.fromJson(Map<String, dynamic> json) => _$BookingsReportRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsReportRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

