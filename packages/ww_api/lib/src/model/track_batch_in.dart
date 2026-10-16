//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/track_point_in.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_batch_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackBatchIn {
  /// Returns a new [TrackBatchIn] instance.
  TrackBatchIn({

    required  this.points,
  });

  @JsonKey(
    
    name: r'points',
    required: true,
    includeIfNull: false,
  )


  final List<TrackPointIn> points;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackBatchIn &&
      other.points == points;

    @override
    int get hashCode =>
        points.hashCode;

  factory TrackBatchIn.fromJson(Map<String, dynamic> json) => _$TrackBatchInFromJson(json);

  Map<String, dynamic> toJson() => _$TrackBatchInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

