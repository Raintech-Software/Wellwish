// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_partner_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedPartnerRowOutCWProxy {
  PagedPartnerRowOut items(List<PartnerRowOut> items);

  PagedPartnerRowOut count(int count);

  PagedPartnerRowOut page(int page);

  PagedPartnerRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPartnerRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPartnerRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPartnerRowOut call({
    List<PartnerRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedPartnerRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedPartnerRowOut.copyWith.fieldName(...)`
class _$PagedPartnerRowOutCWProxyImpl implements _$PagedPartnerRowOutCWProxy {
  const _$PagedPartnerRowOutCWProxyImpl(this._value);

  final PagedPartnerRowOut _value;

  @override
  PagedPartnerRowOut items(List<PartnerRowOut> items) => this(items: items);

  @override
  PagedPartnerRowOut count(int count) => this(count: count);

  @override
  PagedPartnerRowOut page(int page) => this(page: page);

  @override
  PagedPartnerRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPartnerRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPartnerRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPartnerRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedPartnerRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PartnerRowOut>,
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

extension $PagedPartnerRowOutCopyWith on PagedPartnerRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedPartnerRowOut.copyWith(...)` or like so:`instanceOfPagedPartnerRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedPartnerRowOutCWProxy get copyWith =>
      _$PagedPartnerRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedPartnerRowOut _$PagedPartnerRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedPartnerRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedPartnerRowOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PartnerRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedPartnerRowOutToJson(PagedPartnerRowOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
