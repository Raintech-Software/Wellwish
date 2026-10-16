//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackOut {
  /// Returns a new [TrackOut] instance.
  TrackOut({

    required  this.points,

    required  this.km,

    required  this.startedAt,

    required  this.endedAt,
  });

      /// [lat, lng] pairs
  @JsonKey(
    
    name: r'points',
    required: true,
    includeIfNull: false,
  )


  final List<List<num>> points;



  @JsonKey(
    
    name: r'km',
    required: true,
    includeIfNull: false,
  )


  final String km;



  @JsonKey(
    
    name: r'startedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? startedAt;



  @JsonKey(
    
    name: r'endedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? endedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackOut &&
      other.points == points &&
      other.km == km &&
      other.startedAt == startedAt &&
      other.endedAt == endedAt;

    @override
    int get hashCode =>
        points.hashCode +
        km.hashCode +
        (startedAt == null ? 0 : startedAt.hashCode) +
        (endedAt == null ? 0 : endedAt.hashCode);

  factory TrackOut.fromJson(Map<String, dynamic> json) => _$TrackOutFromJson(json);

  Map<String, dynamic> toJson() => _$TrackOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

