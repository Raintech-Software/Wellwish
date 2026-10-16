//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'code_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CodeIn {
  /// Returns a new [CodeIn] instance.
  CodeIn({

    required  this.code,
  });

  @JsonKey(
    
    name: r'code',
    required: true,
    includeIfNull: false,
  )


  final String code;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CodeIn &&
      other.code == code;

    @override
    int get hashCode =>
        code.hashCode;

  factory CodeIn.fromJson(Map<String, dynamic> json) => _$CodeInFromJson(json);

  Map<String, dynamic> toJson() => _$CodeInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

