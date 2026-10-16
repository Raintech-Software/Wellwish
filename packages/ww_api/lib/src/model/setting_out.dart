//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class SettingOut {
  /// Returns a new [SettingOut] instance.
  SettingOut({

    required  this.key,

    required  this.label,

    required  this.kind,

    required  this.value,

    required  this.default_,

    required  this.help,

     this.min,

     this.max,

    required  this.choices,

    required  this.unit,
  });

  @JsonKey(
    
    name: r'key',
    required: true,
    includeIfNull: false,
  )


  final String key;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



      /// int · choice · time · phone · version
  @JsonKey(
    
    name: r'kind',
    required: true,
    includeIfNull: false,
  )


  final String kind;



      /// Always text; kind says how to read it
  @JsonKey(
    
    name: r'value',
    required: true,
    includeIfNull: false,
  )


  final String value;



  @JsonKey(
    
    name: r'default',
    required: true,
    includeIfNull: false,
  )


  final String default_;



  @JsonKey(
    
    name: r'help',
    required: true,
    includeIfNull: false,
  )


  final String help;



  @JsonKey(
    
    name: r'min',
    required: false,
    includeIfNull: false,
  )


  final int? min;



  @JsonKey(
    
    name: r'max',
    required: false,
    includeIfNull: false,
  )


  final int? max;



  @JsonKey(
    
    name: r'choices',
    required: true,
    includeIfNull: false,
  )


  final List<String> choices;



  @JsonKey(
    
    name: r'unit',
    required: true,
    includeIfNull: false,
  )


  final String unit;





    @override
    bool operator ==(Object other) => identical(this, other) || other is SettingOut &&
      other.key == key &&
      other.label == label &&
      other.kind == kind &&
      other.value == value &&
      other.default_ == default_ &&
      other.help == help &&
      other.min == min &&
      other.max == max &&
      other.choices == choices &&
      other.unit == unit;

    @override
    int get hashCode =>
        key.hashCode +
        label.hashCode +
        kind.hashCode +
        value.hashCode +
        default_.hashCode +
        help.hashCode +
        (min == null ? 0 : min.hashCode) +
        (max == null ? 0 : max.hashCode) +
        choices.hashCode +
        unit.hashCode;

  factory SettingOut.fromJson(Map<String, dynamic> json) => _$SettingOutFromJson(json);

  Map<String, dynamic> toJson() => _$SettingOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

