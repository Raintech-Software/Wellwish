//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_recovery_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffRecoveryIn {
  /// Returns a new [StaffRecoveryIn] instance.
  StaffRecoveryIn({

    required  this.challengeToken,

    required  this.code,
  });

  @JsonKey(
    
    name: r'challengeToken',
    required: true,
    includeIfNull: false,
  )


  final String challengeToken;



      /// e.g. abcd-2345
  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffRecoveryIn &&
      other.challengeToken == challengeToken &&
      other.code == code;

    @override
    int get hashCode =>
        challengeToken.hashCode +
        code.hashCode;

  factory StaffRecoveryIn.fromJson(Map<String, dynamic> json) => _$StaffRecoveryInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffRecoveryInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

