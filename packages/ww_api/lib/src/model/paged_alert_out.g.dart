// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_alert_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAlertOutCWProxy {
  PagedAlertOut items(List<AlertOut> items);

  PagedAlertOut count(int count);

  PagedAlertOut page(int page);

  PagedAlertOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAlertOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAlertOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAlertOut call({List<AlertOut> items, int count, int page, int pageSize});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAlertOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAlertOut.copyWith.fieldName(...)`
class _$PagedAlertOutCWProxyImpl implements _$PagedAlertOutCWProxy {
  const _$PagedAlertOutCWProxyImpl(this._value);

  final PagedAlertOut _value;

  @override
  PagedAlertOut items(List<AlertOut> items) => this(items: items);

  @override
  PagedAlertOut count(int count) => this(count: count);

  @override
  PagedAlertOut page(int page) => this(page: page);

  @override
  PagedAlertOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAlertOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAlertOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAlertOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAlertOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AlertOut>,
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

extension $PagedAlertOutCopyWith on PagedAlertOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAlertOut.copyWith(...)` or like so:`instanceOfPagedAlertOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAlertOutCWProxy get copyWith => _$PagedAlertOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAlertOut _$PagedAlertOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAlertOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAlertOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AlertOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAlertOutToJson(PagedAlertOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
