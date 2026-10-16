//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_user_create_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffUserCreateIn {
  /// Returns a new [StaffUserCreateIn] instance.
  StaffUserCreateIn({

    required  this.name,

    required  this.email,

    required  this.role,

    required  this.password,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



      /// First password; tell them in person
  @JsonKey(
    
    name: r'password',
    required: true,
    includeIfNull: false,
  )


  final String password;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffUserCreateIn &&
      other.name == name &&
      other.email == email &&
      other.role == role &&
      other.password == password;

    @override
    int get hashCode =>
        name.hashCode +
        email.hashCode +
        role.hashCode +
        password.hashCode;

  factory StaffUserCreateIn.fromJson(Map<String, dynamic> json) => _$StaffUserCreateInFromJson(json);

  Map<String, dynamic> toJson() => _$StaffUserCreateInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

