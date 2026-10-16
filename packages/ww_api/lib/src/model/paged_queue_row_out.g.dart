// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_queue_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedQueueRowOutCWProxy {
  PagedQueueRowOut items(List<QueueRowOut> items);

  PagedQueueRowOut count(int count);

  PagedQueueRowOut page(int page);

  PagedQueueRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedQueueRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedQueueRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedQueueRowOut call({
    List<QueueRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedQueueRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedQueueRowOut.copyWith.fieldName(...)`
class _$PagedQueueRowOutCWProxyImpl implements _$PagedQueueRowOutCWProxy {
  const _$PagedQueueRowOutCWProxyImpl(this._value);

  final PagedQueueRowOut _value;

  @override
  PagedQueueRowOut items(List<QueueRowOut> items) => this(items: items);

  @override
  PagedQueueRowOut count(int count) => this(count: count);

  @override
  PagedQueueRowOut page(int page) => this(page: page);

  @override
  PagedQueueRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedQueueRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedQueueRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedQueueRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedQueueRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<QueueRowOut>,
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

extension $PagedQueueRowOutCopyWith on PagedQueueRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedQueueRowOut.copyWith(...)` or like so:`instanceOfPagedQueueRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedQueueRowOutCWProxy get copyWith => _$PagedQueueRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedQueueRowOut _$PagedQueueRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedQueueRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedQueueRowOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => QueueRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedQueueRowOutToJson(PagedQueueRowOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
