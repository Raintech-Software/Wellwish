//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_refund_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminRefundOut {
  /// Returns a new [AdminRefundOut] instance.
  AdminRefundOut({

    required  this.id,

    required  this.bookingId,

    required  this.bookingCode,

    required  this.amountPaise,

    required  this.percent,

    required  this.reason,

    required  this.status,

    required  this.razorpayRefundId,

    required  this.requestedByType,

    required  this.requestedByName,

    required  this.approvedByName,

    required  this.createdAt,

    required  this.decidedAt,

    required  this.processedAt,

    required  this.failureReason,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



  @JsonKey(
    
    name: r'bookingCode',
    required: true,
    includeIfNull: false,
  )


  final String bookingCode;



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



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'razorpayRefundId',
    required: true,
    includeIfNull: false,
  )


  final String razorpayRefundId;



  @JsonKey(
    
    name: r'requestedByType',
    required: true,
    includeIfNull: false,
  )


  final String requestedByType;



  @JsonKey(
    
    name: r'requestedByName',
    required: true,
    includeIfNull: false,
  )


  final String requestedByName;



  @JsonKey(
    
    name: r'approvedByName',
    required: true,
    includeIfNull: false,
  )


  final String approvedByName;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'decidedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? decidedAt;



  @JsonKey(
    
    name: r'processedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? processedAt;



  @JsonKey(
    
    name: r'failureReason',
    required: true,
    includeIfNull: false,
  )


  final String failureReason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminRefundOut &&
      other.id == id &&
      other.bookingId == bookingId &&
      other.bookingCode == bookingCode &&
      other.amountPaise == amountPaise &&
      other.percent == percent &&
      other.reason == reason &&
      other.status == status &&
      other.razorpayRefundId == razorpayRefundId &&
      other.requestedByType == requestedByType &&
      other.requestedByName == requestedByName &&
      other.approvedByName == approvedByName &&
      other.createdAt == createdAt &&
      other.decidedAt == decidedAt &&
      other.processedAt == processedAt &&
      other.failureReason == failureReason;

    @override
    int get hashCode =>
        id.hashCode +
        bookingId.hashCode +
        bookingCode.hashCode +
        amountPaise.hashCode +
        percent.hashCode +
        reason.hashCode +
        status.hashCode +
        razorpayRefundId.hashCode +
        requestedByType.hashCode +
        requestedByName.hashCode +
        approvedByName.hashCode +
        createdAt.hashCode +
        (decidedAt == null ? 0 : decidedAt.hashCode) +
        (processedAt == null ? 0 : processedAt.hashCode) +
        failureReason.hashCode;

  factory AdminRefundOut.fromJson(Map<String, dynamic> json) => _$AdminRefundOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminRefundOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

