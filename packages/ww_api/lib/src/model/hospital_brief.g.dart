// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_brief.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HospitalBriefCWProxy {
  HospitalBrief id(String id);

  HospitalBrief name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalBrief(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalBrief(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalBrief call({String id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHospitalBrief.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHospitalBrief.copyWith.fieldName(...)`
class _$HospitalBriefCWProxyImpl implements _$HospitalBriefCWProxy {
  const _$HospitalBriefCWProxyImpl(this._value);

  final HospitalBrief _value;

  @override
  HospitalBrief id(String id) => this(id: id);

  @override
  HospitalBrief name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HospitalBrief(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HospitalBrief(...).copyWith(id: 12, name: "My name")
  /// ````
  HospitalBrief call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return HospitalBrief(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $HospitalBriefCopyWith on HospitalBrief {
  /// Returns a callable class that can be used as follows: `instanceOfHospitalBrief.copyWith(...)` or like so:`instanceOfHospitalBrief.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HospitalBriefCWProxy get copyWith => _$HospitalBriefCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HospitalBrief _$HospitalBriefFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HospitalBrief', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name']);
      final val = HospitalBrief(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$HospitalBriefToJson(HospitalBrief instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
