// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_review_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminReviewOutCWProxy {
  PagedAdminReviewOut items(List<AdminReviewOut> items);

  PagedAdminReviewOut count(int count);

  PagedAdminReviewOut page(int page);

  PagedAdminReviewOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminReviewOut call({
    List<AdminReviewOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminReviewOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminReviewOut.copyWith.fieldName(...)`
class _$PagedAdminReviewOutCWProxyImpl implements _$PagedAdminReviewOutCWProxy {
  const _$PagedAdminReviewOutCWProxyImpl(this._value);

  final PagedAdminReviewOut _value;

  @override
  PagedAdminReviewOut items(List<AdminReviewOut> items) => this(items: items);

  @override
  PagedAdminReviewOut count(int count) => this(count: count);

  @override
  PagedAdminReviewOut page(int page) => this(page: page);

  @override
  PagedAdminReviewOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminReviewOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminReviewOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminReviewOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminReviewOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminReviewOut>,
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

extension $PagedAdminReviewOutCopyWith on PagedAdminReviewOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminReviewOut.copyWith(...)` or like so:`instanceOfPagedAdminReviewOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminReviewOutCWProxy get copyWith =>
      _$PagedAdminReviewOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminReviewOut _$PagedAdminReviewOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAdminReviewOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAdminReviewOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminReviewOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAdminReviewOutToJson(
  PagedAdminReviewOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
