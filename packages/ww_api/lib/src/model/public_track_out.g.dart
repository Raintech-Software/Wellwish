// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_track_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PublicTrackOutCWProxy {
  PublicTrackOut partnerFirstName(String partnerFirstName);

  PublicTrackOut serviceName(String serviceName);

  PublicTrackOut serviceNameHi(String? serviceNameHi);

  PublicTrackOut serviceNameOr(String? serviceNameOr);

  PublicTrackOut status(String status);

  PublicTrackOut step(String step);

  PublicTrackOut lat(String? lat);

  PublicTrackOut lng(String? lng);

  PublicTrackOut at(DateTime? at);

  PublicTrackOut etaMin(int? etaMin);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicTrackOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicTrackOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicTrackOut call({
    String partnerFirstName,
    String serviceName,
    String? serviceNameHi,
    String? serviceNameOr,
    String status,
    String step,
    String? lat,
    String? lng,
    DateTime? at,
    int? etaMin,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPublicTrackOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPublicTrackOut.copyWith.fieldName(...)`
class _$PublicTrackOutCWProxyImpl implements _$PublicTrackOutCWProxy {
  const _$PublicTrackOutCWProxyImpl(this._value);

  final PublicTrackOut _value;

  @override
  PublicTrackOut partnerFirstName(String partnerFirstName) =>
      this(partnerFirstName: partnerFirstName);

  @override
  PublicTrackOut serviceName(String serviceName) =>
      this(serviceName: serviceName);

  @override
  PublicTrackOut serviceNameHi(String? serviceNameHi) =>
      this(serviceNameHi: serviceNameHi);

  @override
  PublicTrackOut serviceNameOr(String? serviceNameOr) =>
      this(serviceNameOr: serviceNameOr);

  @override
  PublicTrackOut status(String status) => this(status: status);

  @override
  PublicTrackOut step(String step) => this(step: step);

  @override
  PublicTrackOut lat(String? lat) => this(lat: lat);

  @override
  PublicTrackOut lng(String? lng) => this(lng: lng);

  @override
  PublicTrackOut at(DateTime? at) => this(at: at);

  @override
  PublicTrackOut etaMin(int? etaMin) => this(etaMin: etaMin);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicTrackOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicTrackOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicTrackOut call({
    Object? partnerFirstName = const $CopyWithPlaceholder(),
    Object? serviceName = const $CopyWithPlaceholder(),
    Object? serviceNameHi = const $CopyWithPlaceholder(),
    Object? serviceNameOr = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
  }) {
    return PublicTrackOut(
      partnerFirstName: partnerFirstName == const $CopyWithPlaceholder()
          ? _value.partnerFirstName
          // ignore: cast_nullable_to_non_nullable
          : partnerFirstName as String,
      serviceName: serviceName == const $CopyWithPlaceholder()
          ? _value.serviceName
          // ignore: cast_nullable_to_non_nullable
          : serviceName as String,
      serviceNameHi: serviceNameHi == const $CopyWithPlaceholder()
          ? _value.serviceNameHi
          // ignore: cast_nullable_to_non_nullable
          : serviceNameHi as String?,
      serviceNameOr: serviceNameOr == const $CopyWithPlaceholder()
          ? _value.serviceNameOr
          // ignore: cast_nullable_to_non_nullable
          : serviceNameOr as String?,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as String,
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String?,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String?,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime?,
      etaMin: etaMin == const $CopyWithPlaceholder()
          ? _value.etaMin
          // ignore: cast_nullable_to_non_nullable
          : etaMin as int?,
    );
  }
}

extension $PublicTrackOutCopyWith on PublicTrackOut {
  /// Returns a callable class that can be used as follows: `instanceOfPublicTrackOut.copyWith(...)` or like so:`instanceOfPublicTrackOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PublicTrackOutCWProxy get copyWith => _$PublicTrackOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicTrackOut _$PublicTrackOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PublicTrackOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['partnerFirstName', 'serviceName', 'status', 'step'],
  );
  final val = PublicTrackOut(
    partnerFirstName: $checkedConvert('partnerFirstName', (v) => v as String),
    serviceName: $checkedConvert('serviceName', (v) => v as String),
    serviceNameHi: $checkedConvert('serviceNameHi', (v) => v as String? ?? ''),
    serviceNameOr: $checkedConvert('serviceNameOr', (v) => v as String? ?? ''),
    status: $checkedConvert('status', (v) => v as String),
    step: $checkedConvert('step', (v) => v as String),
    lat: $checkedConvert('lat', (v) => v as String?),
    lng: $checkedConvert('lng', (v) => v as String?),
    at: $checkedConvert(
      'at',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    etaMin: $checkedConvert('etaMin', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$PublicTrackOutToJson(PublicTrackOut instance) =>
    <String, dynamic>{
      'partnerFirstName': instance.partnerFirstName,
      'serviceName': instance.serviceName,
      'serviceNameHi': ?instance.serviceNameHi,
      'serviceNameOr': ?instance.serviceNameOr,
      'status': instance.status,
      'step': instance.step,
      'lat': ?instance.lat,
      'lng': ?instance.lng,
      'at': ?instance.at?.toIso8601String(),
      'etaMin': ?instance.etaMin,
    };
