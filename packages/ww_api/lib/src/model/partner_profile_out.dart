//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/phone_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_profile_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerProfileOut {
  /// Returns a new [PartnerProfileOut] instance.
  PartnerProfileOut({

    required  this.id,

    required  this.role,

    required  this.status,

    required  this.suspendedReason,

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.photoKey,

     this.photoUrl,

    required  this.email,

    required  this.emailVerified,

    required  this.address,

    required  this.lat,

    required  this.lng,

    required  this.languages,

    required  this.skills,

    required  this.emergencyName,

    required  this.emergencyPhone,

    required  this.availableToday,

    required  this.addedByAdmin,

    required  this.phones,

    required  this.createdAt,

    required  this.approvedAt,

     this.deletionDueAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'suspendedReason',
    required: true,
    includeIfNull: false,
  )


  final String suspendedReason;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'dob',
    required: true,
    includeIfNull: true,
  )


  final DateTime? dob;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'photoKey',
    required: true,
    includeIfNull: false,
  )


  final String photoKey;



      /// Works for 5 minutes
  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'emailVerified',
    required: true,
    includeIfNull: false,
  )


  final bool emailVerified;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    
    name: r'lat',
    required: true,
    includeIfNull: true,
  )


  final String? lat;



  @JsonKey(
    
    name: r'lng',
    required: true,
    includeIfNull: true,
  )


  final String? lng;



  @JsonKey(
    
    name: r'languages',
    required: true,
    includeIfNull: false,
  )


  final List<String> languages;



  @JsonKey(
    
    name: r'skills',
    required: true,
    includeIfNull: false,
  )


  final List<String> skills;



  @JsonKey(
    
    name: r'emergencyName',
    required: true,
    includeIfNull: false,
  )


  final String emergencyName;



  @JsonKey(
    
    name: r'emergencyPhone',
    required: true,
    includeIfNull: false,
  )


  final String emergencyPhone;



  @JsonKey(
    
    name: r'availableToday',
    required: true,
    includeIfNull: false,
  )


  final bool availableToday;



  @JsonKey(
    
    name: r'addedByAdmin',
    required: true,
    includeIfNull: false,
  )


  final bool addedByAdmin;



  @JsonKey(
    
    name: r'phones',
    required: true,
    includeIfNull: false,
  )


  final List<PhoneOut> phones;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'approvedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? approvedAt;



      /// Asked to delete their account: when the personal data is erased (§6.20)
  @JsonKey(
    
    name: r'deletionDueAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? deletionDueAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerProfileOut &&
      other.id == id &&
      other.role == role &&
      other.status == status &&
      other.suspendedReason == suspendedReason &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.photoKey == photoKey &&
      other.photoUrl == photoUrl &&
      other.email == email &&
      other.emailVerified == emailVerified &&
      other.address == address &&
      other.lat == lat &&
      other.lng == lng &&
      other.languages == languages &&
      other.skills == skills &&
      other.emergencyName == emergencyName &&
      other.emergencyPhone == emergencyPhone &&
      other.availableToday == availableToday &&
      other.addedByAdmin == addedByAdmin &&
      other.phones == phones &&
      other.createdAt == createdAt &&
      other.approvedAt == approvedAt &&
      other.deletionDueAt == deletionDueAt;

    @override
    int get hashCode =>
        id.hashCode +
        role.hashCode +
        status.hashCode +
        suspendedReason.hashCode +
        fullName.hashCode +
        (dob == null ? 0 : dob.hashCode) +
        gender.hashCode +
        photoKey.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        email.hashCode +
        emailVerified.hashCode +
        address.hashCode +
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        languages.hashCode +
        skills.hashCode +
        emergencyName.hashCode +
        emergencyPhone.hashCode +
        availableToday.hashCode +
        addedByAdmin.hashCode +
        phones.hashCode +
        createdAt.hashCode +
        (approvedAt == null ? 0 : approvedAt.hashCode) +
        (deletionDueAt == null ? 0 : deletionDueAt.hashCode);

  factory PartnerProfileOut.fromJson(Map<String, dynamic> json) => _$PartnerProfileOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerProfileOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

