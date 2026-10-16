//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingIn {
  /// Returns a new [BookingIn] instance.
  BookingIn({

    required  this.serviceId,

    required  this.memberId,

    required  this.addressId,

    required  this.pickupAt,

     this.appointmentAt,

     this.hospitalId,

     this.hospitalText = '',

     this.doctorId,

     this.documentIds,

     this.notes = '',
  });

  @JsonKey(
    
    name: r'serviceId',
    required: true,
    includeIfNull: false,
  )


  final String serviceId;



      /// Who the booking is for
  @JsonKey(
    
    name: r'memberId',
    required: true,
    includeIfNull: false,
  )


  final String memberId;



      /// Pickup or home address (inside a service area)
  @JsonKey(
    
    name: r'addressId',
    required: true,
    includeIfNull: false,
  )


  final String addressId;



      /// One of the times from booking-times
  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



      /// Hospital visits: the doctor appointment (same day, after pickup)
  @JsonKey(
    
    name: r'appointmentAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? appointmentAt;



  @JsonKey(
    
    name: r'hospitalId',
    required: false,
    includeIfNull: false,
  )


  final String? hospitalId;



      /// Hospital not in the list: its name and area, typed in
  @JsonKey(
    defaultValue: '',
    name: r'hospitalText',
    required: false,
    includeIfNull: false,
  )


  final String? hospitalText;



      /// A doctor at the chosen hospital
  @JsonKey(
    
    name: r'doctorId',
    required: false,
    includeIfNull: false,
  )


  final String? doctorId;



  @JsonKey(
    
    name: r'documentIds',
    required: false,
    includeIfNull: false,
  )


  final List<String>? documentIds;



  @JsonKey(
    defaultValue: '',
    name: r'notes',
    required: false,
    includeIfNull: false,
  )


  final String? notes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingIn &&
      other.serviceId == serviceId &&
      other.memberId == memberId &&
      other.addressId == addressId &&
      other.pickupAt == pickupAt &&
      other.appointmentAt == appointmentAt &&
      other.hospitalId == hospitalId &&
      other.hospitalText == hospitalText &&
      other.doctorId == doctorId &&
      other.documentIds == documentIds &&
      other.notes == notes;

    @override
    int get hashCode =>
        serviceId.hashCode +
        memberId.hashCode +
        addressId.hashCode +
        pickupAt.hashCode +
        (appointmentAt == null ? 0 : appointmentAt.hashCode) +
        (hospitalId == null ? 0 : hospitalId.hashCode) +
        hospitalText.hashCode +
        (doctorId == null ? 0 : doctorId.hashCode) +
        documentIds.hashCode +
        notes.hashCode;

  factory BookingIn.fromJson(Map<String, dynamic> json) => _$BookingInFromJson(json);

  Map<String, dynamic> toJson() => _$BookingInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

