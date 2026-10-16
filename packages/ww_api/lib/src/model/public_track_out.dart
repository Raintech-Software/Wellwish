//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'public_track_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PublicTrackOut {
  /// Returns a new [PublicTrackOut] instance.
  PublicTrackOut({

    required  this.partnerFirstName,

    required  this.serviceName,

     this.serviceNameHi = '',

     this.serviceNameOr = '',

    required  this.status,

    required  this.step,

     this.lat,

     this.lng,

     this.at,

     this.etaMin,
  });

  @JsonKey(
    
    name: r'partnerFirstName',
    required: true,
    includeIfNull: false,
  )


  final String partnerFirstName;



  @JsonKey(
    
    name: r'serviceName',
    required: true,
    includeIfNull: false,
  )


  final String serviceName;



      /// The service in Hindi, when it has one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'serviceNameHi',
    required: false,
    includeIfNull: false,
  )


  final String? serviceNameHi;



      /// The service in Odia, when it has one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'serviceNameOr',
    required: false,
    includeIfNull: false,
  )


  final String? serviceNameOr;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final String step;



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



  @JsonKey(
    
    name: r'etaMin',
    required: false,
    includeIfNull: false,
  )


  final int? etaMin;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PublicTrackOut &&
      other.partnerFirstName == partnerFirstName &&
      other.serviceName == serviceName &&
      other.serviceNameHi == serviceNameHi &&
      other.serviceNameOr == serviceNameOr &&
      other.status == status &&
      other.step == step &&
      other.lat == lat &&
      other.lng == lng &&
      other.at == at &&
      other.etaMin == etaMin;

    @override
    int get hashCode =>
        partnerFirstName.hashCode +
        serviceName.hashCode +
        serviceNameHi.hashCode +
        serviceNameOr.hashCode +
        status.hashCode +
        step.hashCode +
        (lat == null ? 0 : lat.hashCode) +
        (lng == null ? 0 : lng.hashCode) +
        (at == null ? 0 : at.hashCode) +
        (etaMin == null ? 0 : etaMin.hashCode);

  factory PublicTrackOut.fromJson(Map<String, dynamic> json) => _$PublicTrackOutFromJson(json);

  Map<String, dynamic> toJson() => _$PublicTrackOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

