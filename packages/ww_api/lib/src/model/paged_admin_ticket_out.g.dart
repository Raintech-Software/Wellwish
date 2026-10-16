// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_ticket_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminTicketOutCWProxy {
  PagedAdminTicketOut items(List<AdminTicketOut> items);

  PagedAdminTicketOut count(int count);

  PagedAdminTicketOut page(int page);

  PagedAdminTicketOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminTicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminTicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminTicketOut call({
    List<AdminTicketOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminTicketOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminTicketOut.copyWith.fieldName(...)`
class _$PagedAdminTicketOutCWProxyImpl implements _$PagedAdminTicketOutCWProxy {
  const _$PagedAdminTicketOutCWProxyImpl(this._value);

  final PagedAdminTicketOut _value;

  @override
  PagedAdminTicketOut items(List<AdminTicketOut> items) => this(items: items);

  @override
  PagedAdminTicketOut count(int count) => this(count: count);

  @override
  PagedAdminTicketOut page(int page) => this(page: page);

  @override
  PagedAdminTicketOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminTicketOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminTicketOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminTicketOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminTicketOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminTicketOut>,
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

extension $PagedAdminTicketOutCopyWith on PagedAdminTicketOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminTicketOut.copyWith(...)` or like so:`instanceOfPagedAdminTicketOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminTicketOutCWProxy get copyWith =>
      _$PagedAdminTicketOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminTicketOut _$PagedAdminTicketOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAdminTicketOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAdminTicketOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AdminTicketOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAdminTicketOutToJson(
  PagedAdminTicketOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
