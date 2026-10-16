//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferOut {
  /// Returns a new [OfferOut] instance.
  OfferOut({

    required  this.id,

    required  this.kind,

    required  this.partnerId,

    required  this.partnerName,

    required  this.phone,

    required  this.alternatePhone,

    required  this.assignedBy,

    required  this.sentAt,

    required  this.timeoutAt,

    required  this.response,

    required  this.respondedAt,

    required  this.declineReason,

    required  this.declineNote,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'alternatePhone',
    required: true,
    includeIfNull: false,
  )


  final String alternatePhone;



  @JsonKey(
    
    name: r'assignedBy',
    required: true,
    includeIfNull: false,
  )


  final String assignedBy;



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



  @JsonKey(
    
    name: r'response',
    required: true,
    includeIfNull: false,
  )


  final String response;



  @JsonKey(
    
    name: r'respondedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? respondedAt;



  @JsonKey(
    
    name: r'declineReason',
    required: true,
    includeIfNull: false,
  )


  final String declineReason;



  @JsonKey(
    
    name: r'declineNote',
    required: true,
    includeIfNull: false,
  )


  final String declineNote;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OfferOut &&
      other.id == id &&
      other.kind == kind &&
      other.partnerId == partnerId &&
      other.partnerName == partnerName &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone &&
      other.assignedBy == assignedBy &&
      other.sentAt == sentAt &&
      other.timeoutAt == timeoutAt &&
      other.response == response &&
      other.respondedAt == respondedAt &&
      other.declineReason == declineReason &&
      other.declineNote == declineNote;

    @override
    int get hashCode =>
        id.hashCode +
        kind.hashCode +
        partnerId.hashCode +
        partnerName.hashCode +
        phone.hashCode +
        alternatePhone.hashCode +
        assignedBy.hashCode +
        sentAt.hashCode +
        timeoutAt.hashCode +
        response.hashCode +
        (respondedAt == null ? 0 : respondedAt.hashCode) +
        declineReason.hashCode +
        declineNote.hashCode;

  factory OfferOut.fromJson(Map<String, dynamic> json) => _$OfferOutFromJson(json);

  Map<String, dynamic> toJson() => _$OfferOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

