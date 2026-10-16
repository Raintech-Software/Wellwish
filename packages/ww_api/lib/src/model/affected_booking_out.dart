//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'affected_booking_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AffectedBookingOut {
  /// Returns a new [AffectedBookingOut] instance.
  AffectedBookingOut({

    required  this.id,

    required  this.code,

    required  this.pickupAt,

    required  this.status,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AffectedBookingOut &&
      other.id == id &&
      other.code == code &&
      other.pickupAt == pickupAt &&
      other.status == status;

    @override
    int get hashCode =>
        id.hashCode +
        code.hashCode +
        pickupAt.hashCode +
        status.hashCode;

  factory AffectedBookingOut.fromJson(Map<String, dynamic> json) => _$AffectedBookingOutFromJson(json);

  Map<String, dynamic> toJson() => _$AffectedBookingOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

