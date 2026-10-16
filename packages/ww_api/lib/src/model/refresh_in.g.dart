// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RefreshInCWProxy {
  RefreshIn refreshToken(String refreshToken);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefreshIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefreshIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RefreshIn call({String refreshToken});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRefreshIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRefreshIn.copyWith.fieldName(...)`
class _$RefreshInCWProxyImpl implements _$RefreshInCWProxy {
  const _$RefreshInCWProxyImpl(this._value);

  final RefreshIn _value;

  @override
  RefreshIn refreshToken(String refreshToken) =>
      this(refreshToken: refreshToken);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RefreshIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RefreshIn(...).copyWith(id: 12, name: "My name")
  /// ````
  RefreshIn call({Object? refreshToken = const $CopyWithPlaceholder()}) {
    return RefreshIn(
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String,
    );
  }
}

extension $RefreshInCopyWith on RefreshIn {
  /// Returns a callable class that can be used as follows: `instanceOfRefreshIn.copyWith(...)` or like so:`instanceOfRefreshIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RefreshInCWProxy get copyWith => _$RefreshInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshIn _$RefreshInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RefreshIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['refreshToken']);
      final val = RefreshIn(
        refreshToken: $checkedConvert('refreshToken', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$RefreshInToJson(RefreshIn instance) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
};
