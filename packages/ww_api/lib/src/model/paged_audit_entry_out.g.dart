// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_audit_entry_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedAuditEntryOutCWProxy {
  PagedAuditEntryOut items(List<AuditEntryOut> items);

  PagedAuditEntryOut count(int count);

  PagedAuditEntryOut page(int page);

  PagedAuditEntryOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAuditEntryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAuditEntryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAuditEntryOut call({
    List<AuditEntryOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedAuditEntryOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedAuditEntryOut.copyWith.fieldName(...)`
class _$PagedAuditEntryOutCWProxyImpl implements _$PagedAuditEntryOutCWProxy {
  const _$PagedAuditEntryOutCWProxyImpl(this._value);

  final PagedAuditEntryOut _value;

  @override
  PagedAuditEntryOut items(List<AuditEntryOut> items) => this(items: items);

  @override
  PagedAuditEntryOut count(int count) => this(count: count);

  @override
  PagedAuditEntryOut page(int page) => this(page: page);

  @override
  PagedAuditEntryOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedAuditEntryOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedAuditEntryOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedAuditEntryOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedAuditEntryOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<AuditEntryOut>,
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

extension $PagedAuditEntryOutCopyWith on PagedAuditEntryOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedAuditEntryOut.copyWith(...)` or like so:`instanceOfPagedAuditEntryOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedAuditEntryOutCWProxy get copyWith =>
      _$PagedAuditEntryOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedAuditEntryOut _$PagedAuditEntryOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedAuditEntryOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedAuditEntryOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => AuditEntryOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedAuditEntryOutToJson(PagedAuditEntryOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
