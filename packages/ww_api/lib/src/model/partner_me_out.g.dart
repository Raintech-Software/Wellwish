// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_me_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerMeOutCWProxy {
  PartnerMeOut id(String id);

  PartnerMeOut phone(String phone);

  PartnerMeOut language(String language);

  PartnerMeOut partnerStatus(String? partnerStatus);

  PartnerMeOut role(String? role);

  PartnerMeOut temporaryBookingId(String? temporaryBookingId);

  PartnerMeOut selfieToday(bool? selfieToday);

  PartnerMeOut consentsNeeded(List<ConsentNeededOut>? consentsNeeded);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerMeOut call({
    String id,
    String phone,
    String language,
    String? partnerStatus,
    String? role,
    String? temporaryBookingId,
    bool? selfieToday,
    List<ConsentNeededOut>? consentsNeeded,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerMeOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerMeOut.copyWith.fieldName(...)`
class _$PartnerMeOutCWProxyImpl implements _$PartnerMeOutCWProxy {
  const _$PartnerMeOutCWProxyImpl(this._value);

  final PartnerMeOut _value;

  @override
  PartnerMeOut id(String id) => this(id: id);

  @override
  PartnerMeOut phone(String phone) => this(phone: phone);

  @override
  PartnerMeOut language(String language) => this(language: language);

  @override
  PartnerMeOut partnerStatus(String? partnerStatus) =>
      this(partnerStatus: partnerStatus);

  @override
  PartnerMeOut role(String? role) => this(role: role);

  @override
  PartnerMeOut temporaryBookingId(String? temporaryBookingId) =>
      this(temporaryBookingId: temporaryBookingId);

  @override
  PartnerMeOut selfieToday(bool? selfieToday) => this(selfieToday: selfieToday);

  @override
  PartnerMeOut consentsNeeded(List<ConsentNeededOut>? consentsNeeded) =>
      this(consentsNeeded: consentsNeeded);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerMeOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerMeOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerMeOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? language = const $CopyWithPlaceholder(),
    Object? partnerStatus = const $CopyWithPlaceholder(),
    Object? role = const $CopyWithPlaceholder(),
    Object? temporaryBookingId = const $CopyWithPlaceholder(),
    Object? selfieToday = const $CopyWithPlaceholder(),
    Object? consentsNeeded = const $CopyWithPlaceholder(),
  }) {
    return PartnerMeOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      language: language == const $CopyWithPlaceholder()
          ? _value.language
          // ignore: cast_nullable_to_non_nullable
          : language as String,
      partnerStatus: partnerStatus == const $CopyWithPlaceholder()
          ? _value.partnerStatus
          // ignore: cast_nullable_to_non_nullable
          : partnerStatus as String?,
      role: role == const $CopyWithPlaceholder()
          ? _value.role
          // ignore: cast_nullable_to_non_nullable
          : role as String?,
      temporaryBookingId: temporaryBookingId == const $CopyWithPlaceholder()
          ? _value.temporaryBookingId
          // ignore: cast_nullable_to_non_nullable
          : temporaryBookingId as String?,
      selfieToday: selfieToday == const $CopyWithPlaceholder()
          ? _value.selfieToday
          // ignore: cast_nullable_to_non_nullable
          : selfieToday as bool?,
      consentsNeeded: consentsNeeded == const $CopyWithPlaceholder()
          ? _value.consentsNeeded
          // ignore: cast_nullable_to_non_nullable
          : consentsNeeded as List<ConsentNeededOut>?,
    );
  }
}

extension $PartnerMeOutCopyWith on PartnerMeOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerMeOut.copyWith(...)` or like so:`instanceOfPartnerMeOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerMeOutCWProxy get copyWith => _$PartnerMeOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerMeOut _$PartnerMeOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerMeOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'phone', 'language']);
      final val = PartnerMeOut(
        id: $checkedConvert('id', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        language: $checkedConvert('language', (v) => v as String),
        partnerStatus: $checkedConvert('partnerStatus', (v) => v as String?),
        role: $checkedConvert('role', (v) => v as String?),
        temporaryBookingId: $checkedConvert(
          'temporaryBookingId',
          (v) => v as String?,
        ),
        selfieToday: $checkedConvert('selfieToday', (v) => v as bool? ?? false),
        consentsNeeded: $checkedConvert(
          'consentsNeeded',
          (v) => (v as List<dynamic>?)
              ?.map((e) => ConsentNeededOut.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PartnerMeOutToJson(
  PartnerMeOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'language': instance.language,
  'partnerStatus': ?instance.partnerStatus,
  'role': ?instance.role,
  'temporaryBookingId': ?instance.temporaryBookingId,
  'selfieToday': ?instance.selfieToday,
  'consentsNeeded': ?instance.consentsNeeded?.map((e) => e.toJson()).toList(),
};
