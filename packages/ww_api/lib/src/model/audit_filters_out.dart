//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/audit_staff_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_filters_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditFiltersOut {
  /// Returns a new [AuditFiltersOut] instance.
  AuditFiltersOut({

    required  this.actions,

    required  this.entityTypes,

    required  this.staff,
  });

  @JsonKey(
    
    name: r'actions',
    required: true,
    includeIfNull: false,
  )


  final List<String> actions;



  @JsonKey(
    
    name: r'entityTypes',
    required: true,
    includeIfNull: false,
  )


  final List<String> entityTypes;



  @JsonKey(
    
    name: r'staff',
    required: true,
    includeIfNull: false,
  )


  final List<AuditStaffOut> staff;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditFiltersOut &&
      other.actions == actions &&
      other.entityTypes == entityTypes &&
      other.staff == staff;

    @override
    int get hashCode =>
        actions.hashCode +
        entityTypes.hashCode +
        staff.hashCode;

  factory AuditFiltersOut.fromJson(Map<String, dynamic> json) => _$AuditFiltersOutFromJson(json);

  Map<String, dynamic> toJson() => _$AuditFiltersOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

