//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/offer_brief_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'queue_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QueueRowOut {
  /// Returns a new [QueueRowOut] instance.
  QueueRowOut({

    required  this.id,

    required  this.code,

    required  this.status,

    required  this.pickupAt,

    required  this.appointmentAt,

    required  this.serviceName,

    required  this.partnerType,

    required  this.visitType,

    required  this.memberName,

    required  this.hospitalName,

    required  this.deadlineAt,

    required  this.late_,

    required  this.offer,

    required  this.openAlerts,

     this.problem = '',
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
    
    name: r'deadlineAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime deadlineAt;



      /// Past the assign deadline
  @JsonKey(
    
    name: r'late',
    required: true,
    includeIfNull: false,
  )


  final bool late_;



  @JsonKey(
    
    name: r'offer',
    required: true,
    includeIfNull: true,
  )


  final OfferBriefOut? offer;



  @JsonKey(
    
    name: r'openAlerts',
    required: true,
    includeIfNull: false,
  )


  final int openAlerts;



      /// Why an ACCEPTED booking is here: RECONFIRM (new time not confirmed) or PARTNER_UNAVAILABLE (the partner was suspended)
  @JsonKey(
    defaultValue: '',
    name: r'problem',
    required: false,
    includeIfNull: false,
  )


  final String? problem;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QueueRowOut &&
      other.id == id &&
      other.code == code &&
      other.status == status &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.serviceName == serviceName &&
      other.partnerType == partnerType &&
      other.visitType == visitType &&
      other.memberName == memberName &&
      other.hospitalName == hospitalName &&
      other.deadlineAt == deadlineAt &&
      other.late_ == late_ &&
      other.offer == offer &&
      other.openAlerts == openAlerts &&
      other.problem == problem;

    @override
    int get hashCode =>
        id.hashCode +
        code.hashCode +
        status.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        serviceName.hashCode +
        partnerType.hashCode +
        visitType.hashCode +
        memberName.hashCode +
        hospitalName.hashCode +
        deadlineAt.hashCode +
        late_.hashCode +
        (offer == null ? 0 : offer.hashCode) +
        openAlerts.hashCode +
        problem.hashCode;

  factory QueueRowOut.fromJson(Map<String, dynamic> json) => _$QueueRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$QueueRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

