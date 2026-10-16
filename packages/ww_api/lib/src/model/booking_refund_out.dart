//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_refund_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingRefundOut {
  /// Returns a new [BookingRefundOut] instance.
  BookingRefundOut({

    required  this.amountPaise,

    required  this.percent,

    required  this.status,

    required  this.createdAt,

    required  this.processedAt,
  });

  @JsonKey(
    
    name: r'amountPaise',
    required: true,
    includeIfNull: false,
  )


  final int amountPaise;



  @JsonKey(
    
    name: r'percent',
    required: true,
    includeIfNull: false,
  )


  final int percent;



      /// AWAITING_APPROVAL, PENDING, PROCESSED, FAILED, REJECTED
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'processedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? processedAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingRefundOut &&
      other.amountPaise == amountPaise &&
      other.percent == percent &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.processedAt == processedAt;

    @override
    int get hashCode =>
        amountPaise.hashCode +
        percent.hashCode +
        status.hashCode +
        createdAt.hashCode +
        (processedAt == null ? 0 : processedAt.hashCode);

  factory BookingRefundOut.fromJson(Map<String, dynamic> json) => _$BookingRefundOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingRefundOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

