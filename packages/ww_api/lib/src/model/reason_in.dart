//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reason_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReasonIn {
  /// Returns a new [ReasonIn] instance.
  ReasonIn({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReasonIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory ReasonIn.fromJson(Map<String, dynamic> json) => _$ReasonInFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

