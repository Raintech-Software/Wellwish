//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_payment_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminPaymentOut {
  /// Returns a new [AdminPaymentOut] instance.
  AdminPaymentOut({

    required  this.id,

    required  this.bookingId,

    required  this.bookingCode,

    required  this.amountPaise,

    required  this.status,

    required  this.method,

    required  this.mode,

    required  this.razorpayOrderId,

    required  this.razorpayPaymentId,

    required  this.createdAt,

    required  this.capturedAt,

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
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'method',
    required: true,
    includeIfNull: false,
  )


  final String method;



  @JsonKey(
    
    name: r'mode',
    required: true,
    includeIfNull: false,
  )


  final String mode;



  @JsonKey(
    
    name: r'razorpayOrderId',
    required: true,
    includeIfNull: false,
  )


  final String razorpayOrderId;



  @JsonKey(
    
    name: r'razorpayPaymentId',
    required: true,
    includeIfNull: false,
  )


  final String razorpayPaymentId;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'capturedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? capturedAt;



  @JsonKey(
    
    name: r'failureReason',
    required: true,
    includeIfNull: false,
  )


  final String failureReason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminPaymentOut &&
      other.id == id &&
      other.bookingId == bookingId &&
      other.bookingCode == bookingCode &&
      other.amountPaise == amountPaise &&
      other.status == status &&
      other.method == method &&
      other.mode == mode &&
      other.razorpayOrderId == razorpayOrderId &&
      other.razorpayPaymentId == razorpayPaymentId &&
      other.createdAt == createdAt &&
      other.capturedAt == capturedAt &&
      other.failureReason == failureReason;

    @override
    int get hashCode =>
        id.hashCode +
        bookingId.hashCode +
        bookingCode.hashCode +
        amountPaise.hashCode +
        status.hashCode +
        method.hashCode +
        mode.hashCode +
        razorpayOrderId.hashCode +
        razorpayPaymentId.hashCode +
        createdAt.hashCode +
        (capturedAt == null ? 0 : capturedAt.hashCode) +
        failureReason.hashCode;

  factory AdminPaymentOut.fromJson(Map<String, dynamic> json) => _$AdminPaymentOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminPaymentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

