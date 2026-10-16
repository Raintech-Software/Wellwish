//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balance_sum_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BalanceSumOut {
  /// Returns a new [BalanceSumOut] instance.
  BalanceSumOut({

    required  this.cashPaise,

    required  this.upiPaise,
  });

  @JsonKey(
    
    name: r'cashPaise',
    required: true,
    includeIfNull: false,
  )


  final int cashPaise;



  @JsonKey(
    
    name: r'upiPaise',
    required: true,
    includeIfNull: false,
  )


  final int upiPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BalanceSumOut &&
      other.cashPaise == cashPaise &&
      other.upiPaise == upiPaise;

    @override
    int get hashCode =>
        cashPaise.hashCode +
        upiPaise.hashCode;

  factory BalanceSumOut.fromJson(Map<String, dynamic> json) => _$BalanceSumOutFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceSumOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

