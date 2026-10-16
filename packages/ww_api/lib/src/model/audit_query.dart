//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_query.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AuditQuery {
  /// Returns a new [AuditQuery] instance.
  AuditQuery({

     this.staffId,

     this.action = '',

     this.entityType = '',

     this.entityId = '',

     this.from,

     this.to,
  });

  @JsonKey(
    
    name: r'staffId',
    required: false,
    includeIfNull: false,
  )


  final String? staffId;



      /// Starts with, e.g. `service.`
  @JsonKey(
    defaultValue: '',
    name: r'action',
    required: false,
    includeIfNull: false,
  )


  final String? action;



  @JsonKey(
    defaultValue: '',
    name: r'entityType',
    required: false,
    includeIfNull: false,
  )


  final String? entityType;



  @JsonKey(
    defaultValue: '',
    name: r'entityId',
    required: false,
    includeIfNull: false,
  )


  final String? entityId;



      /// IST date, inclusive
  @JsonKey(
    
    name: r'from',
    required: false,
    includeIfNull: false,
  )


  final DateTime? from;



      /// IST date, inclusive
  @JsonKey(
    
    name: r'to',
    required: false,
    includeIfNull: false,
  )


  final DateTime? to;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AuditQuery &&
      other.staffId == staffId &&
      other.action == action &&
      other.entityType == entityType &&
      other.entityId == entityId &&
      other.from == from &&
      other.to == to;

    @override
    int get hashCode =>
        (staffId == null ? 0 : staffId.hashCode) +
        action.hashCode +
        entityType.hashCode +
        entityId.hashCode +
        (from == null ? 0 : from.hashCode) +
        (to == null ? 0 : to.hashCode);

  factory AuditQuery.fromJson(Map<String, dynamic> json) => _$AuditQueryFromJson(json);

  Map<String, dynamic> toJson() => _$AuditQueryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

