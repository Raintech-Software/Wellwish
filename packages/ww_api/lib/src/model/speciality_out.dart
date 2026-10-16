//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speciality_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SpecialityOut {
  /// Returns a new [SpecialityOut] instance.
  SpecialityOut({

    required  this.id,

    required  this.name,

    required  this.nameHi,

    required  this.nameOr,

    required  this.icon,

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
    
    name: r'nameHi',
    required: true,
    includeIfNull: false,
  )


  final String nameHi;



  @JsonKey(
    
    name: r'nameOr',
    required: true,
    includeIfNull: false,
  )


  final String nameOr;



  @JsonKey(
    
    name: r'icon',
    required: true,
    includeIfNull: false,
  )


  final String icon;



  @JsonKey(
    defaultValue: 0,
    name: r'doctorCount',
    required: false,
    includeIfNull: false,
  )


  final int? doctorCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SpecialityOut &&
      other.id == id &&
      other.name == name &&
      other.nameHi == nameHi &&
      other.nameOr == nameOr &&
      other.icon == icon &&
      other.doctorCount == doctorCount;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        nameHi.hashCode +
        nameOr.hashCode +
        icon.hashCode +
        doctorCount.hashCode;

  factory SpecialityOut.fromJson(Map<String, dynamic> json) => _$SpecialityOutFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialityOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

