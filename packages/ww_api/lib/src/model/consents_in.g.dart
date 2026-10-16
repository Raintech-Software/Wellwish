// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consents_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ConsentsInCWProxy {
  ConsentsIn items(List<ConsentItemIn> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentsIn call({List<ConsentItemIn> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfConsentsIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfConsentsIn.copyWith.fieldName(...)`
class _$ConsentsInCWProxyImpl implements _$ConsentsInCWProxy {
  const _$ConsentsInCWProxyImpl(this._value);

  final ConsentsIn _value;

  @override
  ConsentsIn items(List<ConsentItemIn> items) => this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ConsentsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ConsentsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  ConsentsIn call({Object? items = const $CopyWithPlaceholder()}) {
    return ConsentsIn(
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ConsentItemIn>,
    );
  }
}

extension $ConsentsInCopyWith on ConsentsIn {
  /// Returns a callable class that can be used as follows: `instanceOfConsentsIn.copyWith(...)` or like so:`instanceOfConsentsIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ConsentsInCWProxy get copyWith => _$ConsentsInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsentsIn _$ConsentsInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ConsentsIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = ConsentsIn(
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => ConsentItemIn.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ConsentsInToJson(ConsentsIn instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
