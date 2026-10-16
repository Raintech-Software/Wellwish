//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:ww_api/src/model/notification_out.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paged_notification_out.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PagedNotificationOut {
  /// Returns a new [PagedNotificationOut] instance.
  PagedNotificationOut({

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


  final List<NotificationOut> items;



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
    bool operator ==(Object other) => identical(this, other) || other is PagedNotificationOut &&
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

  factory PagedNotificationOut.fromJson(Map<String, dynamic> json) => _$PagedNotificationOutFromJson(json);

  Map<String, dynamic> toJson() => _$PagedNotificationOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

