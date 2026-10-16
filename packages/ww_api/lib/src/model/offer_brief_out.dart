//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offer_brief_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfferBriefOut {
  /// Returns a new [OfferBriefOut] instance.
  OfferBriefOut({

    required  this.assignmentId,

    required  this.kind,

    required  this.partnerId,

    required  this.partnerName,

    required  this.sentAt,

    required  this.timeoutAt,
  });

  @JsonKey(
    
    name: r'assignmentId',
    required: true,
    includeIfNull: false,
  )


  final String assignmentId;



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
    bool operator ==(Object other) => identical(this, other) || other is OfferBriefOut &&
      other.assignmentId == assignmentId &&
      other.kind == kind &&
      other.partnerId == partnerId &&
      other.partnerName == partnerName &&
      other.sentAt == sentAt &&
      other.timeoutAt == timeoutAt;

    @override
    int get hashCode =>
        assignmentId.hashCode +
        kind.hashCode +
        partnerId.hashCode +
        partnerName.hashCode +
        sentAt.hashCode +
        timeoutAt.hashCode;

  factory OfferBriefOut.fromJson(Map<String, dynamic> json) => _$OfferBriefOutFromJson(json);

  Map<String, dynamic> toJson() => _$OfferBriefOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

