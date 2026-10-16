//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_sos_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminSosOut {
  /// Returns a new [AdminSosOut] instance.
  AdminSosOut({

    required  this.id,

    required  this.bookingId,

    required  this.code,

    required  this.side,

    required  this.status,

    required  this.lat,

    required  this.lng,

     this.mockLocation = false,

    required  this.partnerName,

    required  this.partnerPhone,

    required  this.memberName,

    required  this.raisedAt,

    required  this.ackBy,

    required  this.ackAt,

    required  this.resolvedAt,

    required  this.notes,
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
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



      /// PATIENT or PARTNER: who pressed it
  @JsonKey(
    
    name: r'side',
    required: true,
    includeIfNull: false,
  )


  final String side;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'lat',
    required: true,
    includeIfNull: true,
  )


  final String? lat;



  @JsonKey(
    
    name: r'lng',
    required: true,
    includeIfNull: true,
  )


  final String? lng;



      /// the phone said its position was fake
  @JsonKey(
    defaultValue: false,
    name: r'mockLocation',
    required: false,
    includeIfNull: false,
  )


  final bool? mockLocation;



  @JsonKey(
    
    name: r'partnerName',
    required: true,
    includeIfNull: false,
  )


  final String partnerName;



  @JsonKey(
    
    name: r'partnerPhone',
    required: true,
    includeIfNull: false,
  )


  final String partnerPhone;



  @JsonKey(
    
    name: r'memberName',
    required: true,
    includeIfNull: false,
  )


  final String memberName;



  @JsonKey(
    
    name: r'raisedAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime raisedAt;



  @JsonKey(
    
    name: r'ackBy',
    required: true,
    includeIfNull: false,
  )


  final String ackBy;



  @JsonKey(
    
    name: r'ackAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? ackAt;



  @JsonKey(
    
    name: r'resolvedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? resolvedAt;



  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminSosOut &&
      other.id == id &&
      other.bookingId == bookingId &&
      other.code == code &&
      other.side == side &&
      other.status == status &&
      other.lat == lat &&
      other.lng == lng &&
      other.mockLocation == mockLocation &&
      other.partnerName == partnerName &&
      other.partnerPhone == partnerPhone &&
      other.memberName == memberName &&
      other.raisedAt == raisedAt &&
      other.ackBy == ackBy &&
      other.ackAt == ackAt &&
      other.resolvedAt == resolvedAt &&
      other.notes == notes;

    @override
    int get hashCode =>
        id.hashCode +
        bookingId.hashCode +
        code.hashCode +
        side.hashCode +
        status.hashCode +
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        mockLocation.hashCode +
        partnerName.hashCode +
        partnerPhone.hashCode +
        memberName.hashCode +
        raisedAt.hashCode +
        ackBy.hashCode +
        (ackAt == null ? 0 : ackAt.hashCode) +
        (resolvedAt == null ? 0 : resolvedAt.hashCode) +
        notes.hashCode;

  factory AdminSosOut.fromJson(Map<String, dynamic> json) => _$AdminSosOutFromJson(json);

  Map<String, dynamic> toJson() => _$AdminSosOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

