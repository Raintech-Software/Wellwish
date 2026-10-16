//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_document_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientDocumentIn {
  /// Returns a new [PatientDocumentIn] instance.
  PatientDocumentIn({

    required  this.fileKey,

    required  this.memberId,

    required  this.type,

    required  this.title,

    required  this.date,
  });

  @JsonKey(
    
    name: r'fileKey',
    required: true,
    includeIfNull: false,
  )


  final String fileKey;



  @JsonKey(
    
    name: r'memberId',
    required: true,
    includeIfNull: false,
  )


  final String memberId;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final PatientDocumentInTypeEnum type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



      /// date on the document, if known
  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: true,
  )


  final DateTime? date;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientDocumentIn &&
      other.fileKey == fileKey &&
      other.memberId == memberId &&
      other.type == type &&
      other.title == title &&
      other.date == date;

    @override
    int get hashCode =>
        fileKey.hashCode +
        memberId.hashCode +
        type.hashCode +
        title.hashCode +
        (date == null ? 0 : date.hashCode);

  factory PatientDocumentIn.fromJson(Map<String, dynamic> json) => _$PatientDocumentInFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDocumentInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PatientDocumentInTypeEnum {
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

const PatientDocumentInTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


