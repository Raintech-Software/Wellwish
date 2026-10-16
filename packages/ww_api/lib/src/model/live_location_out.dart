//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_location_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LiveLocationOut {
  /// Returns a new [LiveLocationOut] instance.
  LiveLocationOut({

    required  this.bookingId,

     this.lat,

     this.lng,

     this.at,

     this.etaMin,

    required  this.step,
  });

  @JsonKey(
    
    name: r'bookingId',
    required: true,
    includeIfNull: false,
  )


  final String bookingId;



      /// Empty until the first point
  @JsonKey(
    
    name: r'lat',
    required: false,
    includeIfNull: false,
  )


  final String? lat;



  @JsonKey(
    
    name: r'lng',
    required: false,
    includeIfNull: false,
  )


  final String? lng;



  @JsonKey(
    
    name: r'at',
    required: false,
    includeIfNull: false,
  )


  final DateTime? at;



      /// Minutes to where they're heading (a simple guess)
  @JsonKey(
    
    name: r'etaMin',
    required: false,
    includeIfNull: false,
  )


  final int? etaMin;



  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final String step;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LiveLocationOut &&
      other.bookingId == bookingId &&
      other.lat == lat &&
      other.lng == lng &&
      other.at == at &&
      other.etaMin == etaMin &&
      other.step == step;

    @override
    int get hashCode =>
        bookingId.hashCode +
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        (at == null ? 0 : at.hashCode) +
        (etaMin == null ? 0 : etaMin.hashCode) +
        step.hashCode;

  factory LiveLocationOut.fromJson(Map<String, dynamic> json) => _$LiveLocationOutFromJson(json);

  Map<String, dynamic> toJson() => _$LiveLocationOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

