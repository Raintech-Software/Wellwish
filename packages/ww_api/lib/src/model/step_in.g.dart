// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StepInCWProxy {
  StepIn lat(String? lat);

  StepIn lng(String? lng);

  StepIn accuracy(num? accuracy);

  StepIn clientTs(DateTime? clientTs);

  StepIn mock(bool? mock);

  StepIn step(StepInStepEnum step);

  StepIn otp(String? otp);

  StepIn note(String? note);

  StepIn vitals(VitalsIn? vitals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StepIn call({
    String? lat,
    String? lng,
    num? accuracy,
    DateTime? clientTs,
    bool? mock,
    StepInStepEnum step,
    String? otp,
    String? note,
    VitalsIn? vitals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStepIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStepIn.copyWith.fieldName(...)`
class _$StepInCWProxyImpl implements _$StepInCWProxy {
  const _$StepInCWProxyImpl(this._value);

  final StepIn _value;

  @override
  StepIn lat(String? lat) => this(lat: lat);

  @override
  StepIn lng(String? lng) => this(lng: lng);

  @override
  StepIn accuracy(num? accuracy) => this(accuracy: accuracy);

  @override
  StepIn clientTs(DateTime? clientTs) => this(clientTs: clientTs);

  @override
  StepIn mock(bool? mock) => this(mock: mock);

  @override
  StepIn step(StepInStepEnum step) => this(step: step);

  @override
  StepIn otp(String? otp) => this(otp: otp);

  @override
  StepIn note(String? note) => this(note: note);

  @override
  StepIn vitals(VitalsIn? vitals) => this(vitals: vitals);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepIn(...).copyWith(id: 12, name: "My name")
  /// ````
  StepIn call({
    Object? lat = const $CopyWithPlaceholder(),
    Object? lng = const $CopyWithPlaceholder(),
    Object? accuracy = const $CopyWithPlaceholder(),
    Object? clientTs = const $CopyWithPlaceholder(),
    Object? mock = const $CopyWithPlaceholder(),
    Object? step = const $CopyWithPlaceholder(),
    Object? otp = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? vitals = const $CopyWithPlaceholder(),
  }) {
    return StepIn(
      lat: lat == const $CopyWithPlaceholder()
          ? _value.lat
          // ignore: cast_nullable_to_non_nullable
          : lat as String?,
      lng: lng == const $CopyWithPlaceholder()
          ? _value.lng
          // ignore: cast_nullable_to_non_nullable
          : lng as String?,
      accuracy: accuracy == const $CopyWithPlaceholder()
          ? _value.accuracy
          // ignore: cast_nullable_to_non_nullable
          : accuracy as num?,
      clientTs: clientTs == const $CopyWithPlaceholder()
          ? _value.clientTs
          // ignore: cast_nullable_to_non_nullable
          : clientTs as DateTime?,
      mock: mock == const $CopyWithPlaceholder()
          ? _value.mock
          // ignore: cast_nullable_to_non_nullable
          : mock as bool?,
      step: step == const $CopyWithPlaceholder()
          ? _value.step
          // ignore: cast_nullable_to_non_nullable
          : step as StepInStepEnum,
      otp: otp == const $CopyWithPlaceholder()
          ? _value.otp
          // ignore: cast_nullable_to_non_nullable
          : otp as String?,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
      vitals: vitals == const $CopyWithPlaceholder()
          ? _value.vitals
          // ignore: cast_nullable_to_non_nullable
          : vitals as VitalsIn?,
    );
  }
}

extension $StepInCopyWith on StepIn {
  /// Returns a callable class that can be used as follows: `instanceOfStepIn.copyWith(...)` or like so:`instanceOfStepIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StepInCWProxy get copyWith => _$StepInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StepIn _$StepInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StepIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['step']);
      final val = StepIn(
        lat: $checkedConvert('lat', (v) => v as String?),
        lng: $checkedConvert('lng', (v) => v as String?),
        accuracy: $checkedConvert('accuracy', (v) => v as num?),
        clientTs: $checkedConvert(
          'clientTs',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        mock: $checkedConvert('mock', (v) => v as bool? ?? false),
        step: $checkedConvert(
          'step',
          (v) => $enumDecode(_$StepInStepEnumEnumMap, v),
        ),
        otp: $checkedConvert('otp', (v) => v as String? ?? ''),
        note: $checkedConvert('note', (v) => v as String? ?? ''),
        vitals: $checkedConvert(
          'vitals',
          (v) =>
              v == null ? null : VitalsIn.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StepInToJson(StepIn instance) => <String, dynamic>{
  'lat': ?instance.lat,
  'lng': ?instance.lng,
  'accuracy': ?instance.accuracy,
  'clientTs': ?instance.clientTs?.toIso8601String(),
  'mock': ?instance.mock,
  'step': _$StepInStepEnumEnumMap[instance.step]!,
  'otp': ?instance.otp,
  'note': ?instance.note,
  'vitals': ?instance.vitals?.toJson(),
};

const _$StepInStepEnumEnumMap = {
  StepInStepEnum.ON_THE_WAY: 'ON_THE_WAY',
  StepInStepEnum.REACHED_PATIENT: 'REACHED_PATIENT',
  StepInStepEnum.PICKED_UP: 'PICKED_UP',
  StepInStepEnum.REACHED_HOSPITAL: 'REACHED_HOSPITAL',
  StepInStepEnum.VISIT_DONE: 'VISIT_DONE',
  StepInStepEnum.DROPPED_HOME: 'DROPPED_HOME',
  StepInStepEnum.REACHED_HOME: 'REACHED_HOME',
  StepInStepEnum.STARTED: 'STARTED',
  StepInStepEnum.CARE_DONE: 'CARE_DONE',
  StepInStepEnum.AT_PLACE: 'AT_PLACE',
  StepInStepEnum.TASK_DONE: 'TASK_DONE',
  StepInStepEnum.DELIVERED: 'DELIVERED',
  StepInStepEnum.COMPLETED: 'COMPLETED',
};
