//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/staff_role_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_me_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffMeOut {
  /// Returns a new [StaffMeOut] instance.
  StaffMeOut({

    required  this.id,

    required  this.name,

    required  this.email,

    required  this.role,

    required  this.permissions,

    required  this.recoveryCodesLeft,

    required  this.recoveryCodesSaved,

    required  this.onlySuperAdmin,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



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


  final StaffRoleOut role;



  @JsonKey(
    
    name: r'permissions',
    required: true,
    includeIfNull: false,
  )


  final List<String> permissions;



      /// Unused recovery codes (v2.16)
  @JsonKey(
    
    name: r'recoveryCodesLeft',
    required: true,
    includeIfNull: false,
  )


  final int recoveryCodesLeft;



      /// The admin confirmed saving the current codes (false: warn, make new ones)
  @JsonKey(
    
    name: r'recoveryCodesSaved',
    required: true,
    includeIfNull: false,
  )


  final bool recoveryCodesSaved;



      /// A Super Admin who is the only active one: add a second (v2.16)
  @JsonKey(
    
    name: r'onlySuperAdmin',
    required: true,
    includeIfNull: false,
  )


  final bool onlySuperAdmin;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffMeOut &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.role == role &&
      other.permissions == permissions &&
      other.recoveryCodesLeft == recoveryCodesLeft &&
      other.recoveryCodesSaved == recoveryCodesSaved &&
      other.onlySuperAdmin == onlySuperAdmin;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        email.hashCode +
        role.hashCode +
        permissions.hashCode +
        recoveryCodesLeft.hashCode +
        recoveryCodesSaved.hashCode +
        onlySuperAdmin.hashCode;

  factory StaffMeOut.fromJson(Map<String, dynamic> json) => _$StaffMeOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffMeOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

