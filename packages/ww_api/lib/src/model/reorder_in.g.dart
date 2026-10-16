// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReorderInCWProxy {
  ReorderIn ids(List<String> ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderIn call({List<String> ids});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReorderIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReorderIn.copyWith.fieldName(...)`
class _$ReorderInCWProxyImpl implements _$ReorderInCWProxy {
  const _$ReorderInCWProxyImpl(this._value);

  final ReorderIn _value;

  @override
  ReorderIn ids(List<String> ids) => this(ids: ids);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReorderIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReorderIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ReorderIn call({Object? ids = const $CopyWithPlaceholder()}) {
    return ReorderIn(
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>,
    );
  }
}

extension $ReorderInCopyWith on ReorderIn {
  /// Returns a callable class that can be used as follows: `instanceOfReorderIn.copyWith(...)` or like so:`instanceOfReorderIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReorderInCWProxy get copyWith => _$ReorderInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderIn _$ReorderInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReorderIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['ids']);
      final val = ReorderIn(
        ids: $checkedConvert(
          'ids',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReorderInToJson(ReorderIn instance) => <String, dynamic>{
  'ids': instance.ids,
};
