//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancel_preview_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancelPreviewOut {
  /// Returns a new [CancelPreviewOut] instance.
  CancelPreviewOut({

    required  this.allowed,

    required  this.paidPaise,

    required  this.refundPercent,

    required  this.refundPaise,
  });

  @JsonKey(
    
    name: r'allowed',
    required: true,
    includeIfNull: false,
  )


  final bool allowed;



  @JsonKey(
    
    name: r'paidPaise',
    required: true,
    includeIfNull: false,
  )


  final int paidPaise;



  @JsonKey(
    
    name: r'refundPercent',
    required: true,
    includeIfNull: false,
  )


  final int refundPercent;



  @JsonKey(
    
    name: r'refundPaise',
    required: true,
    includeIfNull: false,
  )


  final int refundPaise;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancelPreviewOut &&
      other.allowed == allowed &&
      other.paidPaise == paidPaise &&
      other.refundPercent == refundPercent &&
      other.refundPaise == refundPaise;

    @override
    int get hashCode =>
        allowed.hashCode +
        paidPaise.hashCode +
        refundPercent.hashCode +
        refundPaise.hashCode;

  factory CancelPreviewOut.fromJson(Map<String, dynamic> json) => _$CancelPreviewOutFromJson(json);

  Map<String, dynamic> toJson() => _$CancelPreviewOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

