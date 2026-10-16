//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancellation_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancellationRowOut {
  /// Returns a new [CancellationRowOut] instance.
  CancellationRowOut({

    required  this.kind,

    required  this.bookingId,

    required  this.code,

    required  this.visitDate,

    required  this.service,

    required  this.at,

    required  this.by,

    required  this.reason,

     this.refundPercent,

    required  this.feePaidPaise,

    required  this.refundedPaise,

    required  this.refundStatus,
  });

      /// CANCELLED (a booking cancelled) · REFUND (after a visit)
  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'visitDate',
    required: true,
    includeIfNull: false,
  )


  final DateTime visitDate;



  @JsonKey(
    
    name: r'service',
    required: true,
    includeIfNull: false,
  )


  final String service;



      /// When it was cancelled / the refund was asked
  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



      /// PATIENT · STAFF (an admin) · SYSTEM
  @JsonKey(
    
    name: r'by',
    required: true,
    includeIfNull: false,
  )


  final String by;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'refundPercent',
    required: false,
    includeIfNull: false,
  )


  final int? refundPercent;



  @JsonKey(
    
    name: r'feePaidPaise',
    required: true,
    includeIfNull: false,
  )


  final int feePaidPaise;



  @JsonKey(
    
    name: r'refundedPaise',
    required: true,
    includeIfNull: false,
  )


  final int refundedPaise;



      /// The latest refund's status, empty if none
  @JsonKey(
    
    name: r'refundStatus',
    required: true,
    includeIfNull: false,
  )


  final String refundStatus;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancellationRowOut &&
      other.kind == kind &&
      other.bookingId == bookingId &&
      other.code == code &&
      other.visitDate == visitDate &&
      other.service == service &&
      other.at == at &&
      other.by == by &&
      other.reason == reason &&
      other.refundPercent == refundPercent &&
      other.feePaidPaise == feePaidPaise &&
      other.refundedPaise == refundedPaise &&
      other.refundStatus == refundStatus;

    @override
    int get hashCode =>
        kind.hashCode +
        bookingId.hashCode +
        code.hashCode +
        visitDate.hashCode +
        service.hashCode +
        at.hashCode +
        by.hashCode +
        reason.hashCode +
        (refundPercent == null ? 0 : refundPercent.hashCode) +
        feePaidPaise.hashCode +
        refundedPaise.hashCode +
        refundStatus.hashCode;

  factory CancellationRowOut.fromJson(Map<String, dynamic> json) => _$CancellationRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$CancellationRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

