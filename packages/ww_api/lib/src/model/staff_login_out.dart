//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/staff_token_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_login_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffLoginOut {
  /// Returns a new [StaffLoginOut] instance.
  StaffLoginOut({

    required  this.step,

     this.challengeToken = '',

     this.otpauthUri,

     this.secret,

     this.signedIn,
  });

      /// TOTP_SETUP: first login, show the QR code. TOTP: ask for the code. SIGNED_IN: a trusted browser (v2.16), the tokens below.
  @JsonKey(
    
    name: r'step',
    required: true,
    includeIfNull: false,
  )


  final StaffLoginOutStepEnum step;



      /// Empty when SIGNED_IN
  @JsonKey(
    defaultValue: '',
    name: r'challengeToken',
    required: false,
    includeIfNull: false,
  )


  final String? challengeToken;



      /// Only for TOTP_SETUP: encode as QR code
  @JsonKey(
    
    name: r'otpauthUri',
    required: false,
    includeIfNull: false,
  )


  final String? otpauthUri;



      /// Only for TOTP_SETUP: for typing in by hand
  @JsonKey(
    
    name: r'secret',
    required: false,
    includeIfNull: false,
  )


  final String? secret;



      /// Only for SIGNED_IN
  @JsonKey(
    
    name: r'signedIn',
    required: false,
    includeIfNull: false,
  )


  final StaffTokenOut? signedIn;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffLoginOut &&
      other.step == step &&
      other.challengeToken == challengeToken &&
      other.otpauthUri == otpauthUri &&
      other.secret == secret &&
      other.signedIn == signedIn;

    @override
    int get hashCode =>
        step.hashCode +
        challengeToken.hashCode +
        (otpauthUri == null ? 0 : otpauthUri.hashCode) +
        (secret == null ? 0 : secret.hashCode) +
        (signedIn == null ? 0 : signedIn.hashCode);

  factory StaffLoginOut.fromJson(Map<String, dynamic> json) => _$StaffLoginOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffLoginOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

/// TOTP_SETUP: first login, show the QR code. TOTP: ask for the code. SIGNED_IN: a trusted browser (v2.16), the tokens below.
enum StaffLoginOutStepEnum {
@JsonValue(r'TOTP_SETUP')
TOTP_SETUP(r'TOTP_SETUP'),
@JsonValue(r'TOTP')
TOTP(r'TOTP'),
@JsonValue(r'SIGNED_IN')
SIGNED_IN(r'SIGNED_IN');

const StaffLoginOutStepEnum(this.value);

final String value;

@override
String toString() => value;
}


