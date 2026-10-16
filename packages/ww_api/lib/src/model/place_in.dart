//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PlaceIn {
  /// Returns a new [PlaceIn] instance.
  PlaceIn({

     this.lat,

     this.lng,

     this.accuracy,

     this.clientTs,

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



      /// Metres
          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'accuracy',
    required: false,
    includeIfNull: false,
  )


  final num? accuracy;



      /// When it was tapped on the phone
  @JsonKey(
    
    name: r'clientTs',
    required: false,
    includeIfNull: false,
  )


  final DateTime? clientTs;



      /// Android said it is a fake (mock) location: not kept, admin told
  @JsonKey(
    defaultValue: false,
    name: r'mock',
    required: false,
    includeIfNull: false,
  )


  final bool? mock;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PlaceIn &&
      other.lat == lat &&
      other.lng == lng &&
      other.accuracy == accuracy &&
      other.clientTs == clientTs &&
      other.mock == mock;

    @override
    int get hashCode =>
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        (accuracy == null ? 0 : accuracy.hashCode) +
        (clientTs == null ? 0 : clientTs.hashCode) +
        mock.hashCode;

  factory PlaceIn.fromJson(Map<String, dynamic> json) => _$PlaceInFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

