//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddressOut {
  /// Returns a new [AddressOut] instance.
  AddressOut({

    required  this.id,

    required  this.memberId,

    required  this.label,

    required  this.line1,

    required  this.landmark,

    required  this.notes,

    required  this.lat,

    required  this.lng,

    required  this.inServiceArea,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'memberId',
    required: true,
    includeIfNull: false,
  )


  final String memberId;



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



      /// false → bookings here are refused
  @JsonKey(
    
    name: r'inServiceArea',
    required: true,
    includeIfNull: false,
  )


  final bool inServiceArea;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddressOut &&
      other.id == id &&
      other.memberId == memberId &&
      other.label == label &&
      other.line1 == line1 &&
      other.landmark == landmark &&
      other.notes == notes &&
      other.lat == lat &&
      other.lng == lng &&
      other.inServiceArea == inServiceArea &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        memberId.hashCode +
        label.hashCode +
        line1.hashCode +
        landmark.hashCode +
        notes.hashCode +
        lat.hashCode +
        lng.hashCode +
        inServiceArea.hashCode +
        createdAt.hashCode;

  factory AddressOut.fromJson(Map<String, dynamic> json) => _$AddressOutFromJson(json);

  Map<String, dynamic> toJson() => _$AddressOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

