//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'document_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DocumentIn {
  /// Returns a new [DocumentIn] instance.
  DocumentIn({

    required  this.docType,

    required  this.fileKey,

     this.number = '',

     this.expiresOn,
  });

  @JsonKey(
    
    name: r'docType',
    required: true,
    includeIfNull: false,
  )


  final String docType;



  @JsonKey(
    
    name: r'fileKey',
    required: true,
    includeIfNull: false,
  )


  final String fileKey;



      /// Aadhaar/PAN are stored masked
  @JsonKey(
    defaultValue: '',
    name: r'number',
    required: false,
    includeIfNull: false,
  )


  final String? number;



  @JsonKey(
    
    name: r'expiresOn',
    required: false,
    includeIfNull: false,
  )


  final DateTime? expiresOn;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DocumentIn &&
      other.docType == docType &&
      other.fileKey == fileKey &&
      other.number == number &&
      other.expiresOn == expiresOn;

    @override
    int get hashCode =>
        docType.hashCode +
        fileKey.hashCode +
        number.hashCode +
        (expiresOn == null ? 0 : expiresOn.hashCode);

  factory DocumentIn.fromJson(Map<String, dynamic> json) => _$DocumentInFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

