//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'deletion_request_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeletionRequestOut {
  /// Returns a new [DeletionRequestOut] instance.
  DeletionRequestOut({

    required  this.dueAt,
  });

      /// the data is removed after this time
  @JsonKey(
    
    name: r'dueAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime dueAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeletionRequestOut &&
      other.dueAt == dueAt;

    @override
    int get hashCode =>
        dueAt.hashCode;

  factory DeletionRequestOut.fromJson(Map<String, dynamic> json) => _$DeletionRequestOutFromJson(json);

  Map<String, dynamic> toJson() => _$DeletionRequestOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

