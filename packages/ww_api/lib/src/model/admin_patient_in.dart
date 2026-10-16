//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_patient_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminPatientIn {
  /// Returns a new [AdminPatientIn] instance.
  AdminPatientIn({

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.language,

    required  this.reason,
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


  final AdminPatientInGenderEnum gender;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final AdminPatientInLanguageEnum language;



      /// e.g. asked by phone on 13 Oct (logged)
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminPatientIn &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.language == language &&
      other.reason == reason;

    @override
    int get hashCode =>
        fullName.hashCode +
        dob.hashCode +
        gender.hashCode +
        language.hashCode +
        reason.hashCode;

  factory AdminPatientIn.fromJson(Map<String, dynamic> json) => _$AdminPatientInFromJson(json);

  Map<String, dynamic> toJson() => _$AdminPatientInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum AdminPatientInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const AdminPatientInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


enum AdminPatientInLanguageEnum {
@JsonValue(r'en')
en(r'en'),
@JsonValue(r'hi')
hi(r'hi'),
@JsonValue(r'or')
or(r'or');

const AdminPatientInLanguageEnum(this.value);

final String value;

@override
String toString() => value;
}


