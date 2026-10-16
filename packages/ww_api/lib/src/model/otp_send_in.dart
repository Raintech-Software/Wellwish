//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_send_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpSendIn {
  /// Returns a new [OtpSendIn] instance.
  OtpSendIn({

    required  this.phone,

    required  this.purpose,

    required  this.deviceId,

     this.appHash = '',
  });

      /// Indian mobile, e.g. 9876543210
  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// login = patient app, partner_primary = partner
  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final OtpSendInPurposeEnum purpose;



  @JsonKey(
    
    name: r'deviceId',
    required: true,
    includeIfNull: false,
  )


  final String deviceId;



      /// Android SMS Retriever hash, added to the SMS so the app can read it
  @JsonKey(
    defaultValue: '',
    name: r'appHash',
    required: false,
    includeIfNull: false,
  )


  final String? appHash;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpSendIn &&
      other.phone == phone &&
      other.purpose == purpose &&
      other.deviceId == deviceId &&
      other.appHash == appHash;

    @override
    int get hashCode =>
        phone.hashCode +
        purpose.hashCode +
        deviceId.hashCode +
        appHash.hashCode;

  factory OtpSendIn.fromJson(Map<String, dynamic> json) => _$OtpSendInFromJson(json);

  Map<String, dynamic> toJson() => _$OtpSendInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// login = patient app, partner_primary = partner
enum OtpSendInPurposeEnum {
@JsonValue(r'login')
login(r'login'),
@JsonValue(r'partner_primary')
partnerPrimary(r'partner_primary');

const OtpSendInPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


