//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_moderate_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReviewModerateIn {
  /// Returns a new [ReviewModerateIn] instance.
  ReviewModerateIn({

    required  this.reason,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ReviewModerateIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory ReviewModerateIn.fromJson(Map<String, dynamic> json) => _$ReviewModerateInFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModerateInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

