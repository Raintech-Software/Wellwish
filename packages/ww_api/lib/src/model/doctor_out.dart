//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/speciality_out.dart';
import 'package:ww_api/src/model/hospital_brief.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DoctorOut {
  /// Returns a new [DoctorOut] instance.
  DoctorOut({

    required  this.id,

    required  this.fullName,

    required  this.photoKey,

     this.photoUrl,

    required  this.speciality,

    required  this.qualifications,

    required  this.opdInfo,

    required  this.languages,

    required  this.hospitals,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'photoKey',
    required: true,
    includeIfNull: false,
  )


  final String photoKey;



  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'speciality',
    required: true,
    includeIfNull: false,
  )


  final SpecialityOut speciality;



  @JsonKey(
    
    name: r'qualifications',
    required: true,
    includeIfNull: false,
  )


  final String qualifications;



  @JsonKey(
    
    name: r'opdInfo',
    required: true,
    includeIfNull: false,
  )


  final String opdInfo;



  @JsonKey(
    
    name: r'languages',
    required: true,
    includeIfNull: false,
  )


  final List<String> languages;



  @JsonKey(
    
    name: r'hospitals',
    required: true,
    includeIfNull: false,
  )


  final List<HospitalBrief> hospitals;



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DoctorOut &&
      other.id == id &&
      other.fullName == fullName &&
      other.photoKey == photoKey &&
      other.photoUrl == photoUrl &&
      other.speciality == speciality &&
      other.qualifications == qualifications &&
      other.opdInfo == opdInfo &&
      other.languages == languages &&
      other.hospitals == hospitals &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        id.hashCode +
        fullName.hashCode +
        photoKey.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        speciality.hashCode +
        qualifications.hashCode +
        opdInfo.hashCode +
        languages.hashCode +
        hospitals.hashCode +
        isActive.hashCode;

  factory DoctorOut.fromJson(Map<String, dynamic> json) => _$DoctorOutFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

