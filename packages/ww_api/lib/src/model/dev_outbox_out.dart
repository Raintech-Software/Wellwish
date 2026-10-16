//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/dev_sms_out.dart';
import 'package:ww_api/src/model/dev_mail_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dev_outbox_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DevOutboxOut {
  /// Returns a new [DevOutboxOut] instance.
  DevOutboxOut({

    required  this.sms,

    required  this.email,
  });

  @JsonKey(
    
    name: r'sms',
    required: true,
    includeIfNull: false,
  )


  final List<DevSmsOut> sms;



  @JsonKey(
    
    name: r'email',
    required: true,
    includeIfNull: false,
  )


  final List<DevMailOut> email;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DevOutboxOut &&
      other.sms == sms &&
      other.email == email;

    @override
    int get hashCode =>
        sms.hashCode +
        email.hashCode;

  factory DevOutboxOut.fromJson(Map<String, dynamic> json) => _$DevOutboxOutFromJson(json);

  Map<String, dynamic> toJson() => _$DevOutboxOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

