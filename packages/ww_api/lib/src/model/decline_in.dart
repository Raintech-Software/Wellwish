//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'decline_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeclineIn {
  /// Returns a new [DeclineIn] instance.
  DeclineIn({

    required  this.reason,

     this.note = '',
  });

  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final DeclineInReasonEnum reason;



  @JsonKey(
    defaultValue: '',
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeclineIn &&
      other.reason == reason &&
      other.note == note;

    @override
    int get hashCode =>
        reason.hashCode +
        note.hashCode;

  factory DeclineIn.fromJson(Map<String, dynamic> json) => _$DeclineInFromJson(json);

  Map<String, dynamic> toJson() => _$DeclineInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DeclineInReasonEnum {
@JsonValue(r'NOT_AVAILABLE')
NOT_AVAILABLE(r'NOT_AVAILABLE'),
@JsonValue(r'TOO_FAR')
TOO_FAR(r'TOO_FAR'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const DeclineInReasonEnum(this.value);

final String value;

@override
String toString() => value;
}


