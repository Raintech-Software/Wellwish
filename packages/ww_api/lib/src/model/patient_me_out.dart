//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/consent_needed_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_me_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientMeOut {
  /// Returns a new [PatientMeOut] instance.
  PatientMeOut({

    required  this.id,

    required  this.phone,

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.language,

    required  this.selfMemberId,

    required  this.profileComplete,

    required  this.consentsNeeded,

    required  this.googleLinked,
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
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final String language;



  @JsonKey(
    
    name: r'selfMemberId',
    required: true,
    includeIfNull: false,
  )


  final String selfMemberId;



      /// false → show profile setup (P04)
  @JsonKey(
    
    name: r'profileComplete',
    required: true,
    includeIfNull: false,
  )


  final bool profileComplete;



      /// not empty → show the consent screen
  @JsonKey(
    
    name: r'consentsNeeded',
    required: true,
    includeIfNull: false,
  )


  final List<ConsentNeededOut> consentsNeeded;



  @JsonKey(
    
    name: r'googleLinked',
    required: true,
    includeIfNull: false,
  )


  final bool googleLinked;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientMeOut &&
      other.id == id &&
      other.phone == phone &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.language == language &&
      other.selfMemberId == selfMemberId &&
      other.profileComplete == profileComplete &&
      other.consentsNeeded == consentsNeeded &&
      other.googleLinked == googleLinked;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        fullName.hashCode +
        (dob == null ? 0 : dob.hashCode) +
        gender.hashCode +
        language.hashCode +
        selfMemberId.hashCode +
        profileComplete.hashCode +
        consentsNeeded.hashCode +
        googleLinked.hashCode;

  factory PatientMeOut.fromJson(Map<String, dynamic> json) => _$PatientMeOutFromJson(json);

  Map<String, dynamic> toJson() => _$PatientMeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

