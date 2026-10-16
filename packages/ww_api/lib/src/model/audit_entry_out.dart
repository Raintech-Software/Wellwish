//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/audit_staff_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_entry_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditEntryOut {
  /// Returns a new [AuditEntryOut] instance.
  AuditEntryOut({

    required  this.id,

    required  this.at,

     this.staff,

    required  this.action,

    required  this.entityType,

    required  this.entityId,

    required  this.before,

    required  this.after,

    required  this.reason,

    required  this.ip,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final String id;



  @JsonKey(
    
    name: r'at',
    required: true,
    includeIfNull: false,
  )


  final DateTime at;



      /// Empty = the system
  @JsonKey(
    
    name: r'staff',
    required: false,
    includeIfNull: false,
  )


  final AuditStaffOut? staff;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'entityType',
    required: true,
    includeIfNull: false,
  )


  final String entityType;



  @JsonKey(
    
    name: r'entityId',
    required: true,
    includeIfNull: false,
  )


  final String entityId;



  @JsonKey(
    
    name: r'before',
    required: true,
    includeIfNull: true,
  )


  final Map<String, Object>? before;



  @JsonKey(
    
    name: r'after',
    required: true,
    includeIfNull: true,
  )


  final Map<String, Object>? after;



  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;



  @JsonKey(
    
    name: r'ip',
    required: true,
    includeIfNull: true,
  )


  final String? ip;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditEntryOut &&
      other.id == id &&
      other.at == at &&
      other.staff == staff &&
      other.action == action &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.before == before &&
      other.after == after &&
      other.reason == reason &&
      other.ip == ip;

    @override
    int get hashCode =>
        id.hashCode +
        at.hashCode +
        (staff == null ? 0 : staff.hashCode) +
        action.hashCode +
        entityType.hashCode +
        entityId.hashCode +
        (before == null ? 0 : before.hashCode) +
        (after == null ? 0 : after.hashCode) +
        reason.hashCode +
        (ip == null ? 0 : ip.hashCode);

  factory AuditEntryOut.fromJson(Map<String, dynamic> json) => _$AuditEntryOutFromJson(json);

  Map<String, dynamic> toJson() => _$AuditEntryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

