//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_totp_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffTotpIn {
  /// Returns a new [StaffTotpIn] instance.
  StaffTotpIn({

    required  this.challengeToken,

    required  this.code,

     this.trustBrowser = false,
  });

  @JsonKey(
    
    name: r'challengeToken',
    required: true,
    includeIfNull: false,
  )


  final String challengeToken;



  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



      /// Trust this browser for 30 days: the password alone signs in here
  @JsonKey(
    defaultValue: false,
    name: r'trustBrowser',
    required: false,
    includeIfNull: false,
  )


  final bool? trustBrowser;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffTotpIn &&
      other.challengeToken == challengeToken &&
      other.code == code &&
      other.trustBrowser == trustBrowser;

    @override
    int get hashCode =>
        challengeToken.hashCode +
        code.hashCode +
        trustBrowser.hashCode;

  factory StaffTotpIn.fromJson(Map<String, dynamic> json) => _$StaffTotpInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffTotpInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

