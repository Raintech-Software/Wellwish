//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cancel_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CancelIn {
  /// Returns a new [CancelIn] instance.
  CancelIn({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CancelIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory CancelIn.fromJson(Map<String, dynamic> json) => _$CancelInFromJson(json);

  Map<String, dynamic> toJson() => _$CancelInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

