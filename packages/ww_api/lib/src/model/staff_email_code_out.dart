//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_email_code_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffEmailCodeOut {
  /// Returns a new [StaffEmailCodeOut] instance.
  StaffEmailCodeOut({

    required  this.challengeToken,

    required  this.emailMasked,

    required  this.resendAfterSeconds,
  });

      /// Use this one from now on (10 minutes)
  @JsonKey(
    
    name: r'challengeToken',
    required: true,
    includeIfNull: false,
  )


  final String challengeToken;



      /// Where the code went, e.g. a•••@wellwish.in
  @JsonKey(
    
    name: r'emailMasked',
    required: true,
    includeIfNull: false,
  )


  final String emailMasked;



  @JsonKey(
    
    name: r'resendAfterSeconds',
    required: true,
    includeIfNull: false,
  )


  final int resendAfterSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffEmailCodeOut &&
      other.challengeToken == challengeToken &&
      other.emailMasked == emailMasked &&
      other.resendAfterSeconds == resendAfterSeconds;

    @override
    int get hashCode =>
        challengeToken.hashCode +
        emailMasked.hashCode +
        resendAfterSeconds.hashCode;

  factory StaffEmailCodeOut.fromJson(Map<String, dynamic> json) => _$StaffEmailCodeOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffEmailCodeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

