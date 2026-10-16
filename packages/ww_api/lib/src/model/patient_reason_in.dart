//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_reason_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientReasonIn {
  /// Returns a new [PatientReasonIn] instance.
  PatientReasonIn({

    required  this.reason,
  });

      /// why (5+ letters, logged)
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientReasonIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory PatientReasonIn.fromJson(Map<String, dynamic> json) => _$PatientReasonInFromJson(json);

  Map<String, dynamic> toJson() => _$PatientReasonInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

