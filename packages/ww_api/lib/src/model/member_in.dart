//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MemberIn {
  /// Returns a new [MemberIn] instance.
  MemberIn({

    required  this.relation,

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.photoKey,

    required  this.phone,

    required  this.language,

    required  this.conditions,

    required  this.allergies,

    required  this.mobility,

    required  this.sensoryNotes,

    required  this.emergencyName,

    required  this.emergencyPhone,

    required  this.consent,
  });

  @JsonKey(
    
    name: r'relation',
    required: true,
    includeIfNull: false,
  )


  final MemberInRelationEnum relation;



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


  final MemberInGenderEnum gender;



      /// from photo-upload-url, or empty
  @JsonKey(
    
    name: r'photoKey',
    required: true,
    includeIfNull: false,
  )


  final String photoKey;



      /// their own mobile (optional)
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


  final MemberInLanguageEnum language;



      /// e.g. diabetes, BP
  @JsonKey(
    
    name: r'conditions',
    required: true,
    includeIfNull: false,
  )


  final String conditions;



  @JsonKey(
    
    name: r'allergies',
    required: true,
    includeIfNull: false,
  )


  final String allergies;



  @JsonKey(
    
    name: r'mobility',
    required: true,
    includeIfNull: false,
  )


  final MemberInMobilityEnum mobility;



      /// hearing or vision problems
  @JsonKey(
    
    name: r'sensoryNotes',
    required: true,
    includeIfNull: false,
  )


  final String sensoryNotes;



      /// empty = the account owner
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



      /// 'I have their permission…' (required for everyone but yourself)
  @JsonKey(
    
    name: r'consent',
    required: true,
    includeIfNull: false,
  )


  final bool consent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MemberIn &&
      other.relation == relation &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.photoKey == photoKey &&
      other.phone == phone &&
      other.language == language &&
      other.conditions == conditions &&
      other.allergies == allergies &&
      other.mobility == mobility &&
      other.sensoryNotes == sensoryNotes &&
      other.emergencyName == emergencyName &&
      other.emergencyPhone == emergencyPhone &&
      other.consent == consent;

    @override
    int get hashCode =>
        relation.hashCode +
        fullName.hashCode +
        dob.hashCode +
        gender.hashCode +
        photoKey.hashCode +
        phone.hashCode +
        language.hashCode +
        conditions.hashCode +
        allergies.hashCode +
        mobility.hashCode +
        sensoryNotes.hashCode +
        emergencyName.hashCode +
        emergencyPhone.hashCode +
        consent.hashCode;

  factory MemberIn.fromJson(Map<String, dynamic> json) => _$MemberInFromJson(json);

  Map<String, dynamic> toJson() => _$MemberInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum MemberInRelationEnum {
@JsonValue(r'SELF')
SELF(r'SELF'),
@JsonValue(r'MOTHER')
MOTHER(r'MOTHER'),
@JsonValue(r'FATHER')
FATHER(r'FATHER'),
@JsonValue(r'GRANDMOTHER')
GRANDMOTHER(r'GRANDMOTHER'),
@JsonValue(r'GRANDFATHER')
GRANDFATHER(r'GRANDFATHER'),
@JsonValue(r'SPOUSE')
SPOUSE(r'SPOUSE'),
@JsonValue(r'CHILD')
CHILD(r'CHILD'),
@JsonValue(r'SIBLING')
SIBLING(r'SIBLING'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const MemberInRelationEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MemberInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const MemberInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MemberInLanguageEnum {
@JsonValue(r'')
empty(r''),
@JsonValue(r'Odia')
odia(r'Odia'),
@JsonValue(r'Hindi')
hindi(r'Hindi'),
@JsonValue(r'English')
english(r'English'),
@JsonValue(r'Bengali')
bengali(r'Bengali'),
@JsonValue(r'Telugu')
telugu(r'Telugu');

const MemberInLanguageEnum(this.value);

final String value;

@override
String toString() => value;
}


enum MemberInMobilityEnum {
@JsonValue(r'')
empty(r''),
@JsonValue(r'WALKS_ALONE')
WALKS_ALONE(r'WALKS_ALONE'),
@JsonValue(r'NEEDS_SUPPORT')
NEEDS_SUPPORT(r'NEEDS_SUPPORT'),
@JsonValue(r'WHEELCHAIR')
WHEELCHAIR(r'WHEELCHAIR');

const MemberInMobilityEnum(this.value);

final String value;

@override
String toString() => value;
}


