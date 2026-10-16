//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/patient_hospital_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nearby_hospitals_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class NearbyHospitalsOut {
  /// Returns a new [NearbyHospitalsOut] instance.
  NearbyHospitalsOut({

     this.radiusKm,

    required  this.items,
  });

      /// The radius searched (10 km, or 25 km if fewer than 5 were found)
  @JsonKey(
    
    name: r'radiusKm',
    required: false,
    includeIfNull: false,
  )


  final num? radiusKm;



  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<PatientHospitalOut> items;





    @override
    bool operator ==(Object other) => identical(this, other) || other is NearbyHospitalsOut &&
      other.radiusKm == radiusKm &&
      other.items == items;

    @override
    int get hashCode =>
        (radiusKm == null ? 0 : radiusKm.hashCode) +
        items.hashCode;

  factory NearbyHospitalsOut.fromJson(Map<String, dynamic> json) => _$NearbyHospitalsOutFromJson(json);

  Map<String, dynamic> toJson() => _$NearbyHospitalsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

