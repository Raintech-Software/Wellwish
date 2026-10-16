//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hospital_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HospitalOut {
  /// Returns a new [HospitalOut] instance.
  HospitalOut({

    required  this.id,

    required  this.name,

    required  this.type,

    required  this.address,

    required  this.city,

    required  this.lat,

    required  this.lng,

    required  this.phone,

    required  this.opdHours,

    required  this.departments,

    required  this.photoKey,

     this.photoUrl,

    required  this.isActive,

     this.doctorCount = 0,
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



  @JsonKey(
    
    name: r'departments',
    required: true,
    includeIfNull: false,
  )


  final List<String> departments;



  @JsonKey(
    
    name: r'photoKey',
    required: true,
    includeIfNull: false,
  )


  final String photoKey;



      /// Works for 5 minutes
  @JsonKey(
    
    name: r'photoUrl',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;



  @JsonKey(
    defaultValue: 0,
    name: r'doctorCount',
    required: false,
    includeIfNull: false,
  )


  final int? doctorCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HospitalOut &&
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.address == address &&
      other.city == city &&
      other.lat == lat &&
      other.lng == lng &&
      other.phone == phone &&
      other.opdHours == opdHours &&
      other.departments == departments &&
      other.photoKey == photoKey &&
      other.photoUrl == photoUrl &&
      other.isActive == isActive &&
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
        departments.hashCode +
        photoKey.hashCode +
        (photoUrl == null ? 0 : photoUrl.hashCode) +
        isActive.hashCode +
        doctorCount.hashCode;

  factory HospitalOut.fromJson(Map<String, dynamic> json) => _$HospitalOutFromJson(json);

  Map<String, dynamic> toJson() => _$HospitalOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

