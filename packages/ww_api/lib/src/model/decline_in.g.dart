// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decline_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DeclineInCWProxy {
  DeclineIn reason(DeclineInReasonEnum reason);

  DeclineIn note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeclineIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeclineIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DeclineIn call({DeclineInReasonEnum reason, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDeclineIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDeclineIn.copyWith.fieldName(...)`
class _$DeclineInCWProxyImpl implements _$DeclineInCWProxy {
  const _$DeclineInCWProxyImpl(this._value);

  final DeclineIn _value;

  @override
  DeclineIn reason(DeclineInReasonEnum reason) => this(reason: reason);

  @override
  DeclineIn note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DeclineIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DeclineIn(...).copyWith(id: 12, name: "My name")
  /// ````
  DeclineIn call({
    Object? reason = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return DeclineIn(
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as DeclineInReasonEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $DeclineInCopyWith on DeclineIn {
  /// Returns a callable class that can be used as follows: `instanceOfDeclineIn.copyWith(...)` or like so:`instanceOfDeclineIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DeclineInCWProxy get copyWith => _$DeclineInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeclineIn _$DeclineInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DeclineIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['reason']);
      final val = DeclineIn(
        reason: $checkedConvert(
          'reason',
          (v) => $enumDecode(_$DeclineInReasonEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$DeclineInToJson(DeclineIn instance) => <String, dynamic>{
  'reason': _$DeclineInReasonEnumEnumMap[instance.reason]!,
  'note': ?instance.note,
};

const _$DeclineInReasonEnumEnumMap = {
  DeclineInReasonEnum.NOT_AVAILABLE: 'NOT_AVAILABLE',
  DeclineInReasonEnum.TOO_FAR: 'TOO_FAR',
  DeclineInReasonEnum.OTHER: 'OTHER',
};
