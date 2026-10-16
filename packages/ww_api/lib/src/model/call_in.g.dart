// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CallInCWProxy {
  CallIn to(CallInToEnum to);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CallIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CallIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CallIn call({CallInToEnum to});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCallIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCallIn.copyWith.fieldName(...)`
class _$CallInCWProxyImpl implements _$CallInCWProxy {
  const _$CallInCWProxyImpl(this._value);

  final CallIn _value;

  @override
  CallIn to(CallInToEnum to) => this(to: to);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CallIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CallIn(...).copyWith(id: 12, name: "My name")
  /// ````
  CallIn call({Object? to = const $CopyWithPlaceholder()}) {
    return CallIn(
      to: to == const $CopyWithPlaceholder()
          ? _value.to
          // ignore: cast_nullable_to_non_nullable
          : to as CallInToEnum,
    );
  }
}

extension $CallInCopyWith on CallIn {
  /// Returns a callable class that can be used as follows: `instanceOfCallIn.copyWith(...)` or like so:`instanceOfCallIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CallInCWProxy get copyWith => _$CallInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallIn _$CallInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CallIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['to']);
      final val = CallIn(
        to: $checkedConvert('to', (v) => $enumDecode(_$CallInToEnumEnumMap, v)),
      );
      return val;
    });

Map<String, dynamic> _$CallInToJson(CallIn instance) => <String, dynamic>{
  'to': _$CallInToEnumEnumMap[instance.to]!,
};

const _$CallInToEnumEnumMap = {
  CallInToEnum.MEMBER: 'MEMBER',
  CallInToEnum.BOOKER: 'BOOKER',
};
