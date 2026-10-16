//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'start_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class StartIn {
  /// Returns a new [StartIn] instance.
  StartIn({

    required  this.role,
  });

  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final StartInRoleEnum role;





    @override
    bool operator ==(Object other) => identical(this, other) || other is StartIn &&
      other.role == role;

    @override
    int get hashCode =>
        role.hashCode;

  factory StartIn.fromJson(Map<String, dynamic> json) => _$StartInFromJson(json);

  Map<String, dynamic> toJson() => _$StartInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum StartInRoleEnum {
@JsonValue(r'COMPANION')
COMPANION(r'COMPANION'),
@JsonValue(r'NURSE')
NURSE(r'NURSE');

const StartInRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


