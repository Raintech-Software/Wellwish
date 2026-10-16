//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_password_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffPasswordIn {
  /// Returns a new [StaffPasswordIn] instance.
  StaffPasswordIn({

    required  this.password,
  });

  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffPasswordIn &&
      other.password == password;

    @override
    int get hashCode =>
        password.hashCode;

  factory StaffPasswordIn.fromJson(Map<String, dynamic> json) => _$StaffPasswordInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffPasswordInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

