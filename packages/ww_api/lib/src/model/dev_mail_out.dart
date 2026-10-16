//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dev_mail_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DevMailOut {
  /// Returns a new [DevMailOut] instance.
  DevMailOut({

    required  this.at,

    required  this.to,

    required  this.subject,

    required  this.text,
  });

  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



  @JsonKey(
    
    name: r'to',
    required: true,
    includeIfNull: false,
  )


  final String to;



  @JsonKey(
    
    name: r'subject',
    required: true,
    includeIfNull: false,
  )


  final String subject;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DevMailOut &&
      other.at == at &&
      other.to == to &&
      other.subject == subject &&
      other.text == text;

    @override
    int get hashCode =>
        at.hashCode +
        to.hashCode +
        subject.hashCode +
        text.hashCode;

  factory DevMailOut.fromJson(Map<String, dynamic> json) => _$DevMailOutFromJson(json);

  Map<String, dynamic> toJson() => _$DevMailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

