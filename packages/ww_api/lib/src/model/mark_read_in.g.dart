// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MarkReadInCWProxy {
  MarkReadIn ids(List<String>? ids);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadIn call({List<String>? ids});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMarkReadIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMarkReadIn.copyWith.fieldName(...)`
class _$MarkReadInCWProxyImpl implements _$MarkReadInCWProxy {
  const _$MarkReadInCWProxyImpl(this._value);

  final MarkReadIn _value;

  @override
  MarkReadIn ids(List<String>? ids) => this(ids: ids);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MarkReadIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MarkReadIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MarkReadIn call({Object? ids = const $CopyWithPlaceholder()}) {
    return MarkReadIn(
      ids: ids == const $CopyWithPlaceholder()
          ? _value.ids
          // ignore: cast_nullable_to_non_nullable
          : ids as List<String>?,
    );
  }
}

extension $MarkReadInCopyWith on MarkReadIn {
  /// Returns a callable class that can be used as follows: `instanceOfMarkReadIn.copyWith(...)` or like so:`instanceOfMarkReadIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MarkReadInCWProxy get copyWith => _$MarkReadInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadIn _$MarkReadInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MarkReadIn', json, ($checkedConvert) {
      final val = MarkReadIn(
        ids: $checkedConvert(
          'ids',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MarkReadInToJson(MarkReadIn instance) =>
    <String, dynamic>{'ids': ?instance.ids};
