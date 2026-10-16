//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_user_update_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffUserUpdateIn {
  /// Returns a new [StaffUserUpdateIn] instance.
  StaffUserUpdateIn({

    required  this.name,

    required  this.role,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffUserUpdateIn &&
      other.name == name &&
      other.role == role;

    @override
    int get hashCode =>
        name.hashCode +
        role.hashCode;

  factory StaffUserUpdateIn.fromJson(Map<String, dynamic> json) => _$StaffUserUpdateInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffUserUpdateInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

