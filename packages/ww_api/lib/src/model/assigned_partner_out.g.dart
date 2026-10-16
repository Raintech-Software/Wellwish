// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_partner_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssignedPartnerOutCWProxy {
  AssignedPartnerOut fullName(String fullName);

  AssignedPartnerOut role(String role);

  AssignedPartnerOut photoUrl(String? photoUrl);

  AssignedPartnerOut phone(String phone);

  AssignedPartnerOut ratingAvg(String? ratingAvg);

  AssignedPartnerOut ratingCount(int ratingCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignedPartnerOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignedPartnerOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignedPartnerOut call({
    String fullName,
    String role,
    String? photoUrl,
    String phone,
    String? ratingAvg,
    int ratingCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAssignedPartnerOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAssignedPartnerOut.copyWith.fieldName(...)`
class _$AssignedPartnerOutCWProxyImpl implements _$AssignedPartnerOutCWProxy {
  const _$AssignedPartnerOutCWProxyImpl(this._value);

  final AssignedPartnerOut _value;

  @override
  AssignedPartnerOut fullName(String fullName) => this(fullName: fullName);

  @override
  AssignedPartnerOut role(String role) => this(role: role);

  @override
  AssignedPartnerOut photoUrl(String? photoUrl) => this(photoUrl: photoUrl);

  @override
  AssignedPartnerOut phone(String phone) => this(phone: phone);

  @override
  AssignedPartnerOut ratingAvg(String? ratingAvg) => this(ratingAvg: ratingAvg);

  @override
  AssignedPartnerOut ratingCount(int ratingCount) =>
      this(ratingCount: ratingCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignedPartnerOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignedPartnerOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignedPartnerOut call({
    Object? fullName = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? ratingAvg = const $CopyWithPlaceholder(),
    Object? ratingCount = const $CopyWithPlaceholder(),
  }) {
    return AssignedPartnerOut(
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      ratingAvg: ratingAvg == const $CopyWithPlaceholder()
          ? _value.ratingAvg
          // ignore: cast_nullable_to_non_nullable
          : ratingAvg as String?,
      ratingCount: ratingCount == const $CopyWithPlaceholder()
          ? _value.ratingCount
          // ignore: cast_nullable_to_non_nullable
          : ratingCount as int,
    );
  }
}

extension $AssignedPartnerOutCopyWith on AssignedPartnerOut {
  /// Returns a callable class that can be used as follows: `instanceOfAssignedPartnerOut.copyWith(...)` or like so:`instanceOfAssignedPartnerOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssignedPartnerOutCWProxy get copyWith =>
      _$AssignedPartnerOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignedPartnerOut _$AssignedPartnerOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AssignedPartnerOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'fullName',
          'role',
          'photoUrl',
          'phone',
          'ratingAvg',
          'ratingCount',
        ],
      );
      final val = AssignedPartnerOut(
        fullName: $checkedConvert('fullName', (v) => v as String),
        role: $checkedConvert('role', (v) => v as String),
        photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
        phone: $checkedConvert('phone', (v) => v as String),
        ratingAvg: $checkedConvert('ratingAvg', (v) => v as String?),
        ratingCount: $checkedConvert('ratingCount', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$AssignedPartnerOutToJson(AssignedPartnerOut instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'role': instance.role,
      'photoUrl': instance.photoUrl,
      'phone': instance.phone,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
    };
