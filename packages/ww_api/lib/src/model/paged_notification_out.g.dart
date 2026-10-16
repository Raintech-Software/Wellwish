// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_notification_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedNotificationOutCWProxy {
  PagedNotificationOut items(List<NotificationOut> items);

  PagedNotificationOut count(int count);

  PagedNotificationOut page(int page);

  PagedNotificationOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedNotificationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedNotificationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedNotificationOut call({
    List<NotificationOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedNotificationOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedNotificationOut.copyWith.fieldName(...)`
class _$PagedNotificationOutCWProxyImpl
    implements _$PagedNotificationOutCWProxy {
  const _$PagedNotificationOutCWProxyImpl(this._value);

  final PagedNotificationOut _value;

  @override
  PagedNotificationOut items(List<NotificationOut> items) => this(items: items);

  @override
  PagedNotificationOut count(int count) => this(count: count);

  @override
  PagedNotificationOut page(int page) => this(page: page);

  @override
  PagedNotificationOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedNotificationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedNotificationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedNotificationOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedNotificationOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<NotificationOut>,
      count: count == const $CopyWithPlaceholder()
          ? _value.count
          // ignore: cast_nullable_to_non_nullable
          : count as int,
      page: page == const $CopyWithPlaceholder()
          ? _value.page
          // ignore: cast_nullable_to_non_nullable
          : page as int,
      pageSize: pageSize == const $CopyWithPlaceholder()
          ? _value.pageSize
          // ignore: cast_nullable_to_non_nullable
          : pageSize as int,
    );
  }
}

extension $PagedNotificationOutCopyWith on PagedNotificationOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedNotificationOut.copyWith(...)` or like so:`instanceOfPagedNotificationOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedNotificationOutCWProxy get copyWith =>
      _$PagedNotificationOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedNotificationOut _$PagedNotificationOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedNotificationOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedNotificationOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => NotificationOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedNotificationOutToJson(
  PagedNotificationOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
