//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PermissionOut {
  /// Returns a new [PermissionOut] instance.
  PermissionOut({

    required  this.code,

    required  this.description,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;



  @JsonKey(
    
    name: r'description',
    required: true,
    includeIfNull: false,
  )


  final String description;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PermissionOut &&
      other.code == code &&
      other.description == description;

    @override
    int get hashCode =>
        code.hashCode +
        description.hashCode;

  factory PermissionOut.fromJson(Map<String, dynamic> json) => _$PermissionOutFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

