//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient_document_filter.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PatientDocumentFilter {
  /// Returns a new [PatientDocumentFilter] instance.
  PatientDocumentFilter({

     this.memberId,

     this.type,

     this.group,
  });

  @JsonKey(
    
    name: r'memberId',
    required: false,
    includeIfNull: false,
  )


  final String? memberId;



  @JsonKey(
    
    name: r'type',
    required: false,
    includeIfNull: false,
  )


  final PatientDocumentFilterTypeEnum? type;



      /// the app's tabs: reports = lab reports, scans, discharge summaries
  @JsonKey(
    
    name: r'group',
    required: false,
    includeIfNull: false,
  )


  final PatientDocumentFilterGroupEnum? group;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PatientDocumentFilter &&
      other.memberId == memberId &&
      other.type == type &&
      other.group == group;

    @override
    int get hashCode =>
        (memberId == null ? 0 : memberId.hashCode) +
        (type == null ? 0 : type.hashCode) +
        (group == null ? 0 : group.hashCode);

  factory PatientDocumentFilter.fromJson(Map<String, dynamic> json) => _$PatientDocumentFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PatientDocumentFilterToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

enum PatientDocumentFilterTypeEnum {
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

const PatientDocumentFilterTypeEnum(this.value);

final String value;

@override
String toString() => value;
}


/// the app's tabs: reports = lab reports, scans, discharge summaries
enum PatientDocumentFilterGroupEnum {
@JsonValue(r'reports')
reports(r'reports'),
@JsonValue(r'prescriptions')
prescriptions(r'prescriptions');

const PatientDocumentFilterGroupEnum(this.value);

final String value;

@override
String toString() => value;
}


