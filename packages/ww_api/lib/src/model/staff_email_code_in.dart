//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_email_code_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffEmailCodeIn {
  /// Returns a new [StaffEmailCodeIn] instance.
  StaffEmailCodeIn({

    required  this.challengeToken,
  });

      /// From the code step
  @JsonKey(
    
    name: r'challengeToken',
    required: true,
    includeIfNull: false,
  )


  final String challengeToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffEmailCodeIn &&
      other.challengeToken == challengeToken;

    @override
    int get hashCode =>
        challengeToken.hashCode;

  factory StaffEmailCodeIn.fromJson(Map<String, dynamic> json) => _$StaffEmailCodeInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffEmailCodeInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

