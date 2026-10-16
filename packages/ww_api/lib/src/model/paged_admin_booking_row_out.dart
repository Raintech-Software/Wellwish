//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/admin_booking_row_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paged_admin_booking_row_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PagedAdminBookingRowOut {
  /// Returns a new [PagedAdminBookingRowOut] instance.
  PagedAdminBookingRowOut({

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


  final List<AdminBookingRowOut> items;



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
    bool operator ==(Object other) => identical(this, other) || other is PagedAdminBookingRowOut &&
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

  factory PagedAdminBookingRowOut.fromJson(Map<String, dynamic> json) => _$PagedAdminBookingRowOutFromJson(json);

  Map<String, dynamic> toJson() => _$PagedAdminBookingRowOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

