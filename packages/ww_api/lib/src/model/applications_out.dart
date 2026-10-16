//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'applications_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ApplicationsOut {
  /// Returns a new [ApplicationsOut] instance.
  ApplicationsOut({

    required  this.waiting,

     this.oldestAt,
  });

      /// Submitted or under review
  @JsonKey(
    
    name: r'waiting',
    required: true,
    includeIfNull: false,
  )


  final int waiting;



  @JsonKey(
    
    name: r'oldestAt',
    required: false,
    includeIfNull: false,
  )


  final DateTime? oldestAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ApplicationsOut &&
      other.waiting == waiting &&
      other.oldestAt == oldestAt;

    @override
    int get hashCode =>
        waiting.hashCode +
        (oldestAt == null ? 0 : oldestAt.hashCode);

  factory ApplicationsOut.fromJson(Map<String, dynamic> json) => _$ApplicationsOutFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

