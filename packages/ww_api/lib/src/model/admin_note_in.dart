//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admin_note_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdminNoteIn {
  /// Returns a new [AdminNoteIn] instance.
  AdminNoteIn({

    required  this.reason,

    required  this.expectedAssignmentId,
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



      /// The offer or accepted job the admin saw (`currentAssignmentId`). Changed meanwhile: 409 OFFER_CHANGED
  @JsonKey(
    
    name: r'expectedAssignmentId',
    required: true,
    includeIfNull: true,
  )


  final String? expectedAssignmentId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AdminNoteIn &&
      other.reason == reason &&
      other.expectedAssignmentId == expectedAssignmentId;

    @override
    int get hashCode =>
        reason.hashCode +
        (expectedAssignmentId == null ? 0 : expectedAssignmentId.hashCode);

  factory AdminNoteIn.fromJson(Map<String, dynamic> json) => _$AdminNoteInFromJson(json);

  Map<String, dynamic> toJson() => _$AdminNoteInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

