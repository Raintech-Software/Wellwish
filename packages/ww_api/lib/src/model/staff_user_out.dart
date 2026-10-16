//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/staff_role_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_user_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffUserOut {
  /// Returns a new [StaffUserOut] instance.
  StaffUserOut({

    required  this.id,

    required  this.name,

    required  this.email,

    required  this.role,

    required  this.status,

    required  this.twoFactorSet,

    required  this.lastLoginAt,

    required  this.createdAt,

    required  this.activeSessions,

    required  this.isYou,
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
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final StaffUserOutStatusEnum status;



      /// False until they scan the QR code
  @JsonKey(
    
    name: r'twoFactorSet',
    required: true,
    includeIfNull: false,
  )


  final bool twoFactorSet;



  @JsonKey(
    
    name: r'lastLoginAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? lastLoginAt;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



  @JsonKey(
    
    name: r'activeSessions',
    required: true,
    includeIfNull: false,
  )


  final int activeSessions;



  @JsonKey(
    
    name: r'isYou',
    required: true,
    includeIfNull: false,
  )


  final bool isYou;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffUserOut &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.role == role &&
      other.status == status &&
      other.twoFactorSet == twoFactorSet &&
      other.lastLoginAt == lastLoginAt &&
      other.createdAt == createdAt &&
      other.activeSessions == activeSessions &&
      other.isYou == isYou;

    @override
    int get hashCode =>
        id.hashCode +
        name.hashCode +
        email.hashCode +
        role.hashCode +
        status.hashCode +
        twoFactorSet.hashCode +
        (lastLoginAt == null ? 0 : lastLoginAt.hashCode) +
        createdAt.hashCode +
        activeSessions.hashCode +
        isYou.hashCode;

  factory StaffUserOut.fromJson(Map<String, dynamic> json) => _$StaffUserOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffUserOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum StaffUserOutStatusEnum {
@JsonValue(r'ACTIVE')
ACTIVE(r'ACTIVE'),
@JsonValue(r'DISABLED')
DISABLED(r'DISABLED');

const StaffUserOutStatusEnum(this.value);

final String value;

@override
String toString() => value;
}


