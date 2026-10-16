//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gateway_keys_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GatewayKeysIn {
  /// Returns a new [GatewayKeysIn] instance.
  GatewayKeysIn({

    required  this.keyId,

     this.keySecret = '',

     this.webhookSecret = '',
  });

  @JsonKey(
    
    name: r'keyId',
    required: true,
    includeIfNull: false,
  )


  final String keyId;



      /// Blank = keep the saved one
  @JsonKey(
    defaultValue: '',
    name: r'keySecret',
    required: false,
    includeIfNull: false,
  )


  final String? keySecret;



      /// Blank = keep the saved one
  @JsonKey(
    defaultValue: '',
    name: r'webhookSecret',
    required: false,
    includeIfNull: false,
  )


  final String? webhookSecret;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GatewayKeysIn &&
      other.keyId == keyId &&
      other.keySecret == keySecret &&
      other.webhookSecret == webhookSecret;

    @override
    int get hashCode =>
        keyId.hashCode +
        keySecret.hashCode +
        webhookSecret.hashCode;

  factory GatewayKeysIn.fromJson(Map<String, dynamic> json) => _$GatewayKeysInFromJson(json);

  Map<String, dynamic> toJson() => _$GatewayKeysInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

