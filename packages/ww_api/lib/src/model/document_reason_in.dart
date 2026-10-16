//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_reason_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentReasonIn {
  /// Returns a new [DocumentReasonIn] instance.
  DocumentReasonIn({

    required  this.reason,
  });

      /// why you need to open it (5+ letters, logged)
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentReasonIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory DocumentReasonIn.fromJson(Map<String, dynamic> json) => _$DocumentReasonInFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentReasonInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

