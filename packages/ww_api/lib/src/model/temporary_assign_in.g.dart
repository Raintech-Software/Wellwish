// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_assign_in.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TemporaryAssignInCWProxy {
  TemporaryAssignIn phone(String phone);

  TemporaryAssignIn fullName(String fullName);

  TemporaryAssignIn gender(TemporaryAssignInGenderEnum gender);

  TemporaryAssignIn idType(TemporaryAssignInIdTypeEnum idType);

  TemporaryAssignIn idLast4(String idLast4);

  TemporaryAssignIn idPhotoKey(String idPhotoKey);

  TemporaryAssignIn nursingRegNo(String? nursingRegNo);

  TemporaryAssignIn reason(String reason);

  TemporaryAssignIn idChecked(bool idChecked);

  TemporaryAssignIn expectedAssignmentId(String? expectedAssignmentId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemporaryAssignIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemporaryAssignIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TemporaryAssignIn call({
    String phone,
    String fullName,
    TemporaryAssignInGenderEnum gender,
    TemporaryAssignInIdTypeEnum idType,
    String idLast4,
    String idPhotoKey,
    String? nursingRegNo,
    String reason,
    bool idChecked,
    String? expectedAssignmentId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTemporaryAssignIn.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTemporaryAssignIn.copyWith.fieldName(...)`
class _$TemporaryAssignInCWProxyImpl implements _$TemporaryAssignInCWProxy {
  const _$TemporaryAssignInCWProxyImpl(this._value);

  final TemporaryAssignIn _value;

  @override
  TemporaryAssignIn phone(String phone) => this(phone: phone);

  @override
  TemporaryAssignIn fullName(String fullName) => this(fullName: fullName);

  @override
  TemporaryAssignIn gender(TemporaryAssignInGenderEnum gender) =>
      this(gender: gender);

  @override
  TemporaryAssignIn idType(TemporaryAssignInIdTypeEnum idType) =>
      this(idType: idType);

  @override
  TemporaryAssignIn idLast4(String idLast4) => this(idLast4: idLast4);

  @override
  TemporaryAssignIn idPhotoKey(String idPhotoKey) =>
      this(idPhotoKey: idPhotoKey);

  @override
  TemporaryAssignIn nursingRegNo(String? nursingRegNo) =>
      this(nursingRegNo: nursingRegNo);

  @override
  TemporaryAssignIn reason(String reason) => this(reason: reason);

  @override
  TemporaryAssignIn idChecked(bool idChecked) => this(idChecked: idChecked);

  @override
  TemporaryAssignIn expectedAssignmentId(String? expectedAssignmentId) =>
      this(expectedAssignmentId: expectedAssignmentId);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TemporaryAssignIn(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TemporaryAssignIn(...).copyWith(id: 12, name: "My name")
  /// ````
  TemporaryAssignIn call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? gender = const $CopyWithPlaceholder(),
    Object? idType = const $CopyWithPlaceholder(),
    Object? idLast4 = const $CopyWithPlaceholder(),
    Object? idPhotoKey = const $CopyWithPlaceholder(),
    Object? nursingRegNo = const $CopyWithPlaceholder(),
    Object? reason = const $CopyWithPlaceholder(),
    Object? idChecked = const $CopyWithPlaceholder(),
    Object? expectedAssignmentId = const $CopyWithPlaceholder(),
  }) {
    return TemporaryAssignIn(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      fullName: fullName == const $CopyWithPlaceholder()
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      gender: gender == const $CopyWithPlaceholder()
          ? _value.gender
          // ignore: cast_nullable_to_non_nullable
          : gender as TemporaryAssignInGenderEnum,
      idType: idType == const $CopyWithPlaceholder()
          ? _value.idType
          // ignore: cast_nullable_to_non_nullable
          : idType as TemporaryAssignInIdTypeEnum,
      idLast4: idLast4 == const $CopyWithPlaceholder()
          ? _value.idLast4
          // ignore: cast_nullable_to_non_nullable
          : idLast4 as String,
      idPhotoKey: idPhotoKey == const $CopyWithPlaceholder()
          ? _value.idPhotoKey
          // ignore: cast_nullable_to_non_nullable
          : idPhotoKey as String,
      nursingRegNo: nursingRegNo == const $CopyWithPlaceholder()
          ? _value.nursingRegNo
          // ignore: cast_nullable_to_non_nullable
          : nursingRegNo as String?,
      reason: reason == const $CopyWithPlaceholder()
          ? _value.reason
          // ignore: cast_nullable_to_non_nullable
          : reason as String,
      idChecked: idChecked == const $CopyWithPlaceholder()
          ? _value.idChecked
          // ignore: cast_nullable_to_non_nullable
          : idChecked as bool,
      expectedAssignmentId: expectedAssignmentId == const $CopyWithPlaceholder()
          ? _value.expectedAssignmentId
          // ignore: cast_nullable_to_non_nullable
          : expectedAssignmentId as String?,
    );
  }
}

extension $TemporaryAssignInCopyWith on TemporaryAssignIn {
  /// Returns a callable class that can be used as follows: `instanceOfTemporaryAssignIn.copyWith(...)` or like so:`instanceOfTemporaryAssignIn.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TemporaryAssignInCWProxy get copyWith =>
      _$TemporaryAssignInCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemporaryAssignIn _$TemporaryAssignInFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TemporaryAssignIn', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'phone',
          'fullName',
          'gender',
          'idType',
          'idLast4',
          'idPhotoKey',
          'reason',
          'idChecked',
          'expectedAssignmentId',
        ],
      );
      final val = TemporaryAssignIn(
        phone: $checkedConvert('phone', (v) => v as String),
        fullName: $checkedConvert('fullName', (v) => v as String),
        gender: $checkedConvert(
          'gender',
          (v) => $enumDecode(_$TemporaryAssignInGenderEnumEnumMap, v),
        ),
        idType: $checkedConvert(
          'idType',
          (v) => $enumDecode(_$TemporaryAssignInIdTypeEnumEnumMap, v),
        ),
        idLast4: $checkedConvert('idLast4', (v) => v as String),
        idPhotoKey: $checkedConvert('idPhotoKey', (v) => v as String),
        nursingRegNo: $checkedConvert(
          'nursingRegNo',
          (v) => v as String? ?? '',
        ),
        reason: $checkedConvert('reason', (v) => v as String),
        idChecked: $checkedConvert('idChecked', (v) => v as bool),
        expectedAssignmentId: $checkedConvert(
          'expectedAssignmentId',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$TemporaryAssignInToJson(TemporaryAssignIn instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'fullName': instance.fullName,
      'gender': _$TemporaryAssignInGenderEnumEnumMap[instance.gender]!,
      'idType': _$TemporaryAssignInIdTypeEnumEnumMap[instance.idType]!,
      'idLast4': instance.idLast4,
      'idPhotoKey': instance.idPhotoKey,
      'nursingRegNo': ?instance.nursingRegNo,
      'reason': instance.reason,
      'idChecked': instance.idChecked,
      'expectedAssignmentId': instance.expectedAssignmentId,
    };

const _$TemporaryAssignInGenderEnumEnumMap = {
  TemporaryAssignInGenderEnum.FEMALE: 'FEMALE',
  TemporaryAssignInGenderEnum.MALE: 'MALE',
  TemporaryAssignInGenderEnum.OTHER: 'OTHER',
};

const _$TemporaryAssignInIdTypeEnumEnumMap = {
  TemporaryAssignInIdTypeEnum.AADHAAR: 'AADHAAR',
  TemporaryAssignInIdTypeEnum.DRIVING_LICENCE: 'DRIVING_LICENCE',
  TemporaryAssignInIdTypeEnum.VOTER_ID: 'VOTER_ID',
  TemporaryAssignInIdTypeEnum.PAN: 'PAN',
};
