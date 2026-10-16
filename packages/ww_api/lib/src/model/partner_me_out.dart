//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/consent_needed_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_me_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerMeOut {
  /// Returns a new [PartnerMeOut] instance.
  PartnerMeOut({

    required  this.id,

    required  this.phone,

    required  this.language,

     this.partnerStatus,

     this.role,

     this.temporaryBookingId,

     this.selfieToday = false,

     this.consentsNeeded,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



      /// null until the partner registers (Phase 3)
  @JsonKey(
    
    name: r'partnerStatus',
    required: false,
    includeIfNull: false,
  )


  final String? partnerStatus;



  @JsonKey(
    
    name: r'role',
    required: false,
    includeIfNull: false,
  )


  final String? role;



      /// §6.19: a TEMPORARY partner's one booking (the app opens only this job)
  @JsonKey(
    
    name: r'temporaryBookingId',
    required: false,
    includeIfNull: false,
  )


  final String? temporaryBookingId;



      /// Today's selfie is taken (India date): a TEMPORARY partner's app asks first
  @JsonKey(
    defaultValue: false,
    name: r'selfieToday',
    required: false,
    includeIfNull: false,
  )


  final bool? selfieToday;



      /// Partner Terms and Privacy Policy not accepted in their current version (§6.20): the app shows the consent screen first
  @JsonKey(
    
    name: r'consentsNeeded',
    required: false,
    includeIfNull: false,
  )


  final List<ConsentNeededOut>? consentsNeeded;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerMeOut &&
      other.id == id &&
      other.phone == phone &&
      other.language == language &&
      other.partnerStatus == partnerStatus &&
      other.role == role &&
      other.temporaryBookingId == temporaryBookingId &&
      other.selfieToday == selfieToday &&
      other.consentsNeeded == consentsNeeded;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        language.hashCode +
        (partnerStatus == null ? 0 : partnerStatus.hashCode) +
        (role == null ? 0 : role.hashCode) +
        (temporaryBookingId == null ? 0 : temporaryBookingId.hashCode) +
        selfieToday.hashCode +
        consentsNeeded.hashCode;

  factory PartnerMeOut.fromJson(Map<String, dynamic> json) => _$PartnerMeOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerMeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

