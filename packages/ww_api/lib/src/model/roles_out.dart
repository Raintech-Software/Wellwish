//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/permission_out.dart';
import 'package:ww_api/src/model/role_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roles_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RolesOut {
  /// Returns a new [RolesOut] instance.
  RolesOut({

    required  this.roles,

    required  this.permissions,
  });

  @JsonKey(
    
    name: r'roles',
    required: true,
    includeIfNull: false,
  )


  final List<RoleOut> roles;



  @JsonKey(
    
    name: r'permissions',
    required: true,
    includeIfNull: false,
  )


  final List<PermissionOut> permissions;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RolesOut &&
      other.roles == roles &&
      other.permissions == permissions;

    @override
    int get hashCode =>
        roles.hashCode +
        permissions.hashCode;

  factory RolesOut.fromJson(Map<String, dynamic> json) => _$RolesOutFromJson(json);

  Map<String, dynamic> toJson() => _$RolesOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

