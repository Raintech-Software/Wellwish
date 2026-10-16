//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_address_out.dart';
import 'package:ww_api/src/model/booking_member_out.dart';
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:ww_api/src/model/admin_refund_out.dart';
import 'package:ww_api/src/model/admin_booking_patient_out.dart';
import 'package:ww_api/src/model/visit_out.dart';
import 'package:ww_api/src/model/admin_booking_event_out.dart';
import 'package:ww_api/src/model/admin_payment_out.dart';
import 'package:ww_api/src/model/booking_document_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_booking_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminBookingDetailOut {
  /// Returns a new [AdminBookingDetailOut] instance.
  AdminBookingDetailOut({

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

    required  this.service,

    required  this.patient,

    required  this.member,

    required  this.address,

    required  this.hospitalId,

    required  this.hospitalText,

    required  this.doctorId,

    required  this.doctorName,

    required  this.notes,

    required  this.notesVisible,

    required  this.rescheduleCount,

    required  this.documentsVisible,

    required  this.documents,

    required  this.timeline,

    required  this.reconfirmNeeded,

    required  this.payments,

    required  this.refunds,

    required  this.canCancel,

    required  this.canReschedule,

    required  this.timeStepMin,

     this.visit,

    required  this.paidPaise,
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



  @JsonKey(
    
    name: r'service',
    required: true,
    includeIfNull: false,
  )


  final BookingServiceOut service;



  @JsonKey(
    
    name: r'patient',
    required: true,
    includeIfNull: false,
  )


  final AdminBookingPatientOut patient;



  @JsonKey(
    
    name: r'member',
    required: true,
    includeIfNull: false,
  )


  final BookingMemberOut member;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final BookingAddressOut address;



  @JsonKey(
    
    name: r'hospitalId',
    required: true,
    includeIfNull: true,
  )


  final String? hospitalId;



  @JsonKey(
    
    name: r'hospitalText',
    required: true,
    includeIfNull: false,
  )


  final String hospitalText;



  @JsonKey(
    
    name: r'doctorId',
    required: true,
    includeIfNull: true,
  )


  final String? doctorId;



  @JsonKey(
    
    name: r'doctorName',
    required: true,
    includeIfNull: false,
  )


  final String doctorName;



      /// Empty when notes_visible is false
  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;



      /// The patient's notes can be medical: only roles with patients.documents
  @JsonKey(
    
    name: r'notesVisible',
    required: true,
    includeIfNull: false,
  )


  final bool notesVisible;



  @JsonKey(
    
    name: r'rescheduleCount',
    required: true,
    includeIfNull: false,
  )


  final int rescheduleCount;



      /// False: the role can't see patient documents (titles hidden)
  @JsonKey(
    
    name: r'documentsVisible',
    required: true,
    includeIfNull: false,
  )


  final bool documentsVisible;



  @JsonKey(
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<BookingDocumentOut> documents;



  @JsonKey(
    
    name: r'timeline',
    required: true,
    includeIfNull: false,
  )


  final List<AdminBookingEventOut> timeline;



  @JsonKey(
    
    name: r'reconfirmNeeded',
    required: true,
    includeIfNull: false,
  )


  final bool reconfirmNeeded;



  @JsonKey(
    
    name: r'payments',
    required: true,
    includeIfNull: false,
  )


  final List<AdminPaymentOut> payments;



  @JsonKey(
    
    name: r'refunds',
    required: true,
    includeIfNull: false,
  )


  final List<AdminRefundOut> refunds;



  @JsonKey(
    
    name: r'canCancel',
    required: true,
    includeIfNull: false,
  )


  final bool canCancel;



  @JsonKey(
    
    name: r'canReschedule',
    required: true,
    includeIfNull: false,
  )


  final bool canReschedule;



      /// Pickup times are on this step (reschedule picker)
  @JsonKey(
    
    name: r'timeStepMin',
    required: true,
    includeIfNull: false,
  )


  final int timeStepMin;



      /// From acceptance: the job's steps
  @JsonKey(
    
    name: r'visit',
    required: false,
    includeIfNull: false,
  )


  final VisitOut? visit;



      /// The fee that paid for the booking
  @JsonKey(
    
    name: r'paidPaise',
    required: true,
    includeIfNull: false,
  )


  final int paidPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminBookingDetailOut &&
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
      other.temporaryPartner == temporaryPartner &&
      other.service == service &&
      other.patient == patient &&
      other.member == member &&
      other.address == address &&
      other.hospitalId == hospitalId &&
      other.hospitalText == hospitalText &&
      other.doctorId == doctorId &&
      other.doctorName == doctorName &&
      other.notes == notes &&
      other.notesVisible == notesVisible &&
      other.rescheduleCount == rescheduleCount &&
      other.documentsVisible == documentsVisible &&
      other.documents == documents &&
      other.timeline == timeline &&
      other.reconfirmNeeded == reconfirmNeeded &&
      other.payments == payments &&
      other.refunds == refunds &&
      other.canCancel == canCancel &&
      other.canReschedule == canReschedule &&
      other.timeStepMin == timeStepMin &&
      other.visit == visit &&
      other.paidPaise == paidPaise;

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
        temporaryPartner.hashCode +
        service.hashCode +
        patient.hashCode +
        member.hashCode +
        address.hashCode +
        (hospitalId == null ? 0 : hospitalId.hashCode) +
        hospitalText.hashCode +
        (doctorId == null ? 0 : doctorId.hashCode) +
        doctorName.hashCode +
        notes.hashCode +
        notesVisible.hashCode +
        rescheduleCount.hashCode +
        documentsVisible.hashCode +
        documents.hashCode +
        timeline.hashCode +
        reconfirmNeeded.hashCode +
        payments.hashCode +
        refunds.hashCode +
        canCancel.hashCode +
        canReschedule.hashCode +
        timeStepMin.hashCode +
        (visit == null ? 0 : visit.hashCode) +
        paidPaise.hashCode;

  factory AdminBookingDetailOut.fromJson(Map<String, dynamic> json) => _$AdminBookingDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminBookingDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

