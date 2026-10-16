// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_sos_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminSosOutCWProxy {
  PagedAdminSosOut items(List<AdminSosOut> items);

  PagedAdminSosOut count(int count);

  PagedAdminSosOut page(int page);

  PagedAdminSosOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminSosOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminSosOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminSosOut call({
    List<AdminSosOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminSosOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminSosOut.copyWith.fieldName(...)`
class _$PagedAdminSosOutCWProxyImpl implements _$PagedAdminSosOutCWProxy {
  const _$PagedAdminSosOutCWProxyImpl(this._value);

  final PagedAdminSosOut _value;

  @override
  PagedAdminSosOut items(List<AdminSosOut> items) => this(items: items);

  @override
  PagedAdminSosOut count(int count) => this(count: count);

  @override
  PagedAdminSosOut page(int page) => this(page: page);

  @override
  PagedAdminSosOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminSosOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminSosOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminSosOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminSosOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminSosOut>,
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

extension $PagedAdminSosOutCopyWith on PagedAdminSosOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminSosOut.copyWith(...)` or like so:`instanceOfPagedAdminSosOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminSosOutCWProxy get copyWith => _$PagedAdminSosOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminSosOut _$PagedAdminSosOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAdminSosOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAdminSosOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminSosOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAdminSosOutToJson(PagedAdminSosOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
