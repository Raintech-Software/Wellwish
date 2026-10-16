//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/affected_booking_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blocked_time_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BlockedTimeOut {
  /// Returns a new [BlockedTimeOut] instance.
  BlockedTimeOut({

    required  this.id,

    required  this.fromTs,

    required  this.toTs,

    required  this.reason,

    required  this.serviceType,

     this.createdBy,

     this.affectedBookings,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'fromTs',
    required: true,
    includeIfNull: false,
  )


  final DateTime fromTs;



  @JsonKey(
    
    name: r'toTs',
    required: true,
    includeIfNull: false,
  )


  final DateTime toTs;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'serviceType',
    required: true,
    includeIfNull: true,
  )


  final String? serviceType;



      /// Staff name
  @JsonKey(
    
    name: r'createdBy',
    required: false,
    includeIfNull: false,
  )


  final String? createdBy;



      /// Bookings inside this range (from Phase 5)
  @JsonKey(
    
    name: r'affectedBookings',
    required: false,
    includeIfNull: false,
  )


  final List<AffectedBookingOut>? affectedBookings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BlockedTimeOut &&
      other.id == id &&
      other.fromTs == fromTs &&
      other.toTs == toTs &&
      other.reason == reason &&
      other.serviceType == serviceType &&
      other.createdBy == createdBy &&
      other.affectedBookings == affectedBookings;

    @override
    int get hashCode =>
        id.hashCode +
        fromTs.hashCode +
        toTs.hashCode +
        reason.hashCode +
        (serviceType == null ? 0 : serviceType.hashCode) +
        (createdBy == null ? 0 : createdBy.hashCode) +
        affectedBookings.hashCode;

  factory BlockedTimeOut.fromJson(Map<String, dynamic> json) => _$BlockedTimeOutFromJson(json);

  Map<String, dynamic> toJson() => _$BlockedTimeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

