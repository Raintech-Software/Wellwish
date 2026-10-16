// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_admin_payment_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAdminPaymentOutCWProxy {
  PagedAdminPaymentOut items(List<AdminPaymentOut> items);

  PagedAdminPaymentOut count(int count);

  PagedAdminPaymentOut page(int page);

  PagedAdminPaymentOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminPaymentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminPaymentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminPaymentOut call({
    List<AdminPaymentOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAdminPaymentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAdminPaymentOut.copyWith.fieldName(...)`
class _$PagedAdminPaymentOutCWProxyImpl
    implements _$PagedAdminPaymentOutCWProxy {
  const _$PagedAdminPaymentOutCWProxyImpl(this._value);

  final PagedAdminPaymentOut _value;

  @override
  PagedAdminPaymentOut items(List<AdminPaymentOut> items) => this(items: items);

  @override
  PagedAdminPaymentOut count(int count) => this(count: count);

  @override
  PagedAdminPaymentOut page(int page) => this(page: page);

  @override
  PagedAdminPaymentOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAdminPaymentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAdminPaymentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAdminPaymentOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAdminPaymentOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AdminPaymentOut>,
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

extension $PagedAdminPaymentOutCopyWith on PagedAdminPaymentOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAdminPaymentOut.copyWith(...)` or like so:`instanceOfPagedAdminPaymentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAdminPaymentOutCWProxy get copyWith =>
      _$PagedAdminPaymentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAdminPaymentOut _$PagedAdminPaymentOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedAdminPaymentOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedAdminPaymentOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AdminPaymentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedAdminPaymentOutToJson(
  PagedAdminPaymentOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
