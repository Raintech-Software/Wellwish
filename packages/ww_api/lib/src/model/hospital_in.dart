//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hospital_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HospitalIn {
  /// Returns a new [HospitalIn] instance.
  HospitalIn({

    required  this.name,

    required  this.type,

    required  this.address,

     this.city = '',

    required  this.lat,

    required  this.lng,

     this.phone = '',

     this.opdHours = '',

     this.departments,

     this.photoKey = '',
  });

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


  final HospitalInTypeEnum type;



  @JsonKey(
    
    name: r'address',
    required: true,
    includeIfNull: false,
  )


  final String address;



  @JsonKey(
    defaultValue: '',
    name: r'city',
    required: false,
    includeIfNull: false,
  )


  final String? city;



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
    defaultValue: '',
    name: r'phone',
    required: false,
    includeIfNull: false,
  )


  final String? phone;



  @JsonKey(
    defaultValue: '',
    name: r'opdHours',
    required: false,
    includeIfNull: false,
  )


  final String? opdHours;



  @JsonKey(
    
    name: r'departments',
    required: false,
    includeIfNull: false,
  )


  final List<String>? departments;



  @JsonKey(
    defaultValue: '',
    name: r'photoKey',
    required: false,
    includeIfNull: false,
  )


  final String? photoKey;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HospitalIn &&
      other.name == name &&
      other.type == type &&
      other.address == address &&
      other.city == city &&
      other.lat == lat &&
      other.lng == lng &&
      other.phone == phone &&
      other.opdHours == opdHours &&
      other.departments == departments &&
      other.photoKey == photoKey;

    @override
    int get hashCode =>
        name.hashCode +
        type.hashCode +
        address.hashCode +
        city.hashCode +
        lat.hashCode +
        lng.hashCode +
        phone.hashCode +
        opdHours.hashCode +
        departments.hashCode +
        photoKey.hashCode;

  factory HospitalIn.fromJson(Map<String, dynamic> json) => _$HospitalInFromJson(json);

  Map<String, dynamic> toJson() => _$HospitalInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum HospitalInTypeEnum {
@JsonValue(r'HOSPITAL')
HOSPITAL(r'HOSPITAL'),
@JsonValue(r'CLINIC')
CLINIC(r'CLINIC'),
@JsonValue(r'DIAGNOSTIC')
DIAGNOSTIC(r'DIAGNOSTIC');

const HospitalInTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


