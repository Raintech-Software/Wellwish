//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_url_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadUrlIn {
  /// Returns a new [UploadUrlIn] instance.
  UploadUrlIn({

    required  this.purpose,

    required  this.mime,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final UploadUrlInPurposeEnum purpose;



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
    bool operator ==(Object other) => identical(this, other) || other is UploadUrlIn &&
      other.purpose == purpose &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        purpose.hashCode +
        mime.hashCode +
        sizeBytes.hashCode;

  factory UploadUrlIn.fromJson(Map<String, dynamic> json) => _$UploadUrlInFromJson(json);

  Map<String, dynamic> toJson() => _$UploadUrlInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum UploadUrlInPurposeEnum {
@JsonValue(r'hospital_photo')
hospitalPhoto(r'hospital_photo'),
@JsonValue(r'doctor_photo')
doctorPhoto(r'doctor_photo'),
@JsonValue(r'partner_photo')
partnerPhoto(r'partner_photo'),
@JsonValue(r'kyc_document')
kycDocument(r'kyc_document'),
@JsonValue(r'temp_partner_id')
tempPartnerId(r'temp_partner_id');

const UploadUrlInPurposeEnum(this.value);

final String value;

@override
String toString() => value;
}


