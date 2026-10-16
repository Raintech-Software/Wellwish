//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_address_out.dart';
import 'package:ww_api/src/model/booking_timeline_out.dart';
import 'package:ww_api/src/model/booking_member_out.dart';
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:ww_api/src/model/assigned_partner_out.dart';
import 'package:ww_api/src/model/review_out.dart';
import 'package:ww_api/src/model/visit_out.dart';
import 'package:ww_api/src/model/booking_refund_out.dart';
import 'package:ww_api/src/model/booking_document_out.dart';
import 'package:ww_api/src/model/ticket_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_detail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingDetailOut {
  /// Returns a new [BookingDetailOut] instance.
  BookingDetailOut({

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

    required  this.member,

    required  this.address,

    required  this.hospitalId,

    required  this.doctorId,

    required  this.doctorName,

    required  this.notes,

    required  this.documents,

    required  this.timeline,

    required  this.paidPaise,

    required  this.refunds,

    required  this.canCancel,

    required  this.canReschedule,

     this.rescheduleProblem,

    required  this.reschedulesLeft,

    required  this.reconfirmNeeded,

     this.paymentPending = false,

     this.partner,

     this.visit,

     this.review,

     this.canReview = false,

     this.canReport = false,

     this.tickets,

     this.jobOtp,
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
    
    name: r'timeline',
    required: true,
    includeIfNull: false,
  )


  final List<BookingTimelineOut> timeline;



      /// The booking fee captured (0 until paid)
  @JsonKey(
    
    name: r'paidPaise',
    required: true,
    includeIfNull: false,
  )


  final int paidPaise;



  @JsonKey(
    
    name: r'refunds',
    required: true,
    includeIfNull: false,
  )


  final List<BookingRefundOut> refunds;



      /// The patient can still cancel in the app
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



      /// Why the time can't be changed: STATUS, TOO_LATE or LIMIT
  @JsonKey(
    
    name: r'rescheduleProblem',
    required: false,
    includeIfNull: false,
  )


  final String? rescheduleProblem;



  @JsonKey(
    
    name: r'reschedulesLeft',
    required: true,
    includeIfNull: false,
  )


  final int reschedulesLeft;



      /// The partner must confirm the new time
  @JsonKey(
    
    name: r'reconfirmNeeded',
    required: true,
    includeIfNull: false,
  )


  final bool reconfirmNeeded;



      /// A payment is being confirmed with Razorpay (don't offer Pay)
  @JsonKey(
    defaultValue: false,
    name: r'paymentPending',
    required: false,
    includeIfNull: false,
  )


  final bool? paymentPending;



      /// Once a partner accepted (shown until the job is over)
  @JsonKey(
    
    name: r'partner',
    required: false,
    includeIfNull: false,
  )


  final AssignedPartnerOut? partner;



      /// From acceptance: the job's steps
  @JsonKey(
    
    name: r'visit',
    required: false,
    includeIfNull: false,
  )


  final VisitOut? visit;



      /// Your rating of the visit
  @JsonKey(
    
    name: r'review',
    required: false,
    includeIfNull: false,
  )


  final ReviewOut? review;



      /// Completed and not rated yet
  @JsonKey(
    defaultValue: false,
    name: r'canReview',
    required: false,
    includeIfNull: false,
  )


  final bool? canReview;



      /// Within 24 h after the visit
  @JsonKey(
    defaultValue: false,
    name: r'canReport',
    required: false,
    includeIfNull: false,
  )


  final bool? canReport;



      /// Problems you reported
  @JsonKey(
    
    name: r'tickets',
    required: false,
    includeIfNull: false,
  )


  final List<TicketOut>? tickets;



      /// Give it to the partner when they arrive (until that step is done)
  @JsonKey(
    
    name: r'jobOtp',
    required: false,
    includeIfNull: false,
  )


  final String? jobOtp;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingDetailOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.service == service &&
      other.memberName == memberName &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.hospitalName == hospitalName &&
      other.createdAt == createdAt &&
      other.payBy == payBy &&
      other.member == member &&
      other.address == address &&
      other.hospitalId == hospitalId &&
      other.doctorId == doctorId &&
      other.doctorName == doctorName &&
      other.notes == notes &&
      other.documents == documents &&
      other.timeline == timeline &&
      other.paidPaise == paidPaise &&
      other.refunds == refunds &&
      other.canCancel == canCancel &&
      other.canReschedule == canReschedule &&
      other.rescheduleProblem == rescheduleProblem &&
      other.reschedulesLeft == reschedulesLeft &&
      other.reconfirmNeeded == reconfirmNeeded &&
      other.paymentPending == paymentPending &&
      other.partner == partner &&
      other.visit == visit &&
      other.review == review &&
      other.canReview == canReview &&
      other.canReport == canReport &&
      other.tickets == tickets &&
      other.jobOtp == jobOtp;

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
        (payBy == null ? 0 : payBy.hashCode) +
        member.hashCode +
        address.hashCode +
        (hospitalId == null ? 0 : hospitalId.hashCode) +
        (doctorId == null ? 0 : doctorId.hashCode) +
        doctorName.hashCode +
        notes.hashCode +
        documents.hashCode +
        timeline.hashCode +
        paidPaise.hashCode +
        refunds.hashCode +
        canCancel.hashCode +
        canReschedule.hashCode +
        (rescheduleProblem == null ? 0 : rescheduleProblem.hashCode) +
        reschedulesLeft.hashCode +
        reconfirmNeeded.hashCode +
        paymentPending.hashCode +
        (partner == null ? 0 : partner.hashCode) +
        (visit == null ? 0 : visit.hashCode) +
        (review == null ? 0 : review.hashCode) +
        canReview.hashCode +
        canReport.hashCode +
        tickets.hashCode +
        (jobOtp == null ? 0 : jobOtp.hashCode);

  factory BookingDetailOut.fromJson(Map<String, dynamic> json) => _$BookingDetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

