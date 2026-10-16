//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dev_sms_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DevSmsOut {
  /// Returns a new [DevSmsOut] instance.
  DevSmsOut({

    required  this.at,

    required  this.phone,

    required  this.template,

    required  this.text,
  });

  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



      /// e.g. LOGIN_OTP, JOB_OTP, SOS_ALERT
  @JsonKey(
    
    name: r'template',
    required: true,
    includeIfNull: false,
  )


  final String template;



  @JsonKey(
    
    name: r'text',
    required: true,
    includeIfNull: false,
  )


  final String text;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DevSmsOut &&
      other.at == at &&
      other.phone == phone &&
      other.template == template &&
      other.text == text;

    @override
    int get hashCode =>
        at.hashCode +
        phone.hashCode +
        template.hashCode +
        text.hashCode;

  factory DevSmsOut.fromJson(Map<String, dynamic> json) => _$DevSmsOutFromJson(json);

  Map<String, dynamic> toJson() => _$DevSmsOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

