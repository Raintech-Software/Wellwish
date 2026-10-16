//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DeviceIn {
  /// Returns a new [DeviceIn] instance.
  DeviceIn({

    required  this.deviceId,

    required  this.platform,

    required  this.appVersion,

     this.fcmToken = '',
  });

  @JsonKey(
    
    name: r'deviceId',
    required: true,
    includeIfNull: false,
  )


  final String deviceId;



  @JsonKey(
    
    name: r'platform',
    required: true,
    includeIfNull: false,
  )


  final DeviceInPlatformEnum platform;



  @JsonKey(
    
    name: r'appVersion',
    required: true,
    includeIfNull: false,
  )


  final String appVersion;



  @JsonKey(
    defaultValue: '',
    name: r'fcmToken',
    required: false,
    includeIfNull: false,
  )


  final String? fcmToken;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DeviceIn &&
      other.deviceId == deviceId &&
      other.platform == platform &&
      other.appVersion == appVersion &&
      other.fcmToken == fcmToken;

    @override
    int get hashCode =>
        deviceId.hashCode +
        platform.hashCode +
        appVersion.hashCode +
        fcmToken.hashCode;

  factory DeviceIn.fromJson(Map<String, dynamic> json) => _$DeviceInFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DeviceInPlatformEnum {
@JsonValue(r'android')
android(r'android'),
@JsonValue(r'ios')
ios(r'ios');

const DeviceInPlatformEnum(this.value);

final String value;

@override
String toString() => value;
}


