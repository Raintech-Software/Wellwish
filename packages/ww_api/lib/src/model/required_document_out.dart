//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'required_document_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequiredDocumentOut {
  /// Returns a new [RequiredDocumentOut] instance.
  RequiredDocumentOut({

    required  this.id,

    required  this.role,

    required  this.docType,

    required  this.label,

    required  this.labelHi,

    required  this.labelOr,

    required  this.help,

     this.helpHi = '',

     this.helpOr = '',

    required  this.mandatory,

    required  this.condition,

     this.conditionHi = '',

     this.conditionOr = '',

    required  this.hasExpiry,

    required  this.numberRule,

    required  this.cameraOnly,

    required  this.sort,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'docType',
    required: true,
    includeIfNull: false,
  )


  final String docType;



  @JsonKey(
    
    name: r'label',
    required: true,
    includeIfNull: false,
  )


  final String label;



  @JsonKey(
    
    name: r'labelHi',
    required: true,
    includeIfNull: false,
  )


  final String labelHi;



  @JsonKey(
    
    name: r'labelOr',
    required: true,
    includeIfNull: false,
  )


  final String labelOr;



  @JsonKey(
    
    name: r'help',
    required: true,
    includeIfNull: false,
  )


  final String help;



      /// The hint in Hindi, when the admin gave one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'helpHi',
    required: false,
    includeIfNull: false,
  )


  final String? helpHi;



      /// The hint in Odia, when the admin gave one (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'helpOr',
    required: false,
    includeIfNull: false,
  )


  final String? helpOr;



  @JsonKey(
    
    name: r'mandatory',
    required: true,
    includeIfNull: false,
  )


  final bool mandatory;



  @JsonKey(
    
    name: r'condition',
    required: true,
    includeIfNull: false,
  )


  final String condition;



      /// The condition in Hindi (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'conditionHi',
    required: false,
    includeIfNull: false,
  )


  final String? conditionHi;



      /// The condition in Odia (9.1)
  @JsonKey(
    defaultValue: '',
    name: r'conditionOr',
    required: false,
    includeIfNull: false,
  )


  final String? conditionOr;



  @JsonKey(
    
    name: r'hasExpiry',
    required: true,
    includeIfNull: false,
  )


  final bool hasExpiry;



      /// NONE · AADHAAR · PAN · TEXT
  @JsonKey(
    
    name: r'numberRule',
    required: true,
    includeIfNull: false,
  )


  final String numberRule;



  @JsonKey(
    
    name: r'cameraOnly',
    required: true,
    includeIfNull: false,
  )


  final bool cameraOnly;



  @JsonKey(
    
    name: r'sort',
    required: true,
    includeIfNull: false,
  )


  final int sort;



  @JsonKey(
    
    name: r'isActive',
    required: true,
    includeIfNull: false,
  )


  final bool isActive;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RequiredDocumentOut &&
      other.id == id &&
      other.role == role &&
      other.docType == docType &&
      other.label == label &&
      other.labelHi == labelHi &&
      other.labelOr == labelOr &&
      other.help == help &&
      other.helpHi == helpHi &&
      other.helpOr == helpOr &&
      other.mandatory == mandatory &&
      other.condition == condition &&
      other.conditionHi == conditionHi &&
      other.conditionOr == conditionOr &&
      other.hasExpiry == hasExpiry &&
      other.numberRule == numberRule &&
      other.cameraOnly == cameraOnly &&
      other.sort == sort &&
      other.isActive == isActive;

    @override
    int get hashCode =>
        id.hashCode +
        role.hashCode +
        docType.hashCode +
        label.hashCode +
        labelHi.hashCode +
        labelOr.hashCode +
        help.hashCode +
        helpHi.hashCode +
        helpOr.hashCode +
        mandatory.hashCode +
        condition.hashCode +
        conditionHi.hashCode +
        conditionOr.hashCode +
        hasExpiry.hashCode +
        numberRule.hashCode +
        cameraOnly.hashCode +
        sort.hashCode +
        isActive.hashCode;

  factory RequiredDocumentOut.fromJson(Map<String, dynamic> json) => _$RequiredDocumentOutFromJson(json);

  Map<String, dynamic> toJson() => _$RequiredDocumentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

