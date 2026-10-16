//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RoleOut {
  /// Returns a new [RoleOut] instance.
  RoleOut({

    required  this.code,

    required  this.name,

    required  this.permissions,

    required  this.userCount,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'permissions',
    required: true,
    includeIfNull: false,
  )


  final List<String> permissions;



  @JsonKey(
    
    name: r'userCount',
    required: true,
    includeIfNull: false,
  )


  final int userCount;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RoleOut &&
      other.code == code &&
      other.name == name &&
      other.permissions == permissions &&
      other.userCount == userCount;

    @override
    int get hashCode =>
        code.hashCode +
        name.hashCode +
        permissions.hashCode +
        userCount.hashCode;

  factory RoleOut.fromJson(Map<String, dynamic> json) => _$RoleOutFromJson(json);

  Map<String, dynamic> toJson() => _$RoleOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

