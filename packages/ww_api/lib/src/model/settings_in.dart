//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SettingsIn {
  /// Returns a new [SettingsIn] instance.
  SettingsIn({

    required  this.values,
  });

      /// Only the keys to change, as text
  @JsonKey(
    
    name: r'values',
    required: true,
    includeIfNull: false,
  )


  final Map<String, String> values;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SettingsIn &&
      other.values == values;

    @override
    int get hashCode =>
        values.hashCode;

  factory SettingsIn.fromJson(Map<String, dynamic> json) => _$SettingsInFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

