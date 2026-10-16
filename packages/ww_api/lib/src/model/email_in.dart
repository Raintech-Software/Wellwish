//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class EmailIn {
  /// Returns a new [EmailIn] instance.
  EmailIn({

    required  this.email,
  });

  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final String email;





    @override
    bool operator ==(Object other) => identical(this, other) || other is EmailIn &&
      other.email == email;

    @override
    int get hashCode =>
        email.hashCode;

  factory EmailIn.fromJson(Map<String, dynamic> json) => _$EmailInFromJson(json);

  Map<String, dynamic> toJson() => _$EmailInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

