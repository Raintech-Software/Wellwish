//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ProfileIn {
  /// Returns a new [ProfileIn] instance.
  ProfileIn({

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
  });

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


  final ProfileInGenderEnum gender;



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





    @override
    bool operator ==(Object other) => identical(this, other) || other is ProfileIn &&
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
      other.emergencyPhone == emergencyPhone;

    @override
    int get hashCode =>
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
        emergencyPhone.hashCode;

  factory ProfileIn.fromJson(Map<String, dynamic> json) => _$ProfileInFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ProfileInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const ProfileInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


