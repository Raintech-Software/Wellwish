//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'otp_send_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OtpSendOut {
  /// Returns a new [OtpSendOut] instance.
  OtpSendOut({

    required  this.expiresInSeconds,

    required  this.resendAfterSeconds,

    required  this.length,
  });

  @JsonKey(
    
    name: r'expiresInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int expiresInSeconds;



  @JsonKey(
    
    name: r'resendAfterSeconds',
    required: true,
    includeIfNull: false,
  )


  final int resendAfterSeconds;



  @JsonKey(
    
    name: r'length',
    required: true,
    includeIfNull: false,
  )


  final int length;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OtpSendOut &&
      other.expiresInSeconds == expiresInSeconds &&
      other.resendAfterSeconds == resendAfterSeconds &&
      other.length == length;

    @override
    int get hashCode =>
        expiresInSeconds.hashCode +
        resendAfterSeconds.hashCode +
        length.hashCode;

  factory OtpSendOut.fromJson(Map<String, dynamic> json) => _$OtpSendOutFromJson(json);

  Map<String, dynamic> toJson() => _$OtpSendOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

