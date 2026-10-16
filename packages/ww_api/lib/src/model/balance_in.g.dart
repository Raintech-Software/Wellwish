// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BalanceInCWProxy {
  BalanceIn amountPaise(int amountPaise);

  BalanceIn mode(BalanceInModeEnum mode);

  BalanceIn note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalanceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalanceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BalanceIn call({int amountPaise, BalanceInModeEnum mode, String? note});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBalanceIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBalanceIn.copyWith.fieldName(...)`
class _$BalanceInCWProxyImpl implements _$BalanceInCWProxy {
  const _$BalanceInCWProxyImpl(this._value);

  final BalanceIn _value;

  @override
  BalanceIn amountPaise(int amountPaise) => this(amountPaise: amountPaise);

  @override
  BalanceIn mode(BalanceInModeEnum mode) => this(mode: mode);

  @override
  BalanceIn note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BalanceIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BalanceIn(...).copyWith(id: 12, name: "My name")
  /// ````
  BalanceIn call({
    Object? amountPaise = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return BalanceIn(
      amountPaise: amountPaise == const $CopyWithPlaceholder()
          ? _value.amountPaise
          // ignore: cast_nullable_to_non_nullable
          : amountPaise as int,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as BalanceInModeEnum,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $BalanceInCopyWith on BalanceIn {
  /// Returns a callable class that can be used as follows: `instanceOfBalanceIn.copyWith(...)` or like so:`instanceOfBalanceIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BalanceInCWProxy get copyWith => _$BalanceInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceIn _$BalanceInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BalanceIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['amountPaise', 'mode']);
      final val = BalanceIn(
        amountPaise: $checkedConvert('amountPaise', (v) => (v as num).toInt()),
        mode: $checkedConvert(
          'mode',
          (v) => $enumDecode(_$BalanceInModeEnumEnumMap, v),
        ),
        note: $checkedConvert('note', (v) => v as String? ?? ''),
      );
      return val;
    });

Map<String, dynamic> _$BalanceInToJson(BalanceIn instance) => <String, dynamic>{
  'amountPaise': instance.amountPaise,
  'mode': _$BalanceInModeEnumEnumMap[instance.mode]!,
  'note': ?instance.note,
};

const _$BalanceInModeEnumEnumMap = {
  BalanceInModeEnum.CASH: 'CASH',
  BalanceInModeEnum.UPI: 'UPI',
};
