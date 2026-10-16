//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_hospital_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientHospitalOut {
  /// Returns a new [PatientHospitalOut] instance.
  PatientHospitalOut({

    required  this.id,

    required  this.name,

    required  this.type,

    required  this.address,

    required  this.city,

    required  this.lat,

    required  this.lng,

    required  this.phone,

    required  this.opdHours,

     this.photoUrl,

     this.distanceKm,

    required  this.doctorCount,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    
    name: r'city',
    required: true,
    includeIfNull: false,
  )


  final String city;



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
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'opdHours',
    required: true,
    includeIfNull: false,
  )


  final String opdHours;



      /// Works for 5 minutes
  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



      /// None when no location was given
  @JsonKey(
    
    name: r'distanceKm',
    required: false,
    includeIfNull: false,
  )


  final num? distanceKm;



  @JsonKey(
    
    name: r'doctorCount',
    required: true,
    includeIfNull: false,
  )


  final int doctorCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientHospitalOut &&
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.address == address &&
      other.city == city &&
      other.lat == lat &&
      other.lng == lng &&
      other.phone == phone &&
      other.opdHours == opdHours &&
      other.photoUrl == photoUrl &&
      other.distanceKm == distanceKm &&
      other.doctorCount == doctorCount;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        type.hashCode +
        address.hashCode +
        city.hashCode +
        lat.hashCode +
        lng.hashCode +
        phone.hashCode +
        opdHours.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        (distanceKm == null ? 0 : distanceKm.hashCode) +
        doctorCount.hashCode;

  factory PatientHospitalOut.fromJson(Map<String, dynamic> json) => _$PatientHospitalOutFromJson(json);

  Map<String, dynamic> toJson() => _$PatientHospitalOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

