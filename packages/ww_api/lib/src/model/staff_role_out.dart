//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'staff_role_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StaffRoleOut {
  /// Returns a new [StaffRoleOut] instance.
  StaffRoleOut({

    required  this.code,

    required  this.name,
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





    @override
    bool operator ==(Object other) => identical(this, other) || other is StaffRoleOut &&
      other.code == code &&
      other.name == name;

    @override
    int get hashCode =>
        code.hashCode +
        name.hashCode;

  factory StaffRoleOut.fromJson(Map<String, dynamic> json) => _$StaffRoleOutFromJson(json);

  Map<String, dynamic> toJson() => _$StaffRoleOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

