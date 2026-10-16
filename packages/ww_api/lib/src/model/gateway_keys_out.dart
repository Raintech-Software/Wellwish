//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gateway_keys_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class GatewayKeysOut {
  /// Returns a new [GatewayKeysOut] instance.
  GatewayKeysOut({

    required  this.source_,

    required  this.keyId,

    required  this.mode,

    required  this.keySecretSet,

    required  this.keySecretLast4,

    required  this.webhookSecretSet,

    required  this.webhookSecretLast4,

    required  this.webhookPath,

    required  this.updatedAt,

    required  this.updatedBy,
  });

      /// ADMIN (entered here), ENVIRONMENT or NONE
  @JsonKey(
    
    name: r'source',
    required: true,
    includeIfNull: false,
  )


  final String source_;



  @JsonKey(
    
    name: r'keyId',
    required: true,
    includeIfNull: false,
  )


  final String keyId;



      /// TEST, LIVE or empty
  @JsonKey(
    
    name: r'mode',
    required: true,
    includeIfNull: false,
  )


  final String mode;



  @JsonKey(
    
    name: r'keySecretSet',
    required: true,
    includeIfNull: false,
  )


  final bool keySecretSet;



  @JsonKey(
    
    name: r'keySecretLast4',
    required: true,
    includeIfNull: false,
  )


  final String keySecretLast4;



  @JsonKey(
    
    name: r'webhookSecretSet',
    required: true,
    includeIfNull: false,
  )


  final bool webhookSecretSet;



  @JsonKey(
    
    name: r'webhookSecretLast4',
    required: true,
    includeIfNull: false,
  )


  final String webhookSecretLast4;



      /// Add this to the API's address in Razorpay
  @JsonKey(
    
    name: r'webhookPath',
    required: true,
    includeIfNull: false,
  )


  final String webhookPath;



  @JsonKey(
    
    name: r'updatedAt',
    required: true,
    includeIfNull: true,
  )


  final DateTime? updatedAt;



  @JsonKey(
    
    name: r'updatedBy',
    required: true,
    includeIfNull: false,
  )


  final String updatedBy;





    @override
    bool operator ==(Object other) => identical(this, other) || other is GatewayKeysOut &&
      other.source_ == source_ &&
      other.keyId == keyId &&
      other.mode == mode &&
      other.keySecretSet == keySecretSet &&
      other.keySecretLast4 == keySecretLast4 &&
      other.webhookSecretSet == webhookSecretSet &&
      other.webhookSecretLast4 == webhookSecretLast4 &&
      other.webhookPath == webhookPath &&
      other.updatedAt == updatedAt &&
      other.updatedBy == updatedBy;

    @override
    int get hashCode =>
        source_.hashCode +
        keyId.hashCode +
        mode.hashCode +
        keySecretSet.hashCode +
        keySecretLast4.hashCode +
        webhookSecretSet.hashCode +
        webhookSecretLast4.hashCode +
        webhookPath.hashCode +
        (updatedAt == null ? 0 : updatedAt.hashCode) +
        updatedBy.hashCode;

  factory GatewayKeysOut.fromJson(Map<String, dynamic> json) => _$GatewayKeysOutFromJson(json);

  Map<String, dynamic> toJson() => _$GatewayKeysOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

