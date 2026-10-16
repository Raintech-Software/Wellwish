// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_location_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveLocationOutCWProxy {
  LiveLocationOut bookingId(String bookingId);

  LiveLocationOut lat(String? lat);

  LiveLocationOut lng(String? lng);

  LiveLocationOut at(DateTime? at);

  LiveLocationOut etaMin(int? etaMin);

  LiveLocationOut step(String step);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveLocationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveLocationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveLocationOut call({
    String bookingId,
    String? lat,
    String? lng,
    DateTime? at,
    int? etaMin,
    String step,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveLocationOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLiveLocationOut.copyWith.fieldName(...)`
class _$LiveLocationOutCWProxyImpl implements _$LiveLocationOutCWProxy {
  const _$LiveLocationOutCWProxyImpl(this._value);

  final LiveLocationOut _value;

  @override
  LiveLocationOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  LiveLocationOut lat(String? lat) => this(lat: lat);

  @override
  LiveLocationOut lng(String? lng) => this(lng: lng);

  @override
  LiveLocationOut at(DateTime? at) => this(at: at);

  @override
  LiveLocationOut etaMin(int? etaMin) => this(etaMin: etaMin);

  @override
  LiveLocationOut step(String step) => this(step: step);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveLocationOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveLocationOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveLocationOut call({
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
  }) {
    return LiveLocationOut(
      bookingId: bookingId == const $CopyWithPlaceholder()
          ? _value.bookingId
          // ignore: cast_nullable_to_non_nullable
          : bookingId as String,
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
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as String,
    );
  }
}

extension $LiveLocationOutCopyWith on LiveLocationOut {
  /// Returns a callable class that can be used as follows: `instanceOfLiveLocationOut.copyWith(...)` or like so:`instanceOfLiveLocationOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveLocationOutCWProxy get copyWith => _$LiveLocationOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveLocationOut _$LiveLocationOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LiveLocationOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['bookingId', 'step']);
      final val = LiveLocationOut(
        bookingId: $checkedConvert('bookingId', (v) => v as String),
        lat: $checkedConvert('lat', (v) => v as String?),
        lng: $checkedConvert('lng', (v) => v as String?),
        at: $checkedConvert(
          'at',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        etaMin: $checkedConvert('etaMin', (v) => (v as num?)?.toInt()),
        step: $checkedConvert('step', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LiveLocationOutToJson(LiveLocationOut instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'lat': ?instance.lat,
      'lng': ?instance.lng,
      'at': ?instance.at?.toIso8601String(),
      'etaMin': ?instance.etaMin,
      'step': instance.step,
    };
