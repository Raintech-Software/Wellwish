//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_codes_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RecoveryCodesIn {
  /// Returns a new [RecoveryCodesIn] instance.
  RecoveryCodesIn({

    required  this.password,
  });

  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RecoveryCodesIn &&
      other.password == password;

    @override
    int get hashCode =>
        password.hashCode;

  factory RecoveryCodesIn.fromJson(Map<String, dynamic> json) => _$RecoveryCodesInFromJson(json);

  Map<String, dynamic> toJson() => _$RecoveryCodesInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

