//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/fee_day_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fee_report_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FeeReportOut {
  /// Returns a new [FeeReportOut] instance.
  FeeReportOut({

    required  this.start,

    required  this.end,

    required  this.days,

    required  this.total,
  });

  @JsonKey(
    
    name: r'start',
    required: true,
    includeIfNull: false,
  )


  final DateTime start;



  @JsonKey(
    
    name: r'end',
    required: true,
    includeIfNull: false,
  )


  final DateTime end;



  @JsonKey(
    
    name: r'days',
    required: true,
    includeIfNull: false,
  )


  final List<FeeDayOut> days;



  @JsonKey(
    
    name: r'total',
    required: true,
    includeIfNull: false,
  )


  final FeeDayOut total;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FeeReportOut &&
      other.start == start &&
      other.end == end &&
      other.days == days &&
      other.total == total;

    @override
    int get hashCode =>
        start.hashCode +
        end.hashCode +
        days.hashCode +
        total.hashCode;

  factory FeeReportOut.fromJson(Map<String, dynamic> json) => _$FeeReportOutFromJson(json);

  Map<String, dynamic> toJson() => _$FeeReportOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

