//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'doctor_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DoctorIn {
  /// Returns a new [DoctorIn] instance.
  DoctorIn({

    required  this.fullName,

    required  this.specialityId,

     this.hospitalIds,

     this.qualifications = '',

     this.opdInfo = '',

     this.languages,

     this.photoKey = '',
  });

  @JsonKey(
    
    name: r'fullName',
    required: true,
    includeIfNull: false,
  )


  final String fullName;



  @JsonKey(
    
    name: r'specialityId',
    required: true,
    includeIfNull: false,
  )


  final String specialityId;



  @JsonKey(
    
    name: r'hospitalIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? hospitalIds;



  @JsonKey(
    defaultValue: '',
    name: r'qualifications',
    required: false,
    includeIfNull: false,
  )


  final String? qualifications;



  @JsonKey(
    defaultValue: '',
    name: r'opdInfo',
    required: false,
    includeIfNull: false,
  )


  final String? opdInfo;



  @JsonKey(
    
    name: r'languages',
    required: false,
    includeIfNull: false,
  )


  final List<String>? languages;



  @JsonKey(
    defaultValue: '',
    name: r'photoKey',
    required: false,
    includeIfNull: false,
  )


  final String? photoKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DoctorIn &&
      other.fullName == fullName &&
      other.specialityId == specialityId &&
      other.hospitalIds == hospitalIds &&
      other.qualifications == qualifications &&
      other.opdInfo == opdInfo &&
      other.languages == languages &&
      other.photoKey == photoKey;

    @override
    int get hashCode =>
        fullName.hashCode +
        specialityId.hashCode +
        hospitalIds.hashCode +
        qualifications.hashCode +
        opdInfo.hashCode +
        languages.hashCode +
        photoKey.hashCode;

  factory DoctorIn.fromJson(Map<String, dynamic> json) => _$DoctorInFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

