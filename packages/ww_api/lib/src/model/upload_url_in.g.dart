// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_url_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadUrlInCWProxy {
  UploadUrlIn purpose(UploadUrlInPurposeEnum purpose);

  UploadUrlIn mime(String mime);

  UploadUrlIn sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadUrlIn call({
    UploadUrlInPurposeEnum purpose,
    String mime,
    int sizeBytes,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadUrlIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadUrlIn.copyWith.fieldName(...)`
class _$UploadUrlInCWProxyImpl implements _$UploadUrlInCWProxy {
  const _$UploadUrlInCWProxyImpl(this._value);

  final UploadUrlIn _value;

  @override
  UploadUrlIn purpose(UploadUrlInPurposeEnum purpose) => this(purpose: purpose);

  @override
  UploadUrlIn mime(String mime) => this(mime: mime);

  @override
  UploadUrlIn sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadUrlIn call({
    Object? purpose = const $CopyWithPlaceholder(),
    Object? mime = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return UploadUrlIn(
      purpose: purpose == const $CopyWithPlaceholder()
          ? _value.purpose
          // ignore: cast_nullable_to_non_nullable
          : purpose as UploadUrlInPurposeEnum,
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

extension $UploadUrlInCopyWith on UploadUrlIn {
  /// Returns a callable class that can be used as follows: `instanceOfUploadUrlIn.copyWith(...)` or like so:`instanceOfUploadUrlIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadUrlInCWProxy get copyWith => _$UploadUrlInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadUrlIn _$UploadUrlInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadUrlIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['purpose', 'mime', 'sizeBytes']);
      final val = UploadUrlIn(
        purpose: $checkedConvert(
          'purpose',
          (v) => $enumDecode(_$UploadUrlInPurposeEnumEnumMap, v),
        ),
        mime: $checkedConvert('mime', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$UploadUrlInToJson(UploadUrlIn instance) =>
    <String, dynamic>{
      'purpose': _$UploadUrlInPurposeEnumEnumMap[instance.purpose]!,
      'mime': instance.mime,
      'sizeBytes': instance.sizeBytes,
    };

const _$UploadUrlInPurposeEnumEnumMap = {
  UploadUrlInPurposeEnum.hospitalPhoto: 'hospital_photo',
  UploadUrlInPurposeEnum.doctorPhoto: 'doctor_photo',
  UploadUrlInPurposeEnum.partnerPhoto: 'partner_photo',
  UploadUrlInPurposeEnum.kycDocument: 'kyc_document',
  UploadUrlInPurposeEnum.tempPartnerId: 'temp_partner_id',
};
