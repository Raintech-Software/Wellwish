//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_point_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackPointIn {
  /// Returns a new [TrackPointIn] instance.
  TrackPointIn({

    required  this.lat,

    required  this.lng,

    required  this.accuracy,

     this.mock = false,

    required  this.at,
  });

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



      /// Metres
          // minimum: 0
          // maximum: 100000
  @JsonKey(
    
    name: r'accuracy',
    required: true,
    includeIfNull: false,
  )


  final num accuracy;



      /// Android said it is a fake (mock) location
  @JsonKey(
    defaultValue: false,
    name: r'mock',
    required: false,
    includeIfNull: false,
  )


  final bool? mock;



      /// The phone's time (kept between the job's start and now)
  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackPointIn &&
      other.lat == lat &&
      other.lng == lng &&
      other.accuracy == accuracy &&
      other.mock == mock &&
      other.at == at;

    @override
    int get hashCode =>
        lat.hashCode +
        lng.hashCode +
        accuracy.hashCode +
        mock.hashCode +
        at.hashCode;

  factory TrackPointIn.fromJson(Map<String, dynamic> json) => _$TrackPointInFromJson(json);

  Map<String, dynamic> toJson() => _$TrackPointInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

