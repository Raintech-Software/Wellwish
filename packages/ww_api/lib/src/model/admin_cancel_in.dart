//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_cancel_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminCancelIn {
  /// Returns a new [AdminCancelIn] instance.
  AdminCancelIn({

    required  this.reason,

    required  this.refundPercent,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



      /// Of the booking fee
          // minimum: 0
          // maximum: 100
  @JsonKey(
    
    name: r'refundPercent',
    required: true,
    includeIfNull: false,
  )


  final int refundPercent;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminCancelIn &&
      other.reason == reason &&
      other.refundPercent == refundPercent;

    @override
    int get hashCode =>
        reason.hashCode +
        refundPercent.hashCode;

  factory AdminCancelIn.fromJson(Map<String, dynamic> json) => _$AdminCancelInFromJson(json);

  Map<String, dynamic> toJson() => _$AdminCancelInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

