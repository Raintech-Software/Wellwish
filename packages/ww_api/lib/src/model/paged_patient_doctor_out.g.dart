// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_patient_doctor_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PagedPatientDoctorOutCWProxy {
  PagedPatientDoctorOut items(List<PatientDoctorOut> items);

  PagedPatientDoctorOut count(int count);

  PagedPatientDoctorOut page(int page);

  PagedPatientDoctorOut pageSize(int pageSize);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientDoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientDoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientDoctorOut call({
    List<PatientDoctorOut> items,
    int count,
    int page,
    int pageSize,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPagedPatientDoctorOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPagedPatientDoctorOut.copyWith.fieldName(...)`
class _$PagedPatientDoctorOutCWProxyImpl
    implements _$PagedPatientDoctorOutCWProxy {
  const _$PagedPatientDoctorOutCWProxyImpl(this._value);

  final PagedPatientDoctorOut _value;

  @override
  PagedPatientDoctorOut items(List<PatientDoctorOut> items) =>
      this(items: items);

  @override
  PagedPatientDoctorOut count(int count) => this(count: count);

  @override
  PagedPatientDoctorOut page(int page) => this(page: page);

  @override
  PagedPatientDoctorOut pageSize(int pageSize) => this(pageSize: pageSize);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PagedPatientDoctorOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PagedPatientDoctorOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PagedPatientDoctorOut call({
    Object? items = const $CopyWithPlaceholder(),
    Object? count = const $CopyWithPlaceholder(),
    Object? page = const $CopyWithPlaceholder(),
    Object? pageSize = const $CopyWithPlaceholder(),
  }) {
    return PagedPatientDoctorOut(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PatientDoctorOut>,
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

extension $PagedPatientDoctorOutCopyWith on PagedPatientDoctorOut {
  /// Returns a callable class that can be used as follows: `instanceOfPagedPatientDoctorOut.copyWith(...)` or like so:`instanceOfPagedPatientDoctorOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PagedPatientDoctorOutCWProxy get copyWith =>
      _$PagedPatientDoctorOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedPatientDoctorOut _$PagedPatientDoctorOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PagedPatientDoctorOut', json, ($checkedConvert) {
  $checkKeys(json, requiredKeys: const ['items', 'count', 'page', 'pageSize']);
  final val = PagedPatientDoctorOut(
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => PatientDoctorOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    count: $checkedConvert('count', (v) => (v as num).toInt()),
    page: $checkedConvert('page', (v) => (v as num).toInt()),
    pageSize: $checkedConvert('pageSize', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$PagedPatientDoctorOutToJson(
  PagedPatientDoctorOut instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'count': instance.count,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
