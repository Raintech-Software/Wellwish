//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sos_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SosIn {
  /// Returns a new [SosIn] instance.
  SosIn({

     this.lat,

     this.lng,

     this.mock = false,
  });

  @JsonKey(
    
    name: r'lat',
    required: false,
    includeIfNull: false,
  )


  final String? lat;



  @JsonKey(
    
    name: r'lng',
    required: false,
    includeIfNull: false,
  )


  final String? lng;



      /// Android said the position is fake: the SOS still goes, flagged
  @JsonKey(
    defaultValue: false,
    name: r'mock',
    required: false,
    includeIfNull: false,
  )


  final bool? mock;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SosIn &&
      other.lat == lat &&
      other.lng == lng &&
      other.mock == mock;

    @override
    int get hashCode =>
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        mock.hashCode;

  factory SosIn.fromJson(Map<String, dynamic> json) => _$SosInFromJson(json);

  Map<String, dynamic> toJson() => _$SosInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

