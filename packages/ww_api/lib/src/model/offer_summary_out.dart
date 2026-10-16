//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/booking_service_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_summary_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferSummaryOut {
  /// Returns a new [OfferSummaryOut] instance.
  OfferSummaryOut({

    required  this.assignmentId,

    required  this.kind,

    required  this.response,

    required  this.bookingId,

    required  this.code,

    required  this.service,

    required  this.pickupAt,

    required  this.appointmentAt,

    required  this.area,

    required  this.distanceKm,

    required  this.hospitalName,

    required  this.memberAge,

    required  this.memberGender,

    required  this.language,

    required  this.mobility,

    required  this.documentsAttached,

    required  this.hasPrescription,

    required  this.balancePaise,

    required  this.sentAt,

    required  this.timeoutAt,
  });

  @JsonKey(
    
    name: r'assignmentId',
    required: true,
    includeIfNull: false,
  )


  final String assignmentId;



      /// NEW, or RECONFIRM: confirm the new time
  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



      /// OPEN (answer it), ACCEPTED / ACCEPTED_BY_PHONE (the job is theirs), DECLINED or WITHDRAWN (no longer theirs)
  @JsonKey(
    
    name: r'response',
    required: true,
    includeIfNull: false,
  )


  final String response;



  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



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



      /// Locality only (no house number)
  @JsonKey(
    
    name: r'area',
    required: true,
    includeIfNull: false,
  )


  final String area;



  @JsonKey(
    
    name: r'distanceKm',
    required: true,
    includeIfNull: true,
  )


  final num? distanceKm;



  @JsonKey(
    
    name: r'hospitalName',
    required: true,
    includeIfNull: false,
  )


  final String hospitalName;



  @JsonKey(
    
    name: r'memberAge',
    required: true,
    includeIfNull: true,
  )


  final int? memberAge;



  @JsonKey(
    
    name: r'memberGender',
    required: true,
    includeIfNull: false,
  )


  final String memberGender;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



  @JsonKey(
    
    name: r'mobility',
    required: true,
    includeIfNull: false,
  )


  final String mobility;



  @JsonKey(
    
    name: r'documentsAttached',
    required: true,
    includeIfNull: false,
  )


  final int documentsAttached;



  @JsonKey(
    
    name: r'hasPrescription',
    required: true,
    includeIfNull: false,
  )


  final bool hasPrescription;



  @JsonKey(
    
    name: r'balancePaise',
    required: true,
    includeIfNull: false,
  )


  final int balancePaise;



  @JsonKey(
    
    name: r'sentAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime sentAt;



  @JsonKey(
    
    name: r'timeoutAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime timeoutAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OfferSummaryOut &&
      other.assignmentId == assignmentId &&
      other.kind == kind &&
      other.response == response &&
      other.bookingId == bookingId &&
      other.code == code &&
      other.service == service &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.area == area &&
      other.distanceKm == distanceKm &&
      other.hospitalName == hospitalName &&
      other.memberAge == memberAge &&
      other.memberGender == memberGender &&
      other.language == language &&
      other.mobility == mobility &&
      other.documentsAttached == documentsAttached &&
      other.hasPrescription == hasPrescription &&
      other.balancePaise == balancePaise &&
      other.sentAt == sentAt &&
      other.timeoutAt == timeoutAt;

    @override
    int get hashCode =>
        assignmentId.hashCode +
        kind.hashCode +
        response.hashCode +
        bookingId.hashCode +
        code.hashCode +
        service.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        area.hashCode +
        (distanceKm == null ? 0 : distanceKm.hashCode) +
        hospitalName.hashCode +
        (memberAge == null ? 0 : memberAge.hashCode) +
        memberGender.hashCode +
        language.hashCode +
        mobility.hashCode +
        documentsAttached.hashCode +
        hasPrescription.hashCode +
        balancePaise.hashCode +
        sentAt.hashCode +
        timeoutAt.hashCode;

  factory OfferSummaryOut.fromJson(Map<String, dynamic> json) => _$OfferSummaryOutFromJson(json);

  Map<String, dynamic> toJson() => _$OfferSummaryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

