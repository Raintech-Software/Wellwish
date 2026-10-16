//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'google_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GoogleIn {
  /// Returns a new [GoogleIn] instance.
  GoogleIn({

    required  this.idToken,

    required  this.deviceId,
  });

  @JsonKey(
    
    name: r'idToken',
    required: true,
    includeIfNull: false,
  )


  final String idToken;



  @JsonKey(
    
    name: r'deviceId',
    required: true,
    includeIfNull: false,
  )


  final String deviceId;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GoogleIn &&
      other.idToken == idToken &&
      other.deviceId == deviceId;

    @override
    int get hashCode =>
        idToken.hashCode +
        deviceId.hashCode;

  factory GoogleIn.fromJson(Map<String, dynamic> json) => _$GoogleInFromJson(json);

  Map<String, dynamic> toJson() => _$GoogleInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

