//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vitals_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class VitalsIn {
  /// Returns a new [VitalsIn] instance.
  VitalsIn({

     this.bp = '',

     this.pulse,

     this.temperatureF,

     this.spo2,

     this.sugar,
  });

      /// e.g. 120/80
  @JsonKey(
    defaultValue: '',
    name: r'bp',
    required: false,
    includeIfNull: false,
  )


  final String? bp;



          // minimum: 20
          // maximum: 250
  @JsonKey(
    
    name: r'pulse',
    required: false,
    includeIfNull: false,
  )


  final int? pulse;



      /// °F
          // minimum: 90
          // maximum: 110
  @JsonKey(
    
    name: r'temperatureF',
    required: false,
    includeIfNull: false,
  )


  final num? temperatureF;



          // minimum: 50
          // maximum: 100
  @JsonKey(
    
    name: r'spo2',
    required: false,
    includeIfNull: false,
  )


  final int? spo2;



      /// mg/dL
          // minimum: 20
          // maximum: 700
  @JsonKey(
    
    name: r'sugar',
    required: false,
    includeIfNull: false,
  )


  final int? sugar;





    @override
    bool operator ==(Object other) => identical(this, other) || other is VitalsIn &&
      other.bp == bp &&
      other.pulse == pulse &&
      other.temperatureF == temperatureF &&
      other.spo2 == spo2 &&
      other.sugar == sugar;

    @override
    int get hashCode =>
        bp.hashCode +
        (pulse == null ? 0 : pulse.hashCode) +
        (temperatureF == null ? 0 : temperatureF.hashCode) +
        (spo2 == null ? 0 : spo2.hashCode) +
        (sugar == null ? 0 : sugar.hashCode);

  factory VitalsIn.fromJson(Map<String, dynamic> json) => _$VitalsInFromJson(json);

  Map<String, dynamic> toJson() => _$VitalsInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

