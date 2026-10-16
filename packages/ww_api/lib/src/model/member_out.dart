//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class MemberOut {
  /// Returns a new [MemberOut] instance.
  MemberOut({

    required  this.id,

    required  this.relation,

    required  this.isSelf,

    required  this.fullName,

    required  this.dob,

    required  this.age,

    required  this.gender,

    required  this.photoKey,

    required  this.photoUrl,

    required  this.phone,

    required  this.language,

    required  this.conditions,

    required  this.allergies,

    required  this.mobility,

    required  this.sensoryNotes,

    required  this.emergencyName,

    required  this.emergencyPhone,

    required  this.consentAt,

    required  this.addressCount,

    required  this.documentCount,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'relation',
    required: true,
    includeIfNull: false,
  )


  final String relation;



  @JsonKey(
    
    name: r'isSelf',
    required: true,
    includeIfNull: false,
  )


  final bool isSelf;



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
    
    name: r'age',
    required: true,
    includeIfNull: true,
  )


  final int? age;



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



  @JsonKey(
    
    name: r'photoUrl',
    required: true,
    includeIfNull: true,
  )


  final String? photoUrl;



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


  final String mobility;



  @JsonKey(
    
    name: r'sensoryNotes',
    required: true,
    includeIfNull: false,
  )


  final String sensoryNotes;



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
    
    name: r'consentAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? consentAt;



  @JsonKey(
    
    name: r'addressCount',
    required: true,
    includeIfNull: false,
  )


  final int addressCount;



  @JsonKey(
    
    name: r'documentCount',
    required: true,
    includeIfNull: false,
  )


  final int documentCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is MemberOut &&
      other.id == id &&
      other.relation == relation &&
      other.isSelf == isSelf &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.age == age &&
      other.gender == gender &&
      other.photoKey == photoKey &&
      other.photoUrl == photoUrl &&
      other.phone == phone &&
      other.language == language &&
      other.conditions == conditions &&
      other.allergies == allergies &&
      other.mobility == mobility &&
      other.sensoryNotes == sensoryNotes &&
      other.emergencyName == emergencyName &&
      other.emergencyPhone == emergencyPhone &&
      other.consentAt == consentAt &&
      other.addressCount == addressCount &&
      other.documentCount == documentCount;

    @override
    int get hashCode =>
        id.hashCode +
        relation.hashCode +
        isSelf.hashCode +
        fullName.hashCode +
        (dob == null ? 0 : dob.hashCode) +
        (age == null ? 0 : age.hashCode) +
        gender.hashCode +
        photoKey.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        phone.hashCode +
        language.hashCode +
        conditions.hashCode +
        allergies.hashCode +
        mobility.hashCode +
        sensoryNotes.hashCode +
        emergencyName.hashCode +
        emergencyPhone.hashCode +
        (consentAt == null ? 0 : consentAt.hashCode) +
        addressCount.hashCode +
        documentCount.hashCode;

  factory MemberOut.fromJson(Map<String, dynamic> json) => _$MemberOutFromJson(json);

  Map<String, dynamic> toJson() => _$MemberOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

