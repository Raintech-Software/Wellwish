//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consent_needed_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConsentNeededOut {
  /// Returns a new [ConsentNeededOut] instance.
  ConsentNeededOut({

    required  this.type,

    required  this.version,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final ConsentNeededOutTypeEnum type;



  @JsonKey(
    
    name: r'version',
    required: true,
    includeIfNull: false,
  )


  final String version;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConsentNeededOut &&
      other.type == type &&
      other.version == version;

    @override
    int get hashCode =>
        type.hashCode +
        version.hashCode;

  factory ConsentNeededOut.fromJson(Map<String, dynamic> json) => _$ConsentNeededOutFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentNeededOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum ConsentNeededOutTypeEnum {
@JsonValue(r'TERMS')
TERMS(r'TERMS'),
@JsonValue(r'PRIVACY')
PRIVACY(r'PRIVACY'),
@JsonValue(r'HEALTH_DATA')
HEALTH_DATA(r'HEALTH_DATA'),
@JsonValue(r'PARTNER_TERMS')
PARTNER_TERMS(r'PARTNER_TERMS');

const ConsentNeededOutTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


