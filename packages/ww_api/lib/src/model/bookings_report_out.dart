//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/bookings_report_row_out.dart';
import 'package:ww_api/src/model/bookings_by_service_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookings_report_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingsReportOut {
  /// Returns a new [BookingsReportOut] instance.
  BookingsReportOut({

    required  this.start,

    required  this.end,

    required  this.days,

    required  this.services,

    required  this.total,
  });

  @JsonKey(
    
    name: r'start',
    required: true,
    includeIfNull: false,
  )


  final DateTime start;



  @JsonKey(
    
    name: r'end',
    required: true,
    includeIfNull: false,
  )


  final DateTime end;



  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final List<BookingsReportRowOut> days;



  @JsonKey(
    
    name: r'services',
    required: true,
    includeIfNull: false,
  )


  final List<BookingsByServiceOut> services;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final BookingsReportRowOut total;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingsReportOut &&
      other.start == start &&
      other.end == end &&
      other.days == days &&
      other.services == services &&
      other.total == total;

    @override
    int get hashCode =>
        start.hashCode +
        end.hashCode +
        days.hashCode +
        services.hashCode +
        total.hashCode;

  factory BookingsReportOut.fromJson(Map<String, dynamic> json) => _$BookingsReportOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsReportOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

