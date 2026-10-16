// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_patient_document_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedPatientDocumentOutCWProxy {
  PagedPatientDocumentOut items(List<PatientDocumentOut> items);

  PagedPatientDocumentOut count(int count);

  PagedPatientDocumentOut page(int page);

  PagedPatientDocumentOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientDocumentOut call({
    List<PatientDocumentOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedPatientDocumentOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedPatientDocumentOut.copyWith.fieldName(...)`
class _$PagedPatientDocumentOutCWProxyImpl
    implements _$PagedPatientDocumentOutCWProxy {
  const _$PagedPatientDocumentOutCWProxyImpl(this._value);

  final PagedPatientDocumentOut _value;

  @override
  PagedPatientDocumentOut items(List<PatientDocumentOut> items) =>
      this(items: items);

  @override
  PagedPatientDocumentOut count(int count) => this(count: count);

  @override
  PagedPatientDocumentOut page(int page) => this(page: page);

  @override
  PagedPatientDocumentOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientDocumentOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientDocumentOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientDocumentOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedPatientDocumentOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PatientDocumentOut>,
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

extension $PagedPatientDocumentOutCopyWith on PagedPatientDocumentOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedPatientDocumentOut.copyWith(...)` or like so:`instanceOfPagedPatientDocumentOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedPatientDocumentOutCWProxy get copyWith =>
      _$PagedPatientDocumentOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedPatientDocumentOut _$PagedPatientDocumentOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedPatientDocumentOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedPatientDocumentOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => PatientDocumentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedPatientDocumentOutToJson(
  PagedPatientDocumentOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
