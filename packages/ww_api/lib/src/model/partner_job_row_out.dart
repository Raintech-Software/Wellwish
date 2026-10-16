//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_job_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerJobRowOut {
  /// Returns a new [PartnerJobRowOut] instance.
  PartnerJobRowOut({

    required  this.id,

    required  this.code,

    required  this.status,

    required  this.service,

    required  this.pickupAt,

    required  this.appointmentAt,

    required  this.memberName,

    required  this.hospitalName,

    required  this.area,

    required  this.reconfirmNeeded,
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
    
    name: r'memberName',
    required: true,
    includeIfNull: false,
  )


  final String memberName;



  @JsonKey(
    
    name: r'hospitalName',
    required: true,
    includeIfNull: false,
  )


  final String hospitalName;



  @JsonKey(
    
    name: r'area',
    required: true,
    includeIfNull: false,
  )


  final String area;



  @JsonKey(
    
    name: r'reconfirmNeeded',
    required: true,
    includeIfNull: false,
  )


  final bool reconfirmNeeded;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerJobRowOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.service == service &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.memberName == memberName &&
      other.hospitalName == hospitalName &&
      other.area == area &&
      other.reconfirmNeeded == reconfirmNeeded;

    @override
    int get hashCode =>
        id.hashCode +
        code.hashCode +
        status.hashCode +
        service.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        memberName.hashCode +
        hospitalName.hashCode +
        area.hashCode +
        reconfirmNeeded.hashCode;

  factory PartnerJobRowOut.fromJson(Map<String, dynamic> json) => _$PartnerJobRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerJobRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

