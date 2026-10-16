//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_url_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadUrlOut {
  /// Returns a new [UploadUrlOut] instance.
  UploadUrlOut({

    required  this.fileKey,

    required  this.uploadUrl,

    required  this.uploadFields,

    required  this.mime,

    required  this.maxBytes,
  });

      /// Send this with the form after uploading
  @JsonKey(
    
    name: r'fileKey',
    required: true,
    includeIfNull: false,
  )


  final String fileKey;



      /// POST the file here as multipart/form-data: every upload field first, then the file as `file` (/path = on this API). The storage refuses a bigger file.
  @JsonKey(
    
    name: r'uploadUrl',
    required: true,
    includeIfNull: false,
  )


  final String uploadUrl;



      /// Form fields to send before the file, unchanged (the signed policy)
  @JsonKey(
    
    name: r'uploadFields',
    required: true,
    includeIfNull: false,
  )


  final Map<String, String> uploadFields;



  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;



  @JsonKey(
    
    name: r'maxBytes',
    required: true,
    includeIfNull: false,
  )


  final int maxBytes;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadUrlOut &&
      other.fileKey == fileKey &&
      other.uploadUrl == uploadUrl &&
      other.uploadFields == uploadFields &&
      other.mime == mime &&
      other.maxBytes == maxBytes;

    @override
    int get hashCode =>
        fileKey.hashCode +
        uploadUrl.hashCode +
        uploadFields.hashCode +
        mime.hashCode +
        maxBytes.hashCode;

  factory UploadUrlOut.fromJson(Map<String, dynamic> json) => _$UploadUrlOutFromJson(json);

  Map<String, dynamic> toJson() => _$UploadUrlOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

