//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consent_item_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConsentItemIn {
  /// Returns a new [ConsentItemIn] instance.
  ConsentItemIn({

    required  this.type,

    required  this.version,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final ConsentItemInTypeEnum type;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConsentItemIn &&
      other.type == type &&
      other.version == version;

    @override
    int get hashCode =>
        type.hashCode +
        version.hashCode;

  factory ConsentItemIn.fromJson(Map<String, dynamic> json) => _$ConsentItemInFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentItemInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ConsentItemInTypeEnum {
@JsonValue(r'TERMS')
TERMS(r'TERMS'),
@JsonValue(r'PRIVACY')
PRIVACY(r'PRIVACY'),
@JsonValue(r'HEALTH_DATA')
HEALTH_DATA(r'HEALTH_DATA'),
@JsonValue(r'PARTNER_TERMS')
PARTNER_TERMS(r'PARTNER_TERMS');

const ConsentItemInTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


