//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'live_job_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class LiveJobOut {
  /// Returns a new [LiveJobOut] instance.
  LiveJobOut({

    required  this.bookingId,

     this.lat,

     this.lng,

     this.at,

     this.etaMin,

    required  this.step,

    required  this.code,

    required  this.partnerName,

    required  this.partnerPhone,

    required  this.partnerAlternatePhone,

    required  this.serviceName,

    required  this.memberName,

    required  this.pickupAt,

    required  this.stale,
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



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



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
    
    name: r'partnerAlternatePhone',
    required: true,
    includeIfNull: false,
  )


  final String partnerAlternatePhone;



  @JsonKey(
    
    name: r'serviceName',
    required: true,
    includeIfNull: false,
  )


  final String serviceName;



  @JsonKey(
    
    name: r'memberName',
    required: true,
    includeIfNull: false,
  )


  final String memberName;



  @JsonKey(
    
    name: r'pickupAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime pickupAt;



      /// No point for 2 minutes
  @JsonKey(
    
    name: r'stale',
    required: true,
    includeIfNull: false,
  )


  final bool stale;





    @override
    bool operator ==(Object other) => identical(this, other) || other is LiveJobOut &&
      other.bookingId == bookingId &&
      other.lat == lat &&
      other.lng == lng &&
      other.at == at &&
      other.etaMin == etaMin &&
      other.step == step &&
      other.code == code &&
      other.partnerName == partnerName &&
      other.partnerPhone == partnerPhone &&
      other.partnerAlternatePhone == partnerAlternatePhone &&
      other.serviceName == serviceName &&
      other.memberName == memberName &&
      other.pickupAt == pickupAt &&
      other.stale == stale;

    @override
    int get hashCode =>
        bookingId.hashCode +
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        (at == null ? 0 : at.hashCode) +
        (etaMin == null ? 0 : etaMin.hashCode) +
        step.hashCode +
        code.hashCode +
        partnerName.hashCode +
        partnerPhone.hashCode +
        partnerAlternatePhone.hashCode +
        serviceName.hashCode +
        memberName.hashCode +
        pickupAt.hashCode +
        stale.hashCode;

  factory LiveJobOut.fromJson(Map<String, dynamic> json) => _$LiveJobOutFromJson(json);

  Map<String, dynamic> toJson() => _$LiveJobOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

