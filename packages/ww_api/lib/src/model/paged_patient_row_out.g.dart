// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_patient_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedPatientRowOutCWProxy {
  PagedPatientRowOut items(List<PatientRowOut> items);

  PagedPatientRowOut count(int count);

  PagedPatientRowOut page(int page);

  PagedPatientRowOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientRowOut call({
    List<PatientRowOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedPatientRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedPatientRowOut.copyWith.fieldName(...)`
class _$PagedPatientRowOutCWProxyImpl implements _$PagedPatientRowOutCWProxy {
  const _$PagedPatientRowOutCWProxyImpl(this._value);

  final PagedPatientRowOut _value;

  @override
  PagedPatientRowOut items(List<PatientRowOut> items) => this(items: items);

  @override
  PagedPatientRowOut count(int count) => this(count: count);

  @override
  PagedPatientRowOut page(int page) => this(page: page);

  @override
  PagedPatientRowOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientRowOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedPatientRowOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PatientRowOut>,
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

extension $PagedPatientRowOutCopyWith on PagedPatientRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedPatientRowOut.copyWith(...)` or like so:`instanceOfPagedPatientRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedPatientRowOutCWProxy get copyWith =>
      _$PagedPatientRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedPatientRowOut _$PagedPatientRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PagedPatientRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['items', 'count', 'page', 'pageSize'],
      );
      final val = PagedPatientRowOut(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => PatientRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        page: $checkedConvert('page', (v) => (v as num).toInt()),
        pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PagedPatientRowOutToJson(PagedPatientRowOut instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'count': instance.count,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
