//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bookings_by_service_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingsByServiceOut {
  /// Returns a new [BookingsByServiceOut] instance.
  BookingsByServiceOut({

    required  this.service,

    required  this.booked,

    required  this.completed,

    required  this.cancelled,

    required  this.noShow,

    required  this.open,
  });

  @JsonKey(
    
    name: r'service',
    required: true,
    includeIfNull: false,
  )


  final String service;



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



  @JsonKey(
    
    name: r'noShow',
    required: true,
    includeIfNull: false,
  )


  final int noShow;



  @JsonKey(
    
    name: r'open',
    required: true,
    includeIfNull: false,
  )


  final int open;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingsByServiceOut &&
      other.service == service &&
      other.booked == booked &&
      other.completed == completed &&
      other.cancelled == cancelled &&
      other.noShow == noShow &&
      other.open == open;

    @override
    int get hashCode =>
        service.hashCode +
        booked.hashCode +
        completed.hashCode +
        cancelled.hashCode +
        noShow.hashCode +
        open.hashCode;

  factory BookingsByServiceOut.fromJson(Map<String, dynamic> json) => _$BookingsByServiceOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsByServiceOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

