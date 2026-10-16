//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_me_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientMeIn {
  /// Returns a new [PatientMeIn] instance.
  PatientMeIn({

    required  this.fullName,

    required  this.dob,

    required  this.gender,

    required  this.language,
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


  final PatientMeInGenderEnum gender;



  @JsonKey(
    
    name: r'language',
    required: true,
    includeIfNull: false,
  )


  final PatientMeInLanguageEnum language;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientMeIn &&
      other.fullName == fullName &&
      other.dob == dob &&
      other.gender == gender &&
      other.language == language;

    @override
    int get hashCode =>
        fullName.hashCode +
        dob.hashCode +
        gender.hashCode +
        language.hashCode;

  factory PatientMeIn.fromJson(Map<String, dynamic> json) => _$PatientMeInFromJson(json);

  Map<String, dynamic> toJson() => _$PatientMeInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PatientMeInGenderEnum {
@JsonValue(r'FEMALE')
FEMALE(r'FEMALE'),
@JsonValue(r'MALE')
MALE(r'MALE'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const PatientMeInGenderEnum(this.value);

final String value;

@override
String toString() => value;
}


enum PatientMeInLanguageEnum {
@JsonValue(r'en')
en(r'en'),
@JsonValue(r'hi')
hi(r'hi'),
@JsonValue(r'or')
or(r'or');

const PatientMeInLanguageEnum(this.value);

final String value;

@override
String toString() => value;
}


