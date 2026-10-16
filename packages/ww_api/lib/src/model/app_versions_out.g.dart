// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_versions_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppVersionsOutCWProxy {
  AppVersionsOut patientAndroid(String patientAndroid);

  AppVersionsOut patientIos(String patientIos);

  AppVersionsOut partnerAndroid(String partnerAndroid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppVersionsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppVersionsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AppVersionsOut call({
    String patientAndroid,
    String patientIos,
    String partnerAndroid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppVersionsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppVersionsOut.copyWith.fieldName(...)`
class _$AppVersionsOutCWProxyImpl implements _$AppVersionsOutCWProxy {
  const _$AppVersionsOutCWProxyImpl(this._value);

  final AppVersionsOut _value;

  @override
  AppVersionsOut patientAndroid(String patientAndroid) =>
      this(patientAndroid: patientAndroid);

  @override
  AppVersionsOut patientIos(String patientIos) => this(patientIos: patientIos);

  @override
  AppVersionsOut partnerAndroid(String partnerAndroid) =>
      this(partnerAndroid: partnerAndroid);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppVersionsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppVersionsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AppVersionsOut call({
    Object? patientAndroid = const $CopyWithPlaceholder(),
    Object? patientIos = const $CopyWithPlaceholder(),
    Object? partnerAndroid = const $CopyWithPlaceholder(),
  }) {
    return AppVersionsOut(
      patientAndroid: patientAndroid == const $CopyWithPlaceholder()
          ? _value.patientAndroid
          // ignore: cast_nullable_to_non_nullable
          : patientAndroid as String,
      patientIos: patientIos == const $CopyWithPlaceholder()
          ? _value.patientIos
          // ignore: cast_nullable_to_non_nullable
          : patientIos as String,
      partnerAndroid: partnerAndroid == const $CopyWithPlaceholder()
          ? _value.partnerAndroid
          // ignore: cast_nullable_to_non_nullable
          : partnerAndroid as String,
    );
  }
}

extension $AppVersionsOutCopyWith on AppVersionsOut {
  /// Returns a callable class that can be used as follows: `instanceOfAppVersionsOut.copyWith(...)` or like so:`instanceOfAppVersionsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppVersionsOutCWProxy get copyWith => _$AppVersionsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionsOut _$AppVersionsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AppVersionsOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['patientAndroid', 'patientIos', 'partnerAndroid'],
      );
      final val = AppVersionsOut(
        patientAndroid: $checkedConvert('patientAndroid', (v) => v as String),
        patientIos: $checkedConvert('patientIos', (v) => v as String),
        partnerAndroid: $checkedConvert('partnerAndroid', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AppVersionsOutToJson(AppVersionsOut instance) =>
    <String, dynamic>{
      'patientAndroid': instance.patientAndroid,
      'patientIos': instance.patientIos,
      'partnerAndroid': instance.partnerAndroid,
    };
