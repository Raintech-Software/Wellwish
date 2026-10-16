//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_area_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ServiceAreaOut {
  /// Returns a new [ServiceAreaOut] instance.
  ServiceAreaOut({

    required  this.id,

    required  this.city,

    required  this.name,

    required  this.lat,

    required  this.lng,

    required  this.radiusKm,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ServiceAreaOut &&
      other.id == id &&
      other.city == city &&
      other.name == name &&
      other.lat == lat &&
      other.lng == lng &&
      other.radiusKm == radiusKm &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        id.hashCode +
        city.hashCode +
        name.hashCode +
        lat.hashCode +
        lng.hashCode +
        radiusKm.hashCode +
        isActive.hashCode;

  factory ServiceAreaOut.fromJson(Map<String, dynamic> json) => _$ServiceAreaOutFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAreaOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

