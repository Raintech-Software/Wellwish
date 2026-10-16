//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/assigned_partner_brief_out.dart';
import 'package:ww_api/src/model/offer_out.dart';
import 'package:ww_api/src/model/alert_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assignment_state_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AssignmentStateOut {
  /// Returns a new [AssignmentStateOut] instance.
  AssignmentStateOut({

    required  this.bookingId,

    required  this.status,

    required  this.deadlineAt,

    required  this.late_,

    required  this.canAssign,

    required  this.canUnassign,

    required  this.currentAssignmentId,

    required  this.openOffer,

    required  this.partner,

    required  this.reconfirmNeeded,

    required  this.offers,

    required  this.alerts,
  });

  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'deadlineAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime deadlineAt;



  @JsonKey(
    
    name: r'late',
    required: true,
    includeIfNull: false,
  )


  final bool late_;



  @JsonKey(
    
    name: r'canAssign',
    required: true,
    includeIfNull: false,
  )


  final bool canAssign;



  @JsonKey(
    
    name: r'canUnassign',
    required: true,
    includeIfNull: false,
  )


  final bool canUnassign;



      /// Send back as `expectedAssignmentId` (assign, accepted by phone, unassign)
  @JsonKey(
    
    name: r'currentAssignmentId',
    required: true,
    includeIfNull: true,
  )


  final String? currentAssignmentId;



  @JsonKey(
    
    name: r'openOffer',
    required: true,
    includeIfNull: true,
  )


  final OfferOut? openOffer;



  @JsonKey(
    
    name: r'partner',
    required: true,
    includeIfNull: true,
  )


  final AssignedPartnerBriefOut? partner;



  @JsonKey(
    
    name: r'reconfirmNeeded',
    required: true,
    includeIfNull: false,
  )


  final bool reconfirmNeeded;



  @JsonKey(
    
    name: r'offers',
    required: true,
    includeIfNull: false,
  )


  final List<OfferOut> offers;



  @JsonKey(
    
    name: r'alerts',
    required: true,
    includeIfNull: false,
  )


  final List<AlertOut> alerts;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AssignmentStateOut &&
      other.bookingId == bookingId &&
      other.status == status &&
      other.deadlineAt == deadlineAt &&
      other.late_ == late_ &&
      other.canAssign == canAssign &&
      other.canUnassign == canUnassign &&
      other.currentAssignmentId == currentAssignmentId &&
      other.openOffer == openOffer &&
      other.partner == partner &&
      other.reconfirmNeeded == reconfirmNeeded &&
      other.offers == offers &&
      other.alerts == alerts;

    @override
    int get hashCode =>
        bookingId.hashCode +
        status.hashCode +
        deadlineAt.hashCode +
        late_.hashCode +
        canAssign.hashCode +
        canUnassign.hashCode +
        (currentAssignmentId == null ? 0 : currentAssignmentId.hashCode) +
        (openOffer == null ? 0 : openOffer.hashCode) +
        (partner == null ? 0 : partner.hashCode) +
        reconfirmNeeded.hashCode +
        offers.hashCode +
        alerts.hashCode;

  factory AssignmentStateOut.fromJson(Map<String, dynamic> json) => _$AssignmentStateOutFromJson(json);

  Map<String, dynamic> toJson() => _$AssignmentStateOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

