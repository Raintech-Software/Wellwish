// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_selfie_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminSelfieOutCWProxy {
  AdminSelfieOut id(String id);

  AdminSelfieOut partnerId(String partnerId);

  AdminSelfieOut partnerName(String partnerName);

  AdminSelfieOut role(String role);

  AdminSelfieOut at(DateTime at);

  AdminSelfieOut selfieUrl(String? selfieUrl);

  AdminSelfieOut photoUrl(String? photoUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminSelfieOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminSelfieOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminSelfieOut call({
    String id,
    String partnerId,
    String partnerName,
    String role,
    DateTime at,
    String? selfieUrl,
    String? photoUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminSelfieOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminSelfieOut.copyWith.fieldName(...)`
class _$AdminSelfieOutCWProxyImpl implements _$AdminSelfieOutCWProxy {
  const _$AdminSelfieOutCWProxyImpl(this._value);

  final AdminSelfieOut _value;

  @override
  AdminSelfieOut id(String id) => this(id: id);

  @override
  AdminSelfieOut partnerId(String partnerId) => this(partnerId: partnerId);

  @override
  AdminSelfieOut partnerName(String partnerName) =>
      this(partnerName: partnerName);

  @override
  AdminSelfieOut role(String role) => this(role: role);

  @override
  AdminSelfieOut at(DateTime at) => this(at: at);

  @override
  AdminSelfieOut selfieUrl(String? selfieUrl) => this(selfieUrl: selfieUrl);

  @override
  AdminSelfieOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminSelfieOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminSelfieOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminSelfieOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? partnerName = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? at = const $CopyWithPlaceholder(),
    Object? selfieUrl = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
  }) {
    return AdminSelfieOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      partnerId: partnerId == const $CopyWithPlaceholder()
          ? _value.partnerId
          // ignore: cast_nullable_to_non_nullable
          : partnerId as String,
      partnerName: partnerName == const $CopyWithPlaceholder()
          ? _value.partnerName
          // ignore: cast_nullable_to_non_nullable
          : partnerName as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
      at: at == const $CopyWithPlaceholder()
          ? _value.at
          // ignore: cast_nullable_to_non_nullable
          : at as DateTime,
      selfieUrl: selfieUrl == const $CopyWithPlaceholder()
          ? _value.selfieUrl
          // ignore: cast_nullable_to_non_nullable
          : selfieUrl as String?,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
    );
  }
}

extension $AdminSelfieOutCopyWith on AdminSelfieOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminSelfieOut.copyWith(...)` or like so:`instanceOfAdminSelfieOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminSelfieOutCWProxy get copyWith => _$AdminSelfieOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminSelfieOut _$AdminSelfieOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdminSelfieOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'partnerId',
          'partnerName',
          'role',
          'at',
          'selfieUrl',
          'photoUrl',
        ],
      );
      final val = AdminSelfieOut(
        id: $checkedConvert('id', (v) => v as String),
        partnerId: $checkedConvert('partnerId', (v) => v as String),
        partnerName: $checkedConvert('partnerName', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        at: $checkedConvert('at', (v) => DateTime.parse(v as String)),
        selfieUrl: $checkedConvert('selfieUrl', (v) => v as String?),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AdminSelfieOutToJson(AdminSelfieOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partnerId': instance.partnerId,
      'partnerName': instance.partnerName,
      'role': instance.role,
      'at': instance.at.toIso8601String(),
      'selfieUrl': instance.selfieUrl,
      'photoUrl': instance.photoUrl,
    };
