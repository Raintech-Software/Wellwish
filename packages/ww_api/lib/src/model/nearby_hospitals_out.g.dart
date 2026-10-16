// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_hospitals_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NearbyHospitalsOutCWProxy {
  NearbyHospitalsOut radiusKm(num? radiusKm);

  NearbyHospitalsOut items(List<PatientHospitalOut> items);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NearbyHospitalsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NearbyHospitalsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  NearbyHospitalsOut call({num? radiusKm, List<PatientHospitalOut> items});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNearbyHospitalsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNearbyHospitalsOut.copyWith.fieldName(...)`
class _$NearbyHospitalsOutCWProxyImpl implements _$NearbyHospitalsOutCWProxy {
  const _$NearbyHospitalsOutCWProxyImpl(this._value);

  final NearbyHospitalsOut _value;

  @override
  NearbyHospitalsOut radiusKm(num? radiusKm) => this(radiusKm: radiusKm);

  @override
  NearbyHospitalsOut items(List<PatientHospitalOut> items) =>
      this(items: items);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NearbyHospitalsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NearbyHospitalsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  NearbyHospitalsOut call({
    Object? radiusKm = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
  }) {
    return NearbyHospitalsOut(
      radiusKm: radiusKm == const $CopyWithPlaceholder()
          ? _value.radiusKm
          // ignore: cast_nullable_to_non_nullable
          : radiusKm as num?,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<PatientHospitalOut>,
    );
  }
}

extension $NearbyHospitalsOutCopyWith on NearbyHospitalsOut {
  /// Returns a callable class that can be used as follows: `instanceOfNearbyHospitalsOut.copyWith(...)` or like so:`instanceOfNearbyHospitalsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NearbyHospitalsOutCWProxy get copyWith =>
      _$NearbyHospitalsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyHospitalsOut _$NearbyHospitalsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NearbyHospitalsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['items']);
      final val = NearbyHospitalsOut(
        radiusKm: $checkedConvert('radiusKm', (v) => v as num?),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map(
                (e) => PatientHospitalOut.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$NearbyHospitalsOutToJson(NearbyHospitalsOut instance) =>
    <String, dynamic>{
      'radiusKm': ?instance.radiusKm,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
