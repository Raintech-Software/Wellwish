//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'queue_counts_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class QueueCountsOut {
  /// Returns a new [QueueCountsOut] instance.
  QueueCountsOut({

    required  this.today,

    required  this.tomorrow,

    required  this.later,
  });

  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final int today;



  @JsonKey(
    
    name: r'tomorrow',
    required: true,
    includeIfNull: false,
  )


  final int tomorrow;



  @JsonKey(
    
    name: r'later',
    required: true,
    includeIfNull: false,
  )


  final int later;





    @override
    bool operator ==(Object other) => identical(this, other) || other is QueueCountsOut &&
      other.today == today &&
      other.tomorrow == tomorrow &&
      other.later == later;

    @override
    int get hashCode =>
        today.hashCode +
        tomorrow.hashCode +
        later.hashCode;

  factory QueueCountsOut.fromJson(Map<String, dynamic> json) => _$QueueCountsOutFromJson(json);

  Map<String, dynamic> toJson() => _$QueueCountsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

