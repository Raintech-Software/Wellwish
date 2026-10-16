//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'required_document_in.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RequiredDocumentIn {
  /// Returns a new [RequiredDocumentIn] instance.
  RequiredDocumentIn({

    required  this.role,

    required  this.docType,

    required  this.label,

     this.labelHi = '',

     this.labelOr = '',

     this.help = '',

     this.helpHi = '',

     this.helpOr = '',

    required  this.mandatory,

     this.condition = '',

     this.conditionHi = '',

     this.conditionOr = '',

    required  this.hasExpiry,

    required  this.numberRule,

    required  this.cameraOnly,

    required  this.sort,

    required  this.isActive,
  });

  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final RequiredDocumentInRoleEnum role;



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
    defaultValue: '',
    name: r'labelHi',
    required: false,
    includeIfNull: false,
  )


  final String? labelHi;



  @JsonKey(
    defaultValue: '',
    name: r'labelOr',
    required: false,
    includeIfNull: false,
  )


  final String? labelOr;



  @JsonKey(
    defaultValue: '',
    name: r'help',
    required: false,
    includeIfNull: false,
  )


  final String? help;



  @JsonKey(
    defaultValue: '',
    name: r'helpHi',
    required: false,
    includeIfNull: false,
  )


  final String? helpHi;



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
    defaultValue: '',
    name: r'condition',
    required: false,
    includeIfNull: false,
  )


  final String? condition;



  @JsonKey(
    defaultValue: '',
    name: r'conditionHi',
    required: false,
    includeIfNull: false,
  )


  final String? conditionHi;



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



  @JsonKey(
    
    name: r'numberRule',
    required: true,
    includeIfNull: false,
  )


  final RequiredDocumentInNumberRuleEnum numberRule;



  @JsonKey(
    
    name: r'cameraOnly',
    required: true,
    includeIfNull: false,
  )


  final bool cameraOnly;



          // minimum: 0
          // maximum: 1000
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
    bool operator ==(Object other) => identical(this, other) || other is RequiredDocumentIn &&
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

  factory RequiredDocumentIn.fromJson(Map<String, dynamic> json) => _$RequiredDocumentInFromJson(json);

  Map<String, dynamic> toJson() => _$RequiredDocumentInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum RequiredDocumentInRoleEnum {
@JsonValue(r'COMPANION')
COMPANION(r'COMPANION'),
@JsonValue(r'NURSE')
NURSE(r'NURSE');

const RequiredDocumentInRoleEnum(this.value);

final String value;

@override
String toString() => value;
}


enum RequiredDocumentInNumberRuleEnum {
@JsonValue(r'NONE')
NONE(r'NONE'),
@JsonValue(r'AADHAAR')
AADHAAR(r'AADHAAR'),
@JsonValue(r'PAN')
PAN(r'PAN'),
@JsonValue(r'TEXT')
TEXT(r'TEXT');

const RequiredDocumentInNumberRuleEnum(this.value);

final String value;

@override
String toString() => value;
}


