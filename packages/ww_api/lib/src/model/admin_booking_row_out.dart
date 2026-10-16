//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_booking_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminBookingRowOut {
  /// Returns a new [AdminBookingRowOut] instance.
  AdminBookingRowOut({

    required  this.id,

    required  this.code,

    required  this.status,

    required  this.patientDeleted,

    required  this.serviceName,

    required  this.partnerType,

    required  this.visitType,

    required  this.pickupAt,

    required  this.appointmentAt,

    required  this.memberName,

    required  this.patientPhone,

    required  this.hospitalName,

    required  this.bookingFeePaise,

    required  this.createdAt,

     this.temporaryPartner = false,
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



      /// The account was erased (§12)
  @JsonKey(
    
    name: r'patientDeleted',
    required: true,
    includeIfNull: false,
  )


  final bool patientDeleted;



  @JsonKey(
    
    name: r'serviceName',
    required: true,
    includeIfNull: false,
  )


  final String serviceName;



  @JsonKey(
    
    name: r'partnerType',
    required: true,
    includeIfNull: false,
  )


  final String partnerType;



  @JsonKey(
    
    name: r'visitType',
    required: true,
    includeIfNull: false,
  )


  final String visitType;



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
    
    name: r'patientPhone',
    required: true,
    includeIfNull: false,
  )


  final String patientPhone;



  @JsonKey(
    
    name: r'hospitalName',
    required: true,
    includeIfNull: false,
  )


  final String hospitalName;



  @JsonKey(
    
    name: r'bookingFeePaise',
    required: true,
    includeIfNull: false,
  )


  final int bookingFeePaise;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// §6.19: the partner is a temporary one (admin panel only)
  @JsonKey(
    defaultValue: false,
    name: r'temporaryPartner',
    required: false,
    includeIfNull: false,
  )


  final bool? temporaryPartner;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminBookingRowOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.patientDeleted == patientDeleted &&
      other.serviceName == serviceName &&
      other.partnerType == partnerType &&
      other.visitType == visitType &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.memberName == memberName &&
      other.patientPhone == patientPhone &&
      other.hospitalName == hospitalName &&
      other.bookingFeePaise == bookingFeePaise &&
      other.createdAt == createdAt &&
      other.temporaryPartner == temporaryPartner;

    @override
    int get hashCode =>
        id.hashCode +
        code.hashCode +
        status.hashCode +
        patientDeleted.hashCode +
        serviceName.hashCode +
        partnerType.hashCode +
        visitType.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        memberName.hashCode +
        patientPhone.hashCode +
        hospitalName.hashCode +
        bookingFeePaise.hashCode +
        createdAt.hashCode +
        temporaryPartner.hashCode;

  factory AdminBookingRowOut.fromJson(Map<String, dynamic> json) => _$AdminBookingRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminBookingRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

