// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_account_deletion_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAccountDeletionOutCWProxy {
  PagedAccountDeletionOut items(List<AccountDeletionOut> items);

  PagedAccountDeletionOut count(int count);

  PagedAccountDeletionOut page(int page);

  PagedAccountDeletionOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAccountDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAccountDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAccountDeletionOut call({
    List<AccountDeletionOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAccountDeletionOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAccountDeletionOut.copyWith.fieldName(...)`
class _$PagedAccountDeletionOutCWProxyImpl
    implements _$PagedAccountDeletionOutCWProxy {
  const _$PagedAccountDeletionOutCWProxyImpl(this._value);

  final PagedAccountDeletionOut _value;

  @override
  PagedAccountDeletionOut items(List<AccountDeletionOut> items) =>
      this(items: items);

  @override
  PagedAccountDeletionOut count(int count) => this(count: count);

  @override
  PagedAccountDeletionOut page(int page) => this(page: page);

  @override
  PagedAccountDeletionOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAccountDeletionOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAccountDeletionOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAccountDeletionOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAccountDeletionOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AccountDeletionOut>,
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

extension $PagedAccountDeletionOutCopyWith on PagedAccountDeletionOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAccountDeletionOut.copyWith(...)` or like so:`instanceOfPagedAccountDeletionOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAccountDeletionOutCWProxy get copyWith =>
      _$PagedAccountDeletionOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAccountDeletionOut _$PagedAccountDeletionOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedAccountDeletionOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedAccountDeletionOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => AccountDeletionOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedAccountDeletionOutToJson(
  PagedAccountDeletionOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
