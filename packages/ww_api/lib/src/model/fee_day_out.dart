//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fee_day_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FeeDayOut {
  /// Returns a new [FeeDayOut] instance.
  FeeDayOut({

     this.date,

    required  this.payments,

    required  this.collectedPaise,

    required  this.refundedPaise,

    required  this.netPaise,
  });

      /// India date; null on the total row
  @JsonKey(
    
    name: r'date',
    required: false,
    includeIfNull: false,
  )


  final DateTime? date;



  @JsonKey(
    
    name: r'payments',
    required: true,
    includeIfNull: false,
  )


  final int payments;



  @JsonKey(
    
    name: r'collectedPaise',
    required: true,
    includeIfNull: false,
  )


  final int collectedPaise;



  @JsonKey(
    
    name: r'refundedPaise',
    required: true,
    includeIfNull: false,
  )


  final int refundedPaise;



  @JsonKey(
    
    name: r'netPaise',
    required: true,
    includeIfNull: false,
  )


  final int netPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FeeDayOut &&
      other.date == date &&
      other.payments == payments &&
      other.collectedPaise == collectedPaise &&
      other.refundedPaise == refundedPaise &&
      other.netPaise == netPaise;

    @override
    int get hashCode =>
        (date == null ? 0 : date.hashCode) +
        payments.hashCode +
        collectedPaise.hashCode +
        refundedPaise.hashCode +
        netPaise.hashCode;

  factory FeeDayOut.fromJson(Map<String, dynamic> json) => _$FeeDayOutFromJson(json);

  Map<String, dynamic> toJson() => _$FeeDayOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

