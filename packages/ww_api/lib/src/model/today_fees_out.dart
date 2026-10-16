//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'today_fees_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TodayFeesOut {
  /// Returns a new [TodayFeesOut] instance.
  TodayFeesOut({

    required  this.payments,

    required  this.collectedPaise,

    required  this.refundedPaise,

    required  this.monthCollectedPaise,

    required  this.monthNetPaise,
  });

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



      /// This month so far
  @JsonKey(
    
    name: r'monthCollectedPaise',
    required: true,
    includeIfNull: false,
  )


  final int monthCollectedPaise;



  @JsonKey(
    
    name: r'monthNetPaise',
    required: true,
    includeIfNull: false,
  )


  final int monthNetPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TodayFeesOut &&
      other.payments == payments &&
      other.collectedPaise == collectedPaise &&
      other.refundedPaise == refundedPaise &&
      other.monthCollectedPaise == monthCollectedPaise &&
      other.monthNetPaise == monthNetPaise;

    @override
    int get hashCode =>
        payments.hashCode +
        collectedPaise.hashCode +
        refundedPaise.hashCode +
        monthCollectedPaise.hashCode +
        monthNetPaise.hashCode;

  factory TodayFeesOut.fromJson(Map<String, dynamic> json) => _$TodayFeesOutFromJson(json);

  Map<String, dynamic> toJson() => _$TodayFeesOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

