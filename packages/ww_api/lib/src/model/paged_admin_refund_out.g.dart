// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_refund_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminRefundOutCWProxy {
  PagedAdminRefundOut items(List<AdminRefundOut> items);

  PagedAdminRefundOut count(int count);

  PagedAdminRefundOut page(int page);

  PagedAdminRefundOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminRefundOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminRefundOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminRefundOut call({
    List<AdminRefundOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminRefundOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminRefundOut.copyWith.fieldName(...)`
class _$PagedAdminRefundOutCWProxyImpl implements _$PagedAdminRefundOutCWProxy {
  const _$PagedAdminRefundOutCWProxyImpl(this._value);

  final PagedAdminRefundOut _value;

  @override
  PagedAdminRefundOut items(List<AdminRefundOut> items) => this(items: items);

  @override
  PagedAdminRefundOut count(int count) => this(count: count);

  @override
  PagedAdminRefundOut page(int page) => this(page: page);

  @override
  PagedAdminRefundOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminRefundOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminRefundOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminRefundOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminRefundOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminRefundOut>,
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

extension $PagedAdminRefundOutCopyWith on PagedAdminRefundOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminRefundOut.copyWith(...)` or like so:`instanceOfPagedAdminRefundOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminRefundOutCWProxy get copyWith =>
      _$PagedAdminRefundOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminRefundOut _$PagedAdminRefundOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAdminRefundOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAdminRefundOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminRefundOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAdminRefundOutToJson(
  PagedAdminRefundOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
