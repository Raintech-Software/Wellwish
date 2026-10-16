//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/settings_group_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SettingsOut {
  /// Returns a new [SettingsOut] instance.
  SettingsOut({

    required  this.groups,
  });

  @JsonKey(
    
    name: r'groups',
    required: true,
    includeIfNull: false,
  )


  final List<SettingsGroupOut> groups;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SettingsOut &&
      other.groups == groups;

    @override
    int get hashCode =>
        groups.hashCode;

  factory SettingsOut.fromJson(Map<String, dynamic> json) => _$SettingsOutFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

