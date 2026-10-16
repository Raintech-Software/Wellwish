// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_reason_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PatientReasonInCWProxy {
  PatientReasonIn reason(String reason);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientReasonIn call({String reason});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPatientReasonIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPatientReasonIn.copyWith.fieldName(...)`
class _$PatientReasonInCWProxyImpl implements _$PatientReasonInCWProxy {
  const _$PatientReasonInCWProxyImpl(this._value);

  final PatientReasonIn _value;

  @override
  PatientReasonIn reason(String reason) => this(reason: reason);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PatientReasonIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PatientReasonIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PatientReasonIn call({Object? reason = const $CopyWithPlaceholder()}) {
    return PatientReasonIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
    );
  }
}

extension $PatientReasonInCopyWith on PatientReasonIn {
  /// Returns a callable class that can be used as follows: `instanceOfPatientReasonIn.copyWith(...)` or like so:`instanceOfPatientReasonIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PatientReasonInCWProxy get copyWith => _$PatientReasonInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientReasonIn _$PatientReasonInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PatientReasonIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = PatientReasonIn(
        reason: $checkedConvert('reason', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PatientReasonInToJson(PatientReasonIn instance) =>
    <String, dynamic>{'reason': instance.reason};
