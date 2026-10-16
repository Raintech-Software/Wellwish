//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/cancellation_row_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancellations_report_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancellationsReportOut {
  /// Returns a new [CancellationsReportOut] instance.
  CancellationsReportOut({

    required  this.start,

    required  this.end,

    required  this.rows,

    required  this.cancelled,

    required  this.refundedPaise,
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


  final List<CancellationRowOut> rows;



  @JsonKey(
    
    name: r'cancelled',
    required: true,
    includeIfNull: false,
  )


  final int cancelled;



  @JsonKey(
    
    name: r'refundedPaise',
    required: true,
    includeIfNull: false,
  )


  final int refundedPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancellationsReportOut &&
      other.start == start &&
      other.end == end &&
      other.rows == rows &&
      other.cancelled == cancelled &&
      other.refundedPaise == refundedPaise;

    @override
    int get hashCode =>
        start.hashCode +
        end.hashCode +
        rows.hashCode +
        cancelled.hashCode +
        refundedPaise.hashCode;

  factory CancellationsReportOut.fromJson(Map<String, dynamic> json) => _$CancellationsReportOutFromJson(json);

  Map<String, dynamic> toJson() => _$CancellationsReportOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

