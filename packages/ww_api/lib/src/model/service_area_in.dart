//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_area_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceAreaIn {
  /// Returns a new [ServiceAreaIn] instance.
  ServiceAreaIn({

    required  this.city,

    required  this.name,

    required  this.lat,

    required  this.lng,

    required  this.radiusKm,
  });

  @JsonKey(
    
    name: r'city',
    required: true,
    includeIfNull: false,
  )


  final String city;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



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
    
    name: r'radiusKm',
    required: true,
    includeIfNull: false,
  )


  final String radiusKm;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceAreaIn &&
      other.city == city &&
      other.name == name &&
      other.lat == lat &&
      other.lng == lng &&
      other.radiusKm == radiusKm;

    @override
    int get hashCode =>
        city.hashCode +
        name.hashCode +
        lat.hashCode +
        lng.hashCode +
        radiusKm.hashCode;

  factory ServiceAreaIn.fromJson(Map<String, dynamic> json) => _$ServiceAreaInFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAreaInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

