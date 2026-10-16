//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partner_upload_url_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PartnerUploadUrlIn {
  /// Returns a new [PartnerUploadUrlIn] instance.
  PartnerUploadUrlIn({

    required  this.purpose,

    required  this.mime,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final PartnerUploadUrlInPurposeEnum purpose;



  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;



          // minimum: 0
  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final int sizeBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PartnerUploadUrlIn &&
      other.purpose == purpose &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        purpose.hashCode +
        mime.hashCode +
        sizeBytes.hashCode;

  factory PartnerUploadUrlIn.fromJson(Map<String, dynamic> json) => _$PartnerUploadUrlInFromJson(json);

  Map<String, dynamic> toJson() => _$PartnerUploadUrlInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PartnerUploadUrlInPurposeEnum {
@JsonValue(r'partner_photo')
partnerPhoto(r'partner_photo'),
@JsonValue(r'kyc_document')
kycDocument(r'kyc_document'),
@JsonValue(r'partner_selfie')
partnerSelfie(r'partner_selfie');

const PartnerUploadUrlInPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


