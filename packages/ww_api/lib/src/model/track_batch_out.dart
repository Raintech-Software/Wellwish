//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_batch_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackBatchOut {
  /// Returns a new [TrackBatchOut] instance.
  TrackBatchOut({

    required  this.accepted,
  });

      /// Points used (the others were inaccurate, fake or impossible)
  @JsonKey(
    
    name: r'accepted',
    required: true,
    includeIfNull: false,
  )


  final int accepted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackBatchOut &&
      other.accepted == accepted;

    @override
    int get hashCode =>
        accepted.hashCode;

  factory TrackBatchOut.fromJson(Map<String, dynamic> json) => _$TrackBatchOutFromJson(json);

  Map<String, dynamic> toJson() => _$TrackBatchOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

