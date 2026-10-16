//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alert_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AlertOut {
  /// Returns a new [AlertOut] instance.
  AlertOut({

    required  this.id,

    required  this.kind,

    required  this.bookingId,

    required  this.bookingCode,

    required  this.pickupAt,

    required  this.details,

    required  this.createdAt,

    required  this.acknowledgedAt,

    required  this.partnerName,

    required  this.phone,

    required  this.alternatePhone,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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
    
    name: r'bookingCode',
    required: true,
    includeIfNull: false,
  )


  final String bookingCode;



  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



  @JsonKey(
    
    name: r'details',
    required: true,
    includeIfNull: false,
  )


  final Map<String, Object> details;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'acknowledgedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? acknowledgedAt;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



      /// The offered partner's primary phone (call button)
  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'alternatePhone',
    required: true,
    includeIfNull: false,
  )


  final String alternatePhone;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AlertOut &&
      other.id == id &&
      other.kind == kind &&
      other.bookingId == bookingId &&
      other.bookingCode == bookingCode &&
      other.pickupAt == pickupAt &&
      other.details == details &&
      other.createdAt == createdAt &&
      other.acknowledgedAt == acknowledgedAt &&
      other.partnerName == partnerName &&
      other.phone == phone &&
      other.alternatePhone == alternatePhone;

    @override
    int get hashCode =>
        id.hashCode +
        kind.hashCode +
        bookingId.hashCode +
        bookingCode.hashCode +
        pickupAt.hashCode +
        details.hashCode +
        createdAt.hashCode +
        (acknowledgedAt == null ? 0 : acknowledgedAt.hashCode) +
        partnerName.hashCode +
        phone.hashCode +
        alternatePhone.hashCode;

  factory AlertOut.fromJson(Map<String, dynamic> json) => _$AlertOutFromJson(json);

  Map<String, dynamic> toJson() => _$AlertOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

