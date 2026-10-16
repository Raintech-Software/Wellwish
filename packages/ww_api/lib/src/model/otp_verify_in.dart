//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_verify_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpVerifyIn {
  /// Returns a new [OtpVerifyIn] instance.
  OtpVerifyIn({

    required  this.phone,

    required  this.otp,

    required  this.purpose,

    required  this.deviceId,

     this.googleLinkToken,

     this.language,
  });

  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'otp',
    required: true,
    includeIfNull: false,
  )


  final String otp;



  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final OtpVerifyInPurposeEnum purpose;



  @JsonKey(
    
    name: r'deviceId',
    required: true,
    includeIfNull: false,
  )


  final String deviceId;



      /// From /auth/google when it answered PHONE_REQUIRED
  @JsonKey(
    
    name: r'googleLinkToken',
    required: false,
    includeIfNull: false,
  )


  final String? googleLinkToken;



      /// The app's language at login (the phone's): a new account starts in it (§5)
  @JsonKey(
    
    name: r'language',
    required: false,
    includeIfNull: false,
  )


  final OtpVerifyInLanguageEnum? language;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpVerifyIn &&
      other.phone == phone &&
      other.otp == otp &&
      other.purpose == purpose &&
      other.deviceId == deviceId &&
      other.googleLinkToken == googleLinkToken &&
      other.language == language;

    @override
    int get hashCode =>
        phone.hashCode +
        otp.hashCode +
        purpose.hashCode +
        deviceId.hashCode +
        (googleLinkToken == null ? 0 : googleLinkToken.hashCode) +
        (language == null ? 0 : language.hashCode);

  factory OtpVerifyIn.fromJson(Map<String, dynamic> json) => _$OtpVerifyInFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum OtpVerifyInPurposeEnum {
@JsonValue(r'login')
login(r'login'),
@JsonValue(r'partner_primary')
partnerPrimary(r'partner_primary');

const OtpVerifyInPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


/// The app's language at login (the phone's): a new account starts in it (§5)
enum OtpVerifyInLanguageEnum {
@JsonValue(r'en')
en(r'en'),
@JsonValue(r'hi')
hi(r'hi'),
@JsonValue(r'or')
or(r'or');

const OtpVerifyInLanguageEnum(this.value);

final String value;

@override
String toString() => value;
}


