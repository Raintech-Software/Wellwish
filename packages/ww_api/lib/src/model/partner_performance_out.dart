//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/partner_performance_row_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_performance_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerPerformanceOut {
  /// Returns a new [PartnerPerformanceOut] instance.
  PartnerPerformanceOut({

    required  this.start,

    required  this.end,

    required  this.rows,
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
    
    name: r'rows',
    required: true,
    includeIfNull: false,
  )


  final List<PartnerPerformanceRowOut> rows;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerPerformanceOut &&
      other.start == start &&
      other.end == end &&
      other.rows == rows;

    @override
    int get hashCode =>
        start.hashCode +
        end.hashCode +
        rows.hashCode;

  factory PartnerPerformanceOut.fromJson(Map<String, dynamic> json) => _$PartnerPerformanceOutFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerPerformanceOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

