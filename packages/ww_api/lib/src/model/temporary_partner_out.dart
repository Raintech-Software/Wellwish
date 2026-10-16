//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_partner_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TemporaryPartnerOut {
  /// Returns a new [TemporaryPartnerOut] instance.
  TemporaryPartnerOut({

    required  this.partnerId,

    required  this.fullName,

    required  this.phone,

    required  this.status,

    required  this.idType,

    required  this.idLast4,

    required  this.nursingRegNo,

    required  this.reason,

    required  this.checkedBy,

    required  this.checkedAt,

    required  this.endedAt,

    required  this.endReason,

     this.selfieUrl,
  });

  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// TEMPORARY while the job runs, then TEMP_ENDED
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'idType',
    required: true,
    includeIfNull: false,
  )


  final String idType;



  @JsonKey(
    
    name: r'idLast4',
    required: true,
    includeIfNull: false,
  )


  final String idLast4;



  @JsonKey(
    
    name: r'nursingRegNo',
    required: true,
    includeIfNull: false,
  )


  final String nursingRegNo;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'checkedBy',
    required: true,
    includeIfNull: false,
  )


  final String checkedBy;



  @JsonKey(
    
    name: r'checkedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime checkedAt;



  @JsonKey(
    
    name: r'endedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? endedAt;



  @JsonKey(
    
    name: r'endReason',
    required: true,
    includeIfNull: false,
  )


  final String endReason;



      /// Their selfie for this job (taken on the visit day), once taken
  @JsonKey(
    
    name: r'selfieUrl',
    required: false,
    includeIfNull: false,
  )


  final String? selfieUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TemporaryPartnerOut &&
      other.partnerId == partnerId &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.status == status &&
      other.idType == idType &&
      other.idLast4 == idLast4 &&
      other.nursingRegNo == nursingRegNo &&
      other.reason == reason &&
      other.checkedBy == checkedBy &&
      other.checkedAt == checkedAt &&
      other.endedAt == endedAt &&
      other.endReason == endReason &&
      other.selfieUrl == selfieUrl;

    @override
    int get hashCode =>
        partnerId.hashCode +
        fullName.hashCode +
        phone.hashCode +
        status.hashCode +
        idType.hashCode +
        idLast4.hashCode +
        nursingRegNo.hashCode +
        reason.hashCode +
        checkedBy.hashCode +
        checkedAt.hashCode +
        (endedAt == null ? 0 : endedAt.hashCode) +
        endReason.hashCode +
        (selfieUrl == null ? 0 : selfieUrl.hashCode);

  factory TemporaryPartnerOut.fromJson(Map<String, dynamic> json) => _$TemporaryPartnerOutFromJson(json);

  Map<String, dynamic> toJson() => _$TemporaryPartnerOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

