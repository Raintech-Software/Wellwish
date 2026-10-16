//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'temporary_end_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TemporaryEndIn {
  /// Returns a new [TemporaryEndIn] instance.
  TemporaryEndIn({

    required  this.reason,
  });

      /// Why the access ends now (logged)
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TemporaryEndIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory TemporaryEndIn.fromJson(Map<String, dynamic> json) => _$TemporaryEndInFromJson(json);

  Map<String, dynamic> toJson() => _$TemporaryEndInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

