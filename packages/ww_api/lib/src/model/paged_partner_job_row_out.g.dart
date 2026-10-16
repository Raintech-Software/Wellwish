// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_partner_job_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedPartnerJobRowOutCWProxy {
  PagedPartnerJobRowOut items(List<PartnerJobRowOut> items);

  PagedPartnerJobRowOut count(int count);

  PagedPartnerJobRowOut page(int page);

  PagedPartnerJobRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPartnerJobRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPartnerJobRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPartnerJobRowOut call({
    List<PartnerJobRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedPartnerJobRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedPartnerJobRowOut.copyWith.fieldName(...)`
class _$PagedPartnerJobRowOutCWProxyImpl
    implements _$PagedPartnerJobRowOutCWProxy {
  const _$PagedPartnerJobRowOutCWProxyImpl(this._value);

  final PagedPartnerJobRowOut _value;

  @override
  PagedPartnerJobRowOut items(List<PartnerJobRowOut> items) =>
      this(items: items);

  @override
  PagedPartnerJobRowOut count(int count) => this(count: count);

  @override
  PagedPartnerJobRowOut page(int page) => this(page: page);

  @override
  PagedPartnerJobRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPartnerJobRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPartnerJobRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPartnerJobRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedPartnerJobRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PartnerJobRowOut>,
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

extension $PagedPartnerJobRowOutCopyWith on PagedPartnerJobRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedPartnerJobRowOut.copyWith(...)` or like so:`instanceOfPagedPartnerJobRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedPartnerJobRowOutCWProxy get copyWith =>
      _$PagedPartnerJobRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedPartnerJobRowOut _$PagedPartnerJobRowOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedPartnerJobRowOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedPartnerJobRowOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => PartnerJobRowOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedPartnerJobRowOutToJson(
  PagedPartnerJobRowOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
