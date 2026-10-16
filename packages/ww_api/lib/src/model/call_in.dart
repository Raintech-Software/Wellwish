//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class CallIn {
  /// Returns a new [CallIn] instance.
  CallIn({

    required  this.to,
  });

  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final CallInToEnum to;





    @override
    bool operator ==(Object other) => identical(this, other) || other is CallIn &&
      other.to == to;

    @override
    int get hashCode =>
        to.hashCode;

  factory CallIn.fromJson(Map<String, dynamic> json) => _$CallInFromJson(json);

  Map<String, dynamic> toJson() => _$CallInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum CallInToEnum {
@JsonValue(r'MEMBER')
MEMBER(r'MEMBER'),
@JsonValue(r'BOOKER')
BOOKER(r'BOOKER');

const CallInToEnum(this.value);

final String value;

@override
String toString() => value;
}


