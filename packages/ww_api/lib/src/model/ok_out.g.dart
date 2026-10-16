// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ok_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OkOutCWProxy {
  OkOut ok(bool? ok);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OkOut call({bool? ok});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOkOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOkOut.copyWith.fieldName(...)`
class _$OkOutCWProxyImpl implements _$OkOutCWProxy {
  const _$OkOutCWProxyImpl(this._value);

  final OkOut _value;

  @override
  OkOut ok(bool? ok) => this(ok: ok);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OkOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OkOut(...).copyWith(id: 12, name: "My name")
  /// ````
  OkOut call({Object? ok = const $CopyWithPlaceholder()}) {
    return OkOut(
      ok: ok == const $CopyWithPlaceholder()
          ? _value.ok
          // ignore: cast_nullable_to_non_nullable
          : ok as bool?,
    );
  }
}

extension $OkOutCopyWith on OkOut {
  /// Returns a callable class that can be used as follows: `instanceOfOkOut.copyWith(...)` or like so:`instanceOfOkOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OkOutCWProxy get copyWith => _$OkOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OkOut _$OkOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('OkOut', json, ($checkedConvert) {
      final val = OkOut(ok: $checkedConvert('ok', (v) => v as bool? ?? true));
      return val;
    });

Map<String, dynamic> _$OkOutToJson(OkOut instance) => <String, dynamic>{
  'ok': ?instance.ok,
};
