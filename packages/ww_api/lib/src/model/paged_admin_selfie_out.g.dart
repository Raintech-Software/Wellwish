// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_selfie_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminSelfieOutCWProxy {
  PagedAdminSelfieOut items(List<AdminSelfieOut> items);

  PagedAdminSelfieOut count(int count);

  PagedAdminSelfieOut page(int page);

  PagedAdminSelfieOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminSelfieOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminSelfieOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminSelfieOut call({
    List<AdminSelfieOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminSelfieOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminSelfieOut.copyWith.fieldName(...)`
class _$PagedAdminSelfieOutCWProxyImpl implements _$PagedAdminSelfieOutCWProxy {
  const _$PagedAdminSelfieOutCWProxyImpl(this._value);

  final PagedAdminSelfieOut _value;

  @override
  PagedAdminSelfieOut items(List<AdminSelfieOut> items) => this(items: items);

  @override
  PagedAdminSelfieOut count(int count) => this(count: count);

  @override
  PagedAdminSelfieOut page(int page) => this(page: page);

  @override
  PagedAdminSelfieOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminSelfieOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminSelfieOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminSelfieOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminSelfieOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminSelfieOut>,
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

extension $PagedAdminSelfieOutCopyWith on PagedAdminSelfieOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminSelfieOut.copyWith(...)` or like so:`instanceOfPagedAdminSelfieOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminSelfieOutCWProxy get copyWith =>
      _$PagedAdminSelfieOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminSelfieOut _$PagedAdminSelfieOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAdminSelfieOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAdminSelfieOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminSelfieOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAdminSelfieOutToJson(
  PagedAdminSelfieOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
