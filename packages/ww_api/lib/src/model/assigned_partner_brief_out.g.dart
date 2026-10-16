// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assigned_partner_brief_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AssignedPartnerBriefOutCWProxy {
  AssignedPartnerBriefOut partnerId(String partnerId);

  AssignedPartnerBriefOut fullName(String fullName);

  AssignedPartnerBriefOut phone(String phone);

  AssignedPartnerBriefOut alternatePhone(String alternatePhone);

  AssignedPartnerBriefOut photoUrl(String? photoUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignedPartnerBriefOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignedPartnerBriefOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignedPartnerBriefOut call({
    String partnerId,
    String fullName,
    String phone,
    String alternatePhone,
    String? photoUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAssignedPartnerBriefOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAssignedPartnerBriefOut.copyWith.fieldName(...)`
class _$AssignedPartnerBriefOutCWProxyImpl
    implements _$AssignedPartnerBriefOutCWProxy {
  const _$AssignedPartnerBriefOutCWProxyImpl(this._value);

  final AssignedPartnerBriefOut _value;

  @override
  AssignedPartnerBriefOut partnerId(String partnerId) =>
      this(partnerId: partnerId);

  @override
  AssignedPartnerBriefOut fullName(String fullName) => this(fullName: fullName);

  @override
  AssignedPartnerBriefOut phone(String phone) => this(phone: phone);

  @override
  AssignedPartnerBriefOut alternatePhone(String alternatePhone) =>
      this(alternatePhone: alternatePhone);

  @override
  AssignedPartnerBriefOut photoUrl(String? photoUrl) =>
      this(photoUrl: photoUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AssignedPartnerBriefOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AssignedPartnerBriefOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AssignedPartnerBriefOut call({
    Object? partnerId = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? alternatePhone = const $CopyWithPlaceholder(),
    Object? photoUrl = const $CopyWithPlaceholder(),
  }) {
    return AssignedPartnerBriefOut(
      partnerId: partnerId == const $CopyWithPlaceholder()
          ? _value.partnerId
          // ignore: cast_nullable_to_non_nullable
          : partnerId as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      alternatePhone: alternatePhone == const $CopyWithPlaceholder()
          ? _value.alternatePhone
          // ignore: cast_nullable_to_non_nullable
          : alternatePhone as String,
      photoUrl: photoUrl == const $CopyWithPlaceholder()
          ? _value.photoUrl
          // ignore: cast_nullable_to_non_nullable
          : photoUrl as String?,
    );
  }
}

extension $AssignedPartnerBriefOutCopyWith on AssignedPartnerBriefOut {
  /// Returns a callable class that can be used as follows: `instanceOfAssignedPartnerBriefOut.copyWith(...)` or like so:`instanceOfAssignedPartnerBriefOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AssignedPartnerBriefOutCWProxy get copyWith =>
      _$AssignedPartnerBriefOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignedPartnerBriefOut _$AssignedPartnerBriefOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AssignedPartnerBriefOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'partnerId',
      'fullName',
      'phone',
      'alternatePhone',
      'photoUrl',
    ],
  );
  final val = AssignedPartnerBriefOut(
    partnerId: $checkedConvert('partnerId', (v) => v as String),
    fullName: $checkedConvert('fullName', (v) => v as String),
    phone: $checkedConvert('phone', (v) => v as String),
    alternatePhone: $checkedConvert('alternatePhone', (v) => v as String),
    photoUrl: $checkedConvert('photoUrl', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$AssignedPartnerBriefOutToJson(
  AssignedPartnerBriefOut instance,
) => <String, dynamic>{
  'partnerId': instance.partnerId,
  'fullName': instance.fullName,
  'phone': instance.phone,
  'alternatePhone': instance.alternatePhone,
  'photoUrl': instance.photoUrl,
};
