//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/document_in.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_partner_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddPartnerIn {
  /// Returns a new [AddPartnerIn] instance.
  AddPartnerIn({

    required  this.role,

    required  this.phone,

    required  this.alternatePhone,

    required  this.email,

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.photoKey,

    required  this.address,

    required  this.lat,

    required  this.lng,

    required  this.languages,

     this.skills,

    required  this.emergencyName,

    required  this.emergencyPhone,

    required  this.documents,

    required  this.checked,
  });

  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final AddPartnerInRoleEnum role;



      /// Login number (primary)
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
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'dob',
    required: true,
    includeIfNull: false,
  )


  final DateTime dob;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final AddPartnerInGenderEnum gender;



  @JsonKey(
    
    name: r'photoKey',
    required: true,
    includeIfNull: false,
  )


  final String photoKey;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    
    name: r'lat',
    required: true,
    includeIfNull: false,
  )


  final String lat;



  @JsonKey(
    
    name: r'lng',
    required: true,
    includeIfNull: false,
  )


  final String lng;



  @JsonKey(
    
    name: r'languages',
    required: true,
    includeIfNull: false,
  )


  final List<String> languages;



  @JsonKey(
    
    name: r'skills',
    required: false,
    includeIfNull: false,
  )


  final List<String>? skills;



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
    
    name: r'documents',
    required: true,
    includeIfNull: false,
  )


  final List<DocumentIn> documents;



      /// The admin confirms every document was checked
  @JsonKey(
    
    name: r'checked',
    required: true,
    includeIfNull: false,
  )


  final bool checked;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddPartnerIn &&
      other.role == role &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone &&
      other.email == email &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.photoKey == photoKey &&
      other.address == address &&
      other.lat == lat &&
      other.lng == lng &&
      other.languages == languages &&
      other.skills == skills &&
      other.emergencyName == emergencyName &&
      other.emergencyPhone == emergencyPhone &&
      other.documents == documents &&
      other.checked == checked;

    @override
    int get hashCode =>
        role.hashCode +
        phone.hashCode +
        alternatePhone.hashCode +
        email.hashCode +
        fullName.hashCode +
        dob.hashCode +
        gender.hashCode +
        photoKey.hashCode +
        address.hashCode +
        lat.hashCode +
        lng.hashCode +
        languages.hashCode +
        skills.hashCode +
        emergencyName.hashCode +
        emergencyPhone.hashCode +
        documents.hashCode +
        checked.hashCode;

  factory AddPartnerIn.fromJson(Map<String, dynamic> json) => _$AddPartnerInFromJson(json);

  Map<String, dynamic> toJson() => _$AddPartnerInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AddPartnerInRoleEnum {
@JsonValue(r'COMPANION')
COMPANION(r'COMPANION'),
@JsonValue(r'NURSE')
NURSE(r'NURSE');

const AddPartnerInRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AddPartnerInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const AddPartnerInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


