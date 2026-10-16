// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_service_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingServiceOutCWProxy {
  BookingServiceOut name(String name);

  BookingServiceOut nameHi(String nameHi);

  BookingServiceOut nameOr(String nameOr);

  BookingServiceOut partnerType(String partnerType);

  BookingServiceOut visitType(String visitType);

  BookingServiceOut durationMin(int durationMin);

  BookingServiceOut docsRequired(bool docsRequired);

  BookingServiceOut pricePaise(int pricePaise);

  BookingServiceOut bookingFeePaise(int bookingFeePaise);

  BookingServiceOut balancePaise(int balancePaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingServiceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingServiceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingServiceOut call({
    String name,
    String nameHi,
    String nameOr,
    String partnerType,
    String visitType,
    int durationMin,
    bool docsRequired,
    int pricePaise,
    int bookingFeePaise,
    int balancePaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingServiceOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingServiceOut.copyWith.fieldName(...)`
class _$BookingServiceOutCWProxyImpl implements _$BookingServiceOutCWProxy {
  const _$BookingServiceOutCWProxyImpl(this._value);

  final BookingServiceOut _value;

  @override
  BookingServiceOut name(String name) => this(name: name);

  @override
  BookingServiceOut nameHi(String nameHi) => this(nameHi: nameHi);

  @override
  BookingServiceOut nameOr(String nameOr) => this(nameOr: nameOr);

  @override
  BookingServiceOut partnerType(String partnerType) =>
      this(partnerType: partnerType);

  @override
  BookingServiceOut visitType(String visitType) => this(visitType: visitType);

  @override
  BookingServiceOut durationMin(int durationMin) =>
      this(durationMin: durationMin);

  @override
  BookingServiceOut docsRequired(bool docsRequired) =>
      this(docsRequired: docsRequired);

  @override
  BookingServiceOut pricePaise(int pricePaise) => this(pricePaise: pricePaise);

  @override
  BookingServiceOut bookingFeePaise(int bookingFeePaise) =>
      this(bookingFeePaise: bookingFeePaise);

  @override
  BookingServiceOut balancePaise(int balancePaise) =>
      this(balancePaise: balancePaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingServiceOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingServiceOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingServiceOut call({
    Object? name = const $CopyWithPlaceholder(),
    Object? nameHi = const $CopyWithPlaceholder(),
    Object? nameOr = const $CopyWithPlaceholder(),
    Object? partnerType = const $CopyWithPlaceholder(),
    Object? visitType = const $CopyWithPlaceholder(),
    Object? durationMin = const $CopyWithPlaceholder(),
    Object? docsRequired = const $CopyWithPlaceholder(),
    Object? pricePaise = const $CopyWithPlaceholder(),
    Object? bookingFeePaise = const $CopyWithPlaceholder(),
    Object? balancePaise = const $CopyWithPlaceholder(),
  }) {
    return BookingServiceOut(
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
      partnerType: partnerType == const $CopyWithPlaceholder()
          ? _value.partnerType
          // ignore: cast_nullable_to_non_nullable
          : partnerType as String,
      visitType: visitType == const $CopyWithPlaceholder()
          ? _value.visitType
          // ignore: cast_nullable_to_non_nullable
          : visitType as String,
      durationMin: durationMin == const $CopyWithPlaceholder()
          ? _value.durationMin
          // ignore: cast_nullable_to_non_nullable
          : durationMin as int,
      docsRequired: docsRequired == const $CopyWithPlaceholder()
          ? _value.docsRequired
          // ignore: cast_nullable_to_non_nullable
          : docsRequired as bool,
      pricePaise: pricePaise == const $CopyWithPlaceholder()
          ? _value.pricePaise
          // ignore: cast_nullable_to_non_nullable
          : pricePaise as int,
      bookingFeePaise: bookingFeePaise == const $CopyWithPlaceholder()
          ? _value.bookingFeePaise
          // ignore: cast_nullable_to_non_nullable
          : bookingFeePaise as int,
      balancePaise: balancePaise == const $CopyWithPlaceholder()
          ? _value.balancePaise
          // ignore: cast_nullable_to_non_nullable
          : balancePaise as int,
    );
  }
}

extension $BookingServiceOutCopyWith on BookingServiceOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingServiceOut.copyWith(...)` or like so:`instanceOfBookingServiceOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingServiceOutCWProxy get copyWith =>
      _$BookingServiceOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingServiceOut _$BookingServiceOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BookingServiceOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'name',
          'nameHi',
          'nameOr',
          'partnerType',
          'visitType',
          'durationMin',
          'docsRequired',
          'pricePaise',
          'bookingFeePaise',
          'balancePaise',
        ],
      );
      final val = BookingServiceOut(
        name: $checkedConvert('name', (v) => v as String),
        nameHi: $checkedConvert('nameHi', (v) => v as String),
        nameOr: $checkedConvert('nameOr', (v) => v as String),
        partnerType: $checkedConvert('partnerType', (v) => v as String),
        visitType: $checkedConvert('visitType', (v) => v as String),
        durationMin: $checkedConvert('durationMin', (v) => (v as num).toInt()),
        docsRequired: $checkedConvert('docsRequired', (v) => v as bool),
        pricePaise: $checkedConvert('pricePaise', (v) => (v as num).toInt()),
        bookingFeePaise: $checkedConvert(
          'bookingFeePaise',
          (v) => (v as num).toInt(),
        ),
        balancePaise: $checkedConvert(
          'balancePaise',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$BookingServiceOutToJson(BookingServiceOut instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nameHi': instance.nameHi,
      'nameOr': instance.nameOr,
      'partnerType': instance.partnerType,
      'visitType': instance.visitType,
      'durationMin': instance.durationMin,
      'docsRequired': instance.docsRequired,
      'pricePaise': instance.pricePaise,
      'bookingFeePaise': instance.bookingFeePaise,
      'balancePaise': instance.balancePaise,
    };
