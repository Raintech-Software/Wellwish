//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_member_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobMemberOut {
  /// Returns a new [JobMemberOut] instance.
  JobMemberOut({

    required  this.fullName,

    required  this.relation,

    required  this.gender,

    required  this.age,

    required  this.language,

    required  this.phone,

    required  this.photoUrl,

    required  this.mobility,

    required  this.conditions,

    required  this.allergies,

    required  this.sensoryNotes,
  });

  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'relation',
    required: true,
    includeIfNull: false,
  )


  final String relation;



  @JsonKey(
    
    name: r'gender',
    required: true,
    includeIfNull: false,
  )


  final String gender;



  @JsonKey(
    
    name: r'age',
    required: true,
    includeIfNull: true,
  )


  final int? age;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'mobility',
    required: true,
    includeIfNull: false,
  )


  final String mobility;



      /// Health notes: only the assigned partner sees them
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
    
    name: r'sensoryNotes',
    required: true,
    includeIfNull: false,
  )


  final String sensoryNotes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobMemberOut &&
      other.fullName == fullName &&
      other.relation == relation &&
      other.gender == gender &&
      other.age == age &&
      other.language == language &&
      other.phone == phone &&
      other.photoUrl == photoUrl &&
      other.mobility == mobility &&
      other.conditions == conditions &&
      other.allergies == allergies &&
      other.sensoryNotes == sensoryNotes;

    @override
    int get hashCode =>
        fullName.hashCode +
        relation.hashCode +
        gender.hashCode +
        (age == null ? 0 : age.hashCode) +
        language.hashCode +
        phone.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        mobility.hashCode +
        conditions.hashCode +
        allergies.hashCode +
        sensoryNotes.hashCode;

  factory JobMemberOut.fromJson(Map<String, dynamic> json) => _$JobMemberOutFromJson(json);

  Map<String, dynamic> toJson() => _$JobMemberOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

