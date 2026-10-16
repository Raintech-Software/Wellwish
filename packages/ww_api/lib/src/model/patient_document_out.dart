//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_document_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientDocumentOut {
  /// Returns a new [PatientDocumentOut] instance.
  PatientDocumentOut({

    required  this.id,

    required  this.memberId,

    required  this.memberName,

    required  this.type,

    required  this.title,

    required  this.date,

    required  this.mime,

    required  this.sizeBytes,

    required  this.createdAt,

     this.text = '',

     this.vitals,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'memberId',
    required: true,
    includeIfNull: false,
  )


  final String memberId;



  @JsonKey(
    
    name: r'memberName',
    required: true,
    includeIfNull: false,
  )


  final String memberName;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;



  @JsonKey(
    
    name: r'title',
    required: true,
    includeIfNull: false,
  )


  final String title;



  @JsonKey(
    
    name: r'date',
    required: true,
    includeIfNull: true,
  )


  final DateTime? date;



  @JsonKey(
    
    name: r'mime',
    required: true,
    includeIfNull: false,
  )


  final String mime;



  @JsonKey(
    
    name: r'sizeBytes',
    required: true,
    includeIfNull: false,
  )


  final int sizeBytes;



  @JsonKey(
    
    name: r'createdAt',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;



      /// CARE_NOTE only: the nurse's note (no file to open)
  @JsonKey(
    defaultValue: '',
    name: r'text',
    required: false,
    includeIfNull: false,
  )


  final String? text;



      /// CARE_NOTE only: BP, pulse, ...
  @JsonKey(
    
    name: r'vitals',
    required: false,
    includeIfNull: false,
  )


  final Map<String, Object>? vitals;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientDocumentOut &&
      other.id == id &&
      other.memberId == memberId &&
      other.memberName == memberName &&
      other.type == type &&
      other.title == title &&
      other.date == date &&
      other.mime == mime &&
      other.sizeBytes == sizeBytes &&
      other.createdAt == createdAt &&
      other.text == text &&
      other.vitals == vitals;

    @override
    int get hashCode =>
        id.hashCode +
        memberId.hashCode +
        memberName.hashCode +
        type.hashCode +
        title.hashCode +
        (date == null ? 0 : date.hashCode) +
        mime.hashCode +
        sizeBytes.hashCode +
        createdAt.hashCode +
        text.hashCode +
        (vitals == null ? 0 : vitals.hashCode);

  factory PatientDocumentOut.fromJson(Map<String, dynamic> json) => _$PatientDocumentOutFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDocumentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

