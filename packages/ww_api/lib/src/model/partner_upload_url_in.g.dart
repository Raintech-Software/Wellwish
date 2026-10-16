// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_upload_url_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerUploadUrlInCWProxy {
  PartnerUploadUrlIn purpose(PartnerUploadUrlInPurposeEnum purpose);

  PartnerUploadUrlIn mime(String mime);

  PartnerUploadUrlIn sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerUploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerUploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerUploadUrlIn call({
    PartnerUploadUrlInPurposeEnum purpose,
    String mime,
    int sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerUploadUrlIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerUploadUrlIn.copyWith.fieldName(...)`
class _$PartnerUploadUrlInCWProxyImpl implements _$PartnerUploadUrlInCWProxy {
  const _$PartnerUploadUrlInCWProxyImpl(this._value);

  final PartnerUploadUrlIn _value;

  @override
  PartnerUploadUrlIn purpose(PartnerUploadUrlInPurposeEnum purpose) =>
      this(purpose: purpose);

  @override
  PartnerUploadUrlIn mime(String mime) => this(mime: mime);

  @override
  PartnerUploadUrlIn sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerUploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerUploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerUploadUrlIn call({
    Object? purpose = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return PartnerUploadUrlIn(
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as PartnerUploadUrlInPurposeEnum,
      mime: mime == const $CopyWithPlaceholder()
          ? _value.mime
          // ignore: cast_nullable_to_non_nullable
          : mime as String,
      sizeBytes: sizeBytes == const $CopyWithPlaceholder()
          ? _value.sizeBytes
          // ignore: cast_nullable_to_non_nullable
          : sizeBytes as int,
    );
  }
}

extension $PartnerUploadUrlInCopyWith on PartnerUploadUrlIn {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerUploadUrlIn.copyWith(...)` or like so:`instanceOfPartnerUploadUrlIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerUploadUrlInCWProxy get copyWith =>
      _$PartnerUploadUrlInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerUploadUrlIn _$PartnerUploadUrlInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerUploadUrlIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['purpose', 'mime', 'sizeBytes']);
      final val = PartnerUploadUrlIn(
        purpose: $checkedConvert(
          'purpose',
          (v) => $enumDecode(_$PartnerUploadUrlInPurposeEnumEnumMap, v),
        ),
        mime: $checkedConvert('mime', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PartnerUploadUrlInToJson(PartnerUploadUrlIn instance) =>
    <String, dynamic>{
      'purpose': _$PartnerUploadUrlInPurposeEnumEnumMap[instance.purpose]!,
      'mime': instance.mime,
      'sizeBytes': instance.sizeBytes,
    };

const _$PartnerUploadUrlInPurposeEnumEnumMap = {
  PartnerUploadUrlInPurposeEnum.partnerPhoto: 'partner_photo',
  PartnerUploadUrlInPurposeEnum.kycDocument: 'kyc_document',
  PartnerUploadUrlInPurposeEnum.partnerSelfie: 'partner_selfie',
};
