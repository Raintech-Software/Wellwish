//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'checkout_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CheckoutOut {
  /// Returns a new [CheckoutOut] instance.
  CheckoutOut({

    required  this.keyId,

    required  this.orderId,

    required  this.amountPaise,

    required  this.currency,

    required  this.bookingCode,

    required  this.payBy,
  });

  @JsonKey(
    
    name: r'keyId',
    required: true,
    includeIfNull: false,
  )


  final String keyId;



  @JsonKey(
    
    name: r'orderId',
    required: true,
    includeIfNull: false,
  )


  final String orderId;



      /// The booking fee, from the booking's snapshot
  @JsonKey(
    
    name: r'amountPaise',
    required: true,
    includeIfNull: false,
  )


  final int amountPaise;



  @JsonKey(
    
    name: r'currency',
    required: true,
    includeIfNull: false,
  )


  final String currency;



  @JsonKey(
    
    name: r'bookingCode',
    required: true,
    includeIfNull: false,
  )


  final String bookingCode;



  @JsonKey(
    
    name: r'payBy',
    required: true,
    includeIfNull: false,
  )


  final DateTime payBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CheckoutOut &&
      other.keyId == keyId &&
      other.orderId == orderId &&
      other.amountPaise == amountPaise &&
      other.currency == currency &&
      other.bookingCode == bookingCode &&
      other.payBy == payBy;

    @override
    int get hashCode =>
        keyId.hashCode +
        orderId.hashCode +
        amountPaise.hashCode +
        currency.hashCode +
        bookingCode.hashCode +
        payBy.hashCode;

  factory CheckoutOut.fromJson(Map<String, dynamic> json) => _$CheckoutOutFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

