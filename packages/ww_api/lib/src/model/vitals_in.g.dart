// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vitals_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$VitalsInCWProxy {
  VitalsIn bp(String? bp);

  VitalsIn pulse(int? pulse);

  VitalsIn temperatureF(num? temperatureF);

  VitalsIn spo2(int? spo2);

  VitalsIn sugar(int? sugar);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VitalsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VitalsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  VitalsIn call({
    String? bp,
    int? pulse,
    num? temperatureF,
    int? spo2,
    int? sugar,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfVitalsIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfVitalsIn.copyWith.fieldName(...)`
class _$VitalsInCWProxyImpl implements _$VitalsInCWProxy {
  const _$VitalsInCWProxyImpl(this._value);

  final VitalsIn _value;

  @override
  VitalsIn bp(String? bp) => this(bp: bp);

  @override
  VitalsIn pulse(int? pulse) => this(pulse: pulse);

  @override
  VitalsIn temperatureF(num? temperatureF) => this(temperatureF: temperatureF);

  @override
  VitalsIn spo2(int? spo2) => this(spo2: spo2);

  @override
  VitalsIn sugar(int? sugar) => this(sugar: sugar);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `VitalsIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// VitalsIn(...).copyWith(id: 12, name: "My name")
  /// ````
  VitalsIn call({
    Object? bp = const $CopyWithPlaceholder(),
    Object? pulse = const $CopyWithPlaceholder(),
    Object? temperatureF = const $CopyWithPlaceholder(),
    Object? spo2 = const $CopyWithPlaceholder(),
    Object? sugar = const $CopyWithPlaceholder(),
  }) {
    return VitalsIn(
      bp: bp == const $CopyWithPlaceholder()
          ? _value.bp
          // ignore: cast_nullable_to_non_nullable
          : bp as String?,
      pulse: pulse == const $CopyWithPlaceholder()
          ? _value.pulse
          // ignore: cast_nullable_to_non_nullable
          : pulse as int?,
      temperatureF: temperatureF == const $CopyWithPlaceholder()
          ? _value.temperatureF
          // ignore: cast_nullable_to_non_nullable
          : temperatureF as num?,
      spo2: spo2 == const $CopyWithPlaceholder()
          ? _value.spo2
          // ignore: cast_nullable_to_non_nullable
          : spo2 as int?,
      sugar: sugar == const $CopyWithPlaceholder()
          ? _value.sugar
          // ignore: cast_nullable_to_non_nullable
          : sugar as int?,
    );
  }
}

extension $VitalsInCopyWith on VitalsIn {
  /// Returns a callable class that can be used as follows: `instanceOfVitalsIn.copyWith(...)` or like so:`instanceOfVitalsIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$VitalsInCWProxy get copyWith => _$VitalsInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalsIn _$VitalsInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('VitalsIn', json, ($checkedConvert) {
      final val = VitalsIn(
        bp: $checkedConvert('bp', (v) => v as String? ?? ''),
        pulse: $checkedConvert('pulse', (v) => (v as num?)?.toInt()),
        temperatureF: $checkedConvert('temperatureF', (v) => v as num?),
        spo2: $checkedConvert('spo2', (v) => (v as num?)?.toInt()),
        sugar: $checkedConvert('sugar', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$VitalsInToJson(VitalsIn instance) => <String, dynamic>{
  'bp': ?instance.bp,
  'pulse': ?instance.pulse,
  'temperatureF': ?instance.temperatureF,
  'spo2': ?instance.spo2,
  'sugar': ?instance.sugar,
};
