//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'speciality_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SpecialityIn {
  /// Returns a new [SpecialityIn] instance.
  SpecialityIn({

    required  this.name,

     this.nameHi = '',

     this.nameOr = '',

     this.icon = '',
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    defaultValue: '',
    name: r'nameHi',
    required: false,
    includeIfNull: false,
  )


  final String? nameHi;



  @JsonKey(
    defaultValue: '',
    name: r'nameOr',
    required: false,
    includeIfNull: false,
  )


  final String? nameOr;



  @JsonKey(
    defaultValue: '',
    name: r'icon',
    required: false,
    includeIfNull: false,
  )


  final String? icon;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SpecialityIn &&
      other.name == name &&
      other.nameHi == nameHi &&
      other.nameOr == nameOr &&
      other.icon == icon;

    @override
    int get hashCode =>
        name.hashCode +
        nameHi.hashCode +
        nameOr.hashCode +
        icon.hashCode;

  factory SpecialityIn.fromJson(Map<String, dynamic> json) => _$SpecialityInFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialityInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

