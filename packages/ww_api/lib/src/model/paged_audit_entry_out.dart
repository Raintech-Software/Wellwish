//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/audit_entry_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paged_audit_entry_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PagedAuditEntryOut {
  /// Returns a new [PagedAuditEntryOut] instance.
  PagedAuditEntryOut({

    required  this.items,

    required  this.count,

    required  this.page,

    required  this.pageSize,
  });

  @JsonKey(
    
    name: r'items',
    required: true,
    includeIfNull: false,
  )


  final List<AuditEntryOut> items;



  @JsonKey(
    
    name: r'count',
    required: true,
    includeIfNull: false,
  )


  final int count;



  @JsonKey(
    
    name: r'page',
    required: true,
    includeIfNull: false,
  )


  final int page;



  @JsonKey(
    
    name: r'pageSize',
    required: true,
    includeIfNull: false,
  )


  final int pageSize;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PagedAuditEntryOut &&
      other.items == items &&
      other.count == count &&
      other.page == page &&
      other.pageSize == pageSize;

    @override
    int get hashCode =>
        items.hashCode +
        count.hashCode +
        page.hashCode +
        pageSize.hashCode;

  factory PagedAuditEntryOut.fromJson(Map<String, dynamic> json) => _$PagedAuditEntryOutFromJson(json);

  Map<String, dynamic> toJson() => _$PagedAuditEntryOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

