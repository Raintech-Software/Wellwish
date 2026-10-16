// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inside_area_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$InsideAreaOutCWProxy {
  InsideAreaOut inside(bool inside);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InsideAreaOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InsideAreaOut(...).copyWith(id: 12, name: "My name")
  /// ````
  InsideAreaOut call({bool inside});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfInsideAreaOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfInsideAreaOut.copyWith.fieldName(...)`
class _$InsideAreaOutCWProxyImpl implements _$InsideAreaOutCWProxy {
  const _$InsideAreaOutCWProxyImpl(this._value);

  final InsideAreaOut _value;

  @override
  InsideAreaOut inside(bool inside) => this(inside: inside);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `InsideAreaOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// InsideAreaOut(...).copyWith(id: 12, name: "My name")
  /// ````
  InsideAreaOut call({Object? inside = const $CopyWithPlaceholder()}) {
    return InsideAreaOut(
      inside: inside == const $CopyWithPlaceholder()
          ? _value.inside
          // ignore: cast_nullable_to_non_nullable
          : inside as bool,
    );
  }
}

extension $InsideAreaOutCopyWith on InsideAreaOut {
  /// Returns a callable class that can be used as follows: `instanceOfInsideAreaOut.copyWith(...)` or like so:`instanceOfInsideAreaOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$InsideAreaOutCWProxy get copyWith => _$InsideAreaOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsideAreaOut _$InsideAreaOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InsideAreaOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['inside']);
      final val = InsideAreaOut(
        inside: $checkedConvert('inside', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$InsideAreaOutToJson(InsideAreaOut instance) =>
    <String, dynamic>{'inside': instance.inside};
