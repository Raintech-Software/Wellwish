//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_upload_url_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentUploadUrlIn {
  /// Returns a new [DocumentUploadUrlIn] instance.
  DocumentUploadUrlIn({

    required  this.type,

    required  this.mime,

    required  this.sizeBytes,
  });

  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final DocumentUploadUrlInTypeEnum type;



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
    bool operator ==(Object other) => identical(this, other) || other is DocumentUploadUrlIn &&
      other.type == type &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes;

    @override
    int get hashCode =>
        type.hashCode +
        mime.hashCode +
        sizeBytes.hashCode;

  factory DocumentUploadUrlIn.fromJson(Map<String, dynamic> json) => _$DocumentUploadUrlInFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentUploadUrlInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum DocumentUploadUrlInTypeEnum {
@JsonValue(r'PRESCRIPTION')
PRESCRIPTION(r'PRESCRIPTION'),
@JsonValue(r'LAB_REPORT')
LAB_REPORT(r'LAB_REPORT'),
@JsonValue(r'SCAN')
SCAN(r'SCAN'),
@JsonValue(r'DISCHARGE')
DISCHARGE(r'DISCHARGE'),
@JsonValue(r'ID')
ID(r'ID'),
@JsonValue(r'OTHER')
OTHER(r'OTHER');

const DocumentUploadUrlInTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


