// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_booking_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedBookingRowOutCWProxy {
  PagedBookingRowOut items(List<BookingRowOut> items);

  PagedBookingRowOut count(int count);

  PagedBookingRowOut page(int page);

  PagedBookingRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedBookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedBookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedBookingRowOut call({
    List<BookingRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedBookingRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedBookingRowOut.copyWith.fieldName(...)`
class _$PagedBookingRowOutCWProxyImpl implements _$PagedBookingRowOutCWProxy {
  const _$PagedBookingRowOutCWProxyImpl(this._value);

  final PagedBookingRowOut _value;

  @override
  PagedBookingRowOut items(List<BookingRowOut> items) => this(items: items);

  @override
  PagedBookingRowOut count(int count) => this(count: count);

  @override
  PagedBookingRowOut page(int page) => this(page: page);

  @override
  PagedBookingRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedBookingRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedBookingRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedBookingRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedBookingRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<BookingRowOut>,
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

extension $PagedBookingRowOutCopyWith on PagedBookingRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedBookingRowOut.copyWith(...)` or like so:`instanceOfPagedBookingRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedBookingRowOutCWProxy get copyWith =>
      _$PagedBookingRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedBookingRowOut _$PagedBookingRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedBookingRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedBookingRowOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => BookingRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedBookingRowOutToJson(PagedBookingRowOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
