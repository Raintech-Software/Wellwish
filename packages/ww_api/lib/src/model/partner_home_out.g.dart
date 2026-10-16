// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_home_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerHomeOutCWProxy {
  PartnerHomeOut availableToday(bool availableToday);

  PartnerHomeOut selfieToday(bool selfieToday);

  PartnerHomeOut offers(List<OfferSummaryOut> offers);

  PartnerHomeOut today(List<PartnerJobRowOut> today);

  PartnerHomeOut totals(PartnerTotalsOut totals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerHomeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerHomeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerHomeOut call({
    bool availableToday,
    bool selfieToday,
    List<OfferSummaryOut> offers,
    List<PartnerJobRowOut> today,
    PartnerTotalsOut totals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerHomeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerHomeOut.copyWith.fieldName(...)`
class _$PartnerHomeOutCWProxyImpl implements _$PartnerHomeOutCWProxy {
  const _$PartnerHomeOutCWProxyImpl(this._value);

  final PartnerHomeOut _value;

  @override
  PartnerHomeOut availableToday(bool availableToday) =>
      this(availableToday: availableToday);

  @override
  PartnerHomeOut selfieToday(bool selfieToday) =>
      this(selfieToday: selfieToday);

  @override
  PartnerHomeOut offers(List<OfferSummaryOut> offers) => this(offers: offers);

  @override
  PartnerHomeOut today(List<PartnerJobRowOut> today) => this(today: today);

  @override
  PartnerHomeOut totals(PartnerTotalsOut totals) => this(totals: totals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerHomeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerHomeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerHomeOut call({
    Object? availableToday = const $CopyWithPlaceholder(),
    Object? selfieToday = const $CopyWithPlaceholder(),
    Object? offers = const $CopyWithPlaceholder(),
    Object? today = const $CopyWithPlaceholder(),
    Object? totals = const $CopyWithPlaceholder(),
  }) {
    return PartnerHomeOut(
      availableToday: availableToday == const $CopyWithPlaceholder()
          ? _value.availableToday
          // ignore: cast_nullable_to_non_nullable
          : availableToday as bool,
      selfieToday: selfieToday == const $CopyWithPlaceholder()
          ? _value.selfieToday
          // ignore: cast_nullable_to_non_nullable
          : selfieToday as bool,
      offers: offers == const $CopyWithPlaceholder()
          ? _value.offers
          // ignore: cast_nullable_to_non_nullable
          : offers as List<OfferSummaryOut>,
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as List<PartnerJobRowOut>,
      totals: totals == const $CopyWithPlaceholder()
          ? _value.totals
          // ignore: cast_nullable_to_non_nullable
          : totals as PartnerTotalsOut,
    );
  }
}

extension $PartnerHomeOutCopyWith on PartnerHomeOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerHomeOut.copyWith(...)` or like so:`instanceOfPartnerHomeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerHomeOutCWProxy get copyWith => _$PartnerHomeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerHomeOut _$PartnerHomeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerHomeOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'availableToday',
          'selfieToday',
          'offers',
          'today',
          'totals',
        ],
      );
      final val = PartnerHomeOut(
        availableToday: $checkedConvert('availableToday', (v) => v as bool),
        selfieToday: $checkedConvert('selfieToday', (v) => v as bool),
        offers: $checkedConvert(
          'offers',
          (v) => (v as List<dynamic>)
              .map((e) => OfferSummaryOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        today: $checkedConvert(
          'today',
          (v) => (v as List<dynamic>)
              .map((e) => PartnerJobRowOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        totals: $checkedConvert(
          'totals',
          (v) => PartnerTotalsOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PartnerHomeOutToJson(PartnerHomeOut instance) =>
    <String, dynamic>{
      'availableToday': instance.availableToday,
      'selfieToday': instance.selfieToday,
      'offers': instance.offers.map((e) => e.toJson()).toList(),
      'today': instance.today.map((e) => e.toJson()).toList(),
      'totals': instance.totals.toJson(),
    };
