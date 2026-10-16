//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'force_logout_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ForceLogoutOut {
  /// Returns a new [ForceLogoutOut] instance.
  ForceLogoutOut({

    required  this.sessionsEnded,
  });

  @JsonKey(
    
    name: r'sessionsEnded',
    required: true,
    includeIfNull: false,
  )


  final int sessionsEnded;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ForceLogoutOut &&
      other.sessionsEnded == sessionsEnded;

    @override
    int get hashCode =>
        sessionsEnded.hashCode;

  factory ForceLogoutOut.fromJson(Map<String, dynamic> json) => _$ForceLogoutOutFromJson(json);

  Map<String, dynamic> toJson() => _$ForceLogoutOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

