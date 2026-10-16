//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/setting_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_group_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SettingsGroupOut {
  /// Returns a new [SettingsGroupOut] instance.
  SettingsGroupOut({

    required  this.name,

    required  this.settings,
  });

  @JsonKey(
    
    name: r'name',
    required: true,
    includeIfNull: false,
  )


  final String name;



  @JsonKey(
    
    name: r'settings',
    required: true,
    includeIfNull: false,
  )


  final List<SettingOut> settings;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SettingsGroupOut &&
      other.name == name &&
      other.settings == settings;

    @override
    int get hashCode =>
        name.hashCode +
        settings.hashCode;

  factory SettingsGroupOut.fromJson(Map<String, dynamic> json) => _$SettingsGroupOutFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsGroupOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

