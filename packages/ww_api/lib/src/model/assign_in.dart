//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assign_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AssignIn {
  /// Returns a new [AssignIn] instance.
  AssignIn({

    required  this.partnerId,

    required  this.expectedAssignmentId,
  });

  @JsonKey(
    
    name: r'partnerId',
    required: true,
    includeIfNull: false,
  )


  final String partnerId;



      /// The open offer the admin saw (null: none). Another admin changed it: 409 OFFER_CHANGED (§6.16)
  @JsonKey(
    
    name: r'expectedAssignmentId',
    required: true,
    includeIfNull: true,
  )


  final String? expectedAssignmentId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AssignIn &&
      other.partnerId == partnerId &&
      other.expectedAssignmentId == expectedAssignmentId;

    @override
    int get hashCode =>
        partnerId.hashCode +
        (expectedAssignmentId == null ? 0 : expectedAssignmentId.hashCode);

  factory AssignIn.fromJson(Map<String, dynamic> json) => _$AssignInFromJson(json);

  Map<String, dynamic> toJson() => _$AssignInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

