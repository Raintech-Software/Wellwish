// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_booking_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminBookingRowOutCWProxy {
  PagedAdminBookingRowOut items(List<AdminBookingRowOut> items);

  PagedAdminBookingRowOut count(int count);

  PagedAdminBookingRowOut page(int page);

  PagedAdminBookingRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminBookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminBookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminBookingRowOut call({
    List<AdminBookingRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminBookingRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminBookingRowOut.copyWith.fieldName(...)`
class _$PagedAdminBookingRowOutCWProxyImpl
    implements _$PagedAdminBookingRowOutCWProxy {
  const _$PagedAdminBookingRowOutCWProxyImpl(this._value);

  final PagedAdminBookingRowOut _value;

  @override
  PagedAdminBookingRowOut items(List<AdminBookingRowOut> items) =>
      this(items: items);

  @override
  PagedAdminBookingRowOut count(int count) => this(count: count);

  @override
  PagedAdminBookingRowOut page(int page) => this(page: page);

  @override
  PagedAdminBookingRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminBookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminBookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminBookingRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminBookingRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminBookingRowOut>,
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

extension $PagedAdminBookingRowOutCopyWith on PagedAdminBookingRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminBookingRowOut.copyWith(...)` or like so:`instanceOfPagedAdminBookingRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminBookingRowOutCWProxy get copyWith =>
      _$PagedAdminBookingRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminBookingRowOut _$PagedAdminBookingRowOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedAdminBookingRowOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedAdminBookingRowOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AdminBookingRowOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedAdminBookingRowOutToJson(
  PagedAdminBookingRowOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
