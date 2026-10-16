//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_counts_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class JobCountsOut {
  /// Returns a new [JobCountsOut] instance.
  JobCountsOut({

    required  this.today,

    required  this.thisWeek,

    required  this.thisMonth,

    required  this.allTime,
  });

  @JsonKey(
    
    name: r'today',
    required: true,
    includeIfNull: false,
  )


  final int today;



  @JsonKey(
    
    name: r'thisWeek',
    required: true,
    includeIfNull: false,
  )


  final int thisWeek;



  @JsonKey(
    
    name: r'thisMonth',
    required: true,
    includeIfNull: false,
  )


  final int thisMonth;



  @JsonKey(
    
    name: r'allTime',
    required: true,
    includeIfNull: false,
  )


  final int allTime;





    @override
    bool operator ==(Object other) => identical(this, other) || other is JobCountsOut &&
      other.today == today &&
      other.thisWeek == thisWeek &&
      other.thisMonth == thisMonth &&
      other.allTime == allTime;

    @override
    int get hashCode =>
        today.hashCode +
        thisWeek.hashCode +
        thisMonth.hashCode +
        allTime.hashCode;

  factory JobCountsOut.fromJson(Map<String, dynamic> json) => _$JobCountsOutFromJson(json);

  Map<String, dynamic> toJson() => _$JobCountsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

