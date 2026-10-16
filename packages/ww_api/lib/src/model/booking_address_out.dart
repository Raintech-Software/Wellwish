//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_address_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class BookingAddressOut {
  /// Returns a new [BookingAddressOut] instance.
  BookingAddressOut({

    required  this.label,

    required  this.line1,

    required  this.landmark,

    required  this.notes,

    required  this.lat,

    required  this.lng,
  });

  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'line1',
    required: true,
    includeIfNull: false,
  )


  final String line1;



  @JsonKey(
    
    name: r'landmark',
    required: true,
    includeIfNull: false,
  )


  final String landmark;



  @JsonKey(
    
    name: r'notes',
    required: true,
    includeIfNull: false,
  )


  final String notes;



  @JsonKey(
    
    name: r'lat',
    required: true,
    includeIfNull: false,
  )


  final String lat;



  @JsonKey(
    
    name: r'lng',
    required: true,
    includeIfNull: false,
  )


  final String lng;





    @override
    bool operator ==(Object other) => identical(this, other) || other is BookingAddressOut &&
      other.label == label &&
      other.line1 == line1 &&
      other.landmark == landmark &&
      other.notes == notes &&
      other.lat == lat &&
      other.lng == lng;

    @override
    int get hashCode =>
        label.hashCode +
        line1.hashCode +
        landmark.hashCode +
        notes.hashCode +
        lat.hashCode +
        lng.hashCode;

  factory BookingAddressOut.fromJson(Map<String, dynamic> json) => _$BookingAddressOutFromJson(json);

  Map<String, dynamic> toJson() => _$BookingAddressOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

