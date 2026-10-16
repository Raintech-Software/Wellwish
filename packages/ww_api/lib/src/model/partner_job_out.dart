//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_address_out.dart';
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:ww_api/src/model/visit_out.dart';
import 'package:ww_api/src/model/job_member_out.dart';
import 'package:ww_api/src/model/booking_document_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_job_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerJobOut {
  /// Returns a new [PartnerJobOut] instance.
  PartnerJobOut({

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

    required  this.member,

    required  this.bookerName,

    required  this.bookerPhone,

    required  this.address,

    required  this.hospitalText,

    required  this.doctorName,

    required  this.notes,

    required  this.documents,

    required  this.balancePaise,

     this.visit,
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



  @JsonKey(
    
    name: r'member',
    required: true,
    includeIfNull: false,
  )


  final JobMemberOut member;



  @JsonKey(
    
    name: r'bookerName',
    required: true,
    includeIfNull: false,
  )


  final String bookerName;



  @JsonKey(
    
    name: r'bookerPhone',
    required: true,
    includeIfNull: false,
  )


  final String bookerPhone;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final BookingAddressOut address;



  @JsonKey(
    
    name: r'hospitalText',
    required: true,
    includeIfNull: false,
  )


  final String hospitalText;



  @JsonKey(
    
    name: r'doctorName',
    required: true,
    includeIfNull: false,
  )


  final String doctorName;



  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<BookingDocumentOut> documents;



  @JsonKey(
    
    name: r'balancePaise',
    required: true,
    includeIfNull: false,
  )


  final int balancePaise;



      /// R12: the job's steps
  @JsonKey(
    
    name: r'visit',
    required: false,
    includeIfNull: false,
  )


  final VisitOut? visit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerJobOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.service == service &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.memberName == memberName &&
      other.hospitalName == hospitalName &&
      other.area == area &&
      other.reconfirmNeeded == reconfirmNeeded &&
      other.member == member &&
      other.bookerName == bookerName &&
      other.bookerPhone == bookerPhone &&
      other.address == address &&
      other.hospitalText == hospitalText &&
      other.doctorName == doctorName &&
      other.notes == notes &&
      other.documents == documents &&
      other.balancePaise == balancePaise &&
      other.visit == visit;

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
        reconfirmNeeded.hashCode +
        member.hashCode +
        bookerName.hashCode +
        bookerPhone.hashCode +
        address.hashCode +
        hospitalText.hashCode +
        doctorName.hashCode +
        notes.hashCode +
        documents.hashCode +
        balancePaise.hashCode +
        (visit == null ? 0 : visit.hashCode);

  factory PartnerJobOut.fromJson(Map<String, dynamic> json) => _$PartnerJobOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerJobOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

