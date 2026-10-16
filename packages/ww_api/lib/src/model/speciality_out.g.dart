// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speciality_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SpecialityOutCWProxy {
  SpecialityOut id(String id);

  SpecialityOut name(String name);

  SpecialityOut nameHi(String nameHi);

  SpecialityOut nameOr(String nameOr);

  SpecialityOut icon(String icon);

  SpecialityOut doctorCount(int? doctorCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpecialityOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpecialityOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SpecialityOut call({
    String id,
    String name,
    String nameHi,
    String nameOr,
    String icon,
    int? doctorCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSpecialityOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSpecialityOut.copyWith.fieldName(...)`
class _$SpecialityOutCWProxyImpl implements _$SpecialityOutCWProxy {
  const _$SpecialityOutCWProxyImpl(this._value);

  final SpecialityOut _value;

  @override
  SpecialityOut id(String id) => this(id: id);

  @override
  SpecialityOut name(String name) => this(name: name);

  @override
  SpecialityOut nameHi(String nameHi) => this(nameHi: nameHi);

  @override
  SpecialityOut nameOr(String nameOr) => this(nameOr: nameOr);

  @override
  SpecialityOut icon(String icon) => this(icon: icon);

  @override
  SpecialityOut doctorCount(int? doctorCount) => this(doctorCount: doctorCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SpecialityOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SpecialityOut(...).copyWith(id: 12, name: "My name")
  /// ````
  SpecialityOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? nameHi = const $CopyWithPlaceholder(),
    Object? nameOr = const $CopyWithPlaceholder(),
    Object? icon = const $CopyWithPlaceholder(),
    Object? doctorCount = const $CopyWithPlaceholder(),
  }) {
    return SpecialityOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      nameHi: nameHi == const $CopyWithPlaceholder()
          ? _value.nameHi
          // ignore: cast_nullable_to_non_nullable
          : nameHi as String,
      nameOr: nameOr == const $CopyWithPlaceholder()
          ? _value.nameOr
          // ignore: cast_nullable_to_non_nullable
          : nameOr as String,
      icon: icon == const $CopyWithPlaceholder()
          ? _value.icon
          // ignore: cast_nullable_to_non_nullable
          : icon as String,
      doctorCount: doctorCount == const $CopyWithPlaceholder()
          ? _value.doctorCount
          // ignore: cast_nullable_to_non_nullable
          : doctorCount as int?,
    );
  }
}

extension $SpecialityOutCopyWith on SpecialityOut {
  /// Returns a callable class that can be used as follows: `instanceOfSpecialityOut.copyWith(...)` or like so:`instanceOfSpecialityOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SpecialityOutCWProxy get copyWith => _$SpecialityOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecialityOut _$SpecialityOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SpecialityOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'name', 'nameHi', 'nameOr', 'icon'],
      );
      final val = SpecialityOut(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        nameHi: $checkedConvert('nameHi', (v) => v as String),
        nameOr: $checkedConvert('nameOr', (v) => v as String),
        icon: $checkedConvert('icon', (v) => v as String),
        doctorCount: $checkedConvert(
          'doctorCount',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$SpecialityOutToJson(SpecialityOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameHi': instance.nameHi,
      'nameOr': instance.nameOr,
      'icon': instance.icon,
      'doctorCount': ?instance.doctorCount,
    };
