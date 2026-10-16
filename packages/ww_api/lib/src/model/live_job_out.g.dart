// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_job_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LiveJobOutCWProxy {
  LiveJobOut bookingId(String bookingId);

  LiveJobOut lat(String? lat);

  LiveJobOut lng(String? lng);

  LiveJobOut at(DateTime? at);

  LiveJobOut etaMin(int? etaMin);

  LiveJobOut step(String step);

  LiveJobOut code(String code);

  LiveJobOut partnerName(String partnerName);

  LiveJobOut partnerPhone(String partnerPhone);

  LiveJobOut partnerAlternatePhone(String partnerAlternatePhone);

  LiveJobOut serviceName(String serviceName);

  LiveJobOut memberName(String memberName);

  LiveJobOut pickupAt(DateTime pickupAt);

  LiveJobOut stale(bool stale);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveJobOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveJobOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveJobOut call({
    String bookingId,
    String? lat,
    String? lng,
    DateTime? at,
    int? etaMin,
    String step,
    String code,
    String partnerName,
    String partnerPhone,
    String partnerAlternatePhone,
    String serviceName,
    String memberName,
    DateTime pickupAt,
    bool stale,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLiveJobOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLiveJobOut.copyWith.fieldName(...)`
class _$LiveJobOutCWProxyImpl implements _$LiveJobOutCWProxy {
  const _$LiveJobOutCWProxyImpl(this._value);

  final LiveJobOut _value;

  @override
  LiveJobOut bookingId(String bookingId) => this(bookingId: bookingId);

  @override
  LiveJobOut lat(String? lat) => this(lat: lat);

  @override
  LiveJobOut lng(String? lng) => this(lng: lng);

  @override
  LiveJobOut at(DateTime? at) => this(at: at);

  @override
  LiveJobOut etaMin(int? etaMin) => this(etaMin: etaMin);

  @override
  LiveJobOut step(String step) => this(step: step);

  @override
  LiveJobOut code(String code) => this(code: code);

  @override
  LiveJobOut partnerName(String partnerName) => this(partnerName: partnerName);

  @override
  LiveJobOut partnerPhone(String partnerPhone) =>
      this(partnerPhone: partnerPhone);

  @override
  LiveJobOut partnerAlternatePhone(String partnerAlternatePhone) =>
      this(partnerAlternatePhone: partnerAlternatePhone);

  @override
  LiveJobOut serviceName(String serviceName) => this(serviceName: serviceName);

  @override
  LiveJobOut memberName(String memberName) => this(memberName: memberName);

  @override
  LiveJobOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  LiveJobOut stale(bool stale) => this(stale: stale);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LiveJobOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LiveJobOut(...).copyWith(id: 12, name: "My name")
  /// ````
  LiveJobOut call({
    Object? bookingId = const $CopyWithPlaceholder(),
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? etaMin = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? partnerPhone = const $CopyWithPlaceholder(),
    Object? partnerAlternatePhone = const $CopyWithPlaceholder(),
    Object? serviceName = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? stale = const $CopyWithPlaceholder(),
  }) {
    return LiveJobOut(
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
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      partnerPhone: partnerPhone == const $CopyWithPlaceholder()
          ? _value.partnerPhone
          // ignore: cast_nullable_to_non_nullable
          : partnerPhone as String,
      partnerAlternatePhone:
          partnerAlternatePhone == const $CopyWithPlaceholder()
          ? _value.partnerAlternatePhone
          // ignore: cast_nullable_to_non_nullable
          : partnerAlternatePhone as String,
      serviceName: serviceName == const $CopyWithPlaceholder()
          ? _value.serviceName
          // ignore: cast_nullable_to_non_nullable
          : serviceName as String,
      memberName: memberName == const $CopyWithPlaceholder()
          ? _value.memberName
          // ignore: cast_nullable_to_non_nullable
          : memberName as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      stale: stale == const $CopyWithPlaceholder()
          ? _value.stale
          // ignore: cast_nullable_to_non_nullable
          : stale as bool,
    );
  }
}

extension $LiveJobOutCopyWith on LiveJobOut {
  /// Returns a callable class that can be used as follows: `instanceOfLiveJobOut.copyWith(...)` or like so:`instanceOfLiveJobOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LiveJobOutCWProxy get copyWith => _$LiveJobOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveJobOut _$LiveJobOutFromJson(Map<String, dynamic> json) => $checkedCreate(
  'LiveJobOut',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      requiredKeys: const [
        'bookingId',
        'step',
        'code',
        'partnerName',
        'partnerPhone',
        'partnerAlternatePhone',
        'serviceName',
        'memberName',
        'pickupAt',
        'stale',
      ],
    );
    final val = LiveJobOut(
      bookingId: $checkedConvert('bookingId', (v) => v as String),
      lat: $checkedConvert('lat', (v) => v as String?),
      lng: $checkedConvert('lng', (v) => v as String?),
      at: $checkedConvert(
        'at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
      etaMin: $checkedConvert('etaMin', (v) => (v as num?)?.toInt()),
      step: $checkedConvert('step', (v) => v as String),
      code: $checkedConvert('code', (v) => v as String),
      partnerName: $checkedConvert('partnerName', (v) => v as String),
      partnerPhone: $checkedConvert('partnerPhone', (v) => v as String),
      partnerAlternatePhone: $checkedConvert(
        'partnerAlternatePhone',
        (v) => v as String,
      ),
      serviceName: $checkedConvert('serviceName', (v) => v as String),
      memberName: $checkedConvert('memberName', (v) => v as String),
      pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
      stale: $checkedConvert('stale', (v) => v as bool),
    );
    return val;
  },
);

Map<String, dynamic> _$LiveJobOutToJson(LiveJobOut instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'lat': ?instance.lat,
      'lng': ?instance.lng,
      'at': ?instance.at?.toIso8601String(),
      'etaMin': ?instance.etaMin,
      'step': instance.step,
      'code': instance.code,
      'partnerName': instance.partnerName,
      'partnerPhone': instance.partnerPhone,
      'partnerAlternatePhone': instance.partnerAlternatePhone,
      'serviceName': instance.serviceName,
      'memberName': instance.memberName,
      'pickupAt': instance.pickupAt.toIso8601String(),
      'stale': instance.stale,
    };
