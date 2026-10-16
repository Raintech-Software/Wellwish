// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_filter.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddressFilterCWProxy {
  AddressFilter memberId(String? memberId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressFilter call({String? memberId});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddressFilter.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddressFilter.copyWith.fieldName(...)`
class _$AddressFilterCWProxyImpl implements _$AddressFilterCWProxy {
  const _$AddressFilterCWProxyImpl(this._value);

  final AddressFilter _value;

  @override
  AddressFilter memberId(String? memberId) => this(memberId: memberId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AddressFilter(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AddressFilter(...).copyWith(id: 12, name: "My name")
  /// ````
  AddressFilter call({Object? memberId = const $CopyWithPlaceholder()}) {
    return AddressFilter(
      memberId: memberId == const $CopyWithPlaceholder()
          ? _value.memberId
          // ignore: cast_nullable_to_non_nullable
          : memberId as String?,
    );
  }
}

extension $AddressFilterCopyWith on AddressFilter {
  /// Returns a callable class that can be used as follows: `instanceOfAddressFilter.copyWith(...)` or like so:`instanceOfAddressFilter.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddressFilterCWProxy get copyWith => _$AddressFilterCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressFilter _$AddressFilterFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AddressFilter', json, ($checkedConvert) {
      final val = AddressFilter(
        memberId: $checkedConvert('memberId', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AddressFilterToJson(AddressFilter instance) =>
    <String, dynamic>{'memberId': ?instance.memberId};
