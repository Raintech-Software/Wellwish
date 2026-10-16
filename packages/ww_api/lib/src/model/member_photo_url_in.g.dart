// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_photo_url_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MemberPhotoUrlInCWProxy {
  MemberPhotoUrlIn mime(String mime);

  MemberPhotoUrlIn sizeBytes(int sizeBytes);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberPhotoUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberPhotoUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberPhotoUrlIn call({String mime, int sizeBytes});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMemberPhotoUrlIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMemberPhotoUrlIn.copyWith.fieldName(...)`
class _$MemberPhotoUrlInCWProxyImpl implements _$MemberPhotoUrlInCWProxy {
  const _$MemberPhotoUrlInCWProxyImpl(this._value);

  final MemberPhotoUrlIn _value;

  @override
  MemberPhotoUrlIn mime(String mime) => this(mime: mime);

  @override
  MemberPhotoUrlIn sizeBytes(int sizeBytes) => this(sizeBytes: sizeBytes);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MemberPhotoUrlIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MemberPhotoUrlIn(...).copyWith(id: 12, name: "My name")
  /// ````
  MemberPhotoUrlIn call({
    Object? mime = const $CopyWithPlaceholder(),
    Object? sizeBytes = const $CopyWithPlaceholder(),
  }) {
    return MemberPhotoUrlIn(
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

extension $MemberPhotoUrlInCopyWith on MemberPhotoUrlIn {
  /// Returns a callable class that can be used as follows: `instanceOfMemberPhotoUrlIn.copyWith(...)` or like so:`instanceOfMemberPhotoUrlIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MemberPhotoUrlInCWProxy get copyWith => _$MemberPhotoUrlInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberPhotoUrlIn _$MemberPhotoUrlInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MemberPhotoUrlIn', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['mime', 'sizeBytes']);
      final val = MemberPhotoUrlIn(
        mime: $checkedConvert('mime', (v) => v as String),
        sizeBytes: $checkedConvert('sizeBytes', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MemberPhotoUrlInToJson(MemberPhotoUrlIn instance) =>
    <String, dynamic>{'mime': instance.mime, 'sizeBytes': instance.sizeBytes};
