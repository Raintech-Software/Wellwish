// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sos_resolve_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SosResolveInCWProxy {
  SosResolveIn notes(String notes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosResolveIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosResolveIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SosResolveIn call({String notes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSosResolveIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSosResolveIn.copyWith.fieldName(...)`
class _$SosResolveInCWProxyImpl implements _$SosResolveInCWProxy {
  const _$SosResolveInCWProxyImpl(this._value);

  final SosResolveIn _value;

  @override
  SosResolveIn notes(String notes) => this(notes: notes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SosResolveIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SosResolveIn(...).copyWith(id: 12, name: "My name")
  /// ````
  SosResolveIn call({Object? notes = const $CopyWithPlaceholder()}) {
    return SosResolveIn(
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
    );
  }
}

extension $SosResolveInCopyWith on SosResolveIn {
  /// Returns a callable class that can be used as follows: `instanceOfSosResolveIn.copyWith(...)` or like so:`instanceOfSosResolveIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SosResolveInCWProxy get copyWith => _$SosResolveInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SosResolveIn _$SosResolveInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SosResolveIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['notes']);
      final val = SosResolveIn(
        notes: $checkedConvert('notes', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$SosResolveInToJson(SosResolveIn instance) =>
    <String, dynamic>{'notes': instance.notes};
