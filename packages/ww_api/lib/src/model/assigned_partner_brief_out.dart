//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assigned_partner_brief_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AssignedPartnerBriefOut {
  /// Returns a new [AssignedPartnerBriefOut] instance.
  AssignedPartnerBriefOut({

    required  this.partnerId,

    required  this.fullName,

    required  this.phone,

    required  this.alternatePhone,

    required  this.photoUrl,
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



  @JsonKey(
    
    name: r'alternatePhone',
    required: true,
    includeIfNull: false,
  )


  final String alternatePhone;



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AssignedPartnerBriefOut &&
      other.partnerId == partnerId &&
      other.fullName == fullName &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone &&
      other.photoUrl == photoUrl;

    @override
    int get hashCode =>
        partnerId.hashCode +
        fullName.hashCode +
        phone.hashCode +
        alternatePhone.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode);

  factory AssignedPartnerBriefOut.fromJson(Map<String, dynamic> json) => _$AssignedPartnerBriefOutFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedPartnerBriefOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

