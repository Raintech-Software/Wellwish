//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingRowOut {
  /// Returns a new [BookingRowOut] instance.
  BookingRowOut({

    required  this.id,

    required  this.code,

    required  this.status,

    required  this.service,

    required  this.memberName,

    required  this.pickupAt,

    required  this.appointmentAt,

    required  this.hospitalName,

    required  this.createdAt,

     this.payBy,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'service',
    required: true,
    includeIfNull: false,
  )


  final BookingServiceOut service;



  @JsonKey(
    
    name: r'memberName',
    required: true,
    includeIfNull: false,
  )


  final String memberName;



  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



  @JsonKey(
    
    name: r'appointmentAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? appointmentAt;



  @JsonKey(
    
    name: r'hospitalName',
    required: true,
    includeIfNull: false,
  )


  final String hospitalName;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// Unpaid bookings expire at this time
  @JsonKey(
    
    name: r'payBy',
    required: false,
    includeIfNull: false,
  )


  final DateTime? payBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingRowOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.service == service &&
      other.memberName == memberName &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.hospitalName == hospitalName &&
      other.createdAt == createdAt &&
      other.payBy == payBy;

    @override
    int get hashCode =>
        id.hashCode +
        code.hashCode +
        status.hashCode +
        service.hashCode +
        memberName.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        hospitalName.hashCode +
        createdAt.hashCode +
        (payBy == null ? 0 : payBy.hashCode);

  factory BookingRowOut.fromJson(Map<String, dynamic> json) => _$BookingRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

