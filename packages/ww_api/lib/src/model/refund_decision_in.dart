//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refund_decision_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RefundDecisionIn {
  /// Returns a new [RefundDecisionIn] instance.
  RefundDecisionIn({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RefundDecisionIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory RefundDecisionIn.fromJson(Map<String, dynamic> json) => _$RefundDecisionInFromJson(json);

  Map<String, dynamic> toJson() => _$RefundDecisionInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

