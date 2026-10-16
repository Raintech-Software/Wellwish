// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_totals_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerTotalsOutCWProxy {
  PartnerTotalsOut today(int today);

  PartnerTotalsOut thisWeek(int thisWeek);

  PartnerTotalsOut upcoming(int upcoming);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerTotalsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerTotalsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerTotalsOut call({int today, int thisWeek, int upcoming});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerTotalsOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerTotalsOut.copyWith.fieldName(...)`
class _$PartnerTotalsOutCWProxyImpl implements _$PartnerTotalsOutCWProxy {
  const _$PartnerTotalsOutCWProxyImpl(this._value);

  final PartnerTotalsOut _value;

  @override
  PartnerTotalsOut today(int today) => this(today: today);

  @override
  PartnerTotalsOut thisWeek(int thisWeek) => this(thisWeek: thisWeek);

  @override
  PartnerTotalsOut upcoming(int upcoming) => this(upcoming: upcoming);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerTotalsOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerTotalsOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerTotalsOut call({
    Object? today = const $CopyWithPlaceholder(),
    Object? thisWeek = const $CopyWithPlaceholder(),
    Object? upcoming = const $CopyWithPlaceholder(),
  }) {
    return PartnerTotalsOut(
      today: today == const $CopyWithPlaceholder()
          ? _value.today
          // ignore: cast_nullable_to_non_nullable
          : today as int,
      thisWeek: thisWeek == const $CopyWithPlaceholder()
          ? _value.thisWeek
          // ignore: cast_nullable_to_non_nullable
          : thisWeek as int,
      upcoming: upcoming == const $CopyWithPlaceholder()
          ? _value.upcoming
          // ignore: cast_nullable_to_non_nullable
          : upcoming as int,
    );
  }
}

extension $PartnerTotalsOutCopyWith on PartnerTotalsOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerTotalsOut.copyWith(...)` or like so:`instanceOfPartnerTotalsOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerTotalsOutCWProxy get copyWith => _$PartnerTotalsOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerTotalsOut _$PartnerTotalsOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerTotalsOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['today', 'thisWeek', 'upcoming']);
      final val = PartnerTotalsOut(
        today: $checkedConvert('today', (v) => (v as num).toInt()),
        thisWeek: $checkedConvert('thisWeek', (v) => (v as num).toInt()),
        upcoming: $checkedConvert('upcoming', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PartnerTotalsOutToJson(PartnerTotalsOut instance) =>
    <String, dynamic>{
      'today': instance.today,
      'thisWeek': instance.thisWeek,
      'upcoming': instance.upcoming,
    };
