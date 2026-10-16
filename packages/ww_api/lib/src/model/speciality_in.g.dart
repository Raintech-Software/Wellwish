// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speciality_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SpecialityInCWProxy {
  SpecialityIn name(String name);

  SpecialityIn nameHi(String? nameHi);

  SpecialityIn nameOr(String? nameOr);

  SpecialityIn icon(String? icon);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpecialityIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpecialityIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SpecialityIn call({
    String name,
    String? nameHi,
    String? nameOr,
    String? icon,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpecialityIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpecialityIn.copyWith.fieldName(...)`
class _$SpecialityInCWProxyImpl implements _$SpecialityInCWProxy {
  const _$SpecialityInCWProxyImpl(this._value);

  final SpecialityIn _value;

  @override
  SpecialityIn name(String name) => this(name: name);

  @override
  SpecialityIn nameHi(String? nameHi) => this(nameHi: nameHi);

  @override
  SpecialityIn nameOr(String? nameOr) => this(nameOr: nameOr);

  @override
  SpecialityIn icon(String? icon) => this(icon: icon);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpecialityIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpecialityIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SpecialityIn call({
    Object? name = const $CopyWithPlaceholder(),
    Object? nameHi = const $CopyWithPlaceholder(),
    Object? nameOr = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
  }) {
    return SpecialityIn(
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      nameHi: nameHi == const $CopyWithPlaceholder()
          ? _value.nameHi
          // ignore: cast_nullable_to_non_nullable
          : nameHi as String?,
      nameOr: nameOr == const $CopyWithPlaceholder()
          ? _value.nameOr
          // ignore: cast_nullable_to_non_nullable
          : nameOr as String?,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String?,
    );
  }
}

extension $SpecialityInCopyWith on SpecialityIn {
  /// Returns a callable class that can be used as follows: `instanceOfSpecialityIn.copyWith(...)` or like so:`instanceOfSpecialityIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpecialityInCWProxy get copyWith => _$SpecialityInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialityIn _$SpecialityInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SpecialityIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['name']);
      final val = SpecialityIn(
        name: $checkedConvert('name', (v) => v as String),
        nameHi: $checkedConvert('nameHi', (v) => v as String? ?? ''),
        nameOr: $checkedConvert('nameOr', (v) => v as String? ?? ''),
        icon: $checkedConvert('icon', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$SpecialityInToJson(SpecialityIn instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameHi': ?instance.nameHi,
      'nameOr': ?instance.nameOr,
      'icon': ?instance.icon,
    };
