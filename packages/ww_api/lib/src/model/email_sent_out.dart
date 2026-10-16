//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_sent_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmailSentOut {
  /// Returns a new [EmailSentOut] instance.
  EmailSentOut({

    required  this.resendAfterSeconds,

    required  this.expiresInSeconds,
  });

  @JsonKey(
    
    name: r'resendAfterSeconds',
    required: true,
    includeIfNull: false,
  )


  final int resendAfterSeconds;



  @JsonKey(
    
    name: r'expiresInSeconds',
    required: true,
    includeIfNull: false,
  )


  final int expiresInSeconds;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EmailSentOut &&
      other.resendAfterSeconds == resendAfterSeconds &&
      other.expiresInSeconds == expiresInSeconds;

    @override
    int get hashCode =>
        resendAfterSeconds.hashCode +
        expiresInSeconds.hashCode;

  factory EmailSentOut.fromJson(Map<String, dynamic> json) => _$EmailSentOutFromJson(json);

  Map<String, dynamic> toJson() => _$EmailSentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

