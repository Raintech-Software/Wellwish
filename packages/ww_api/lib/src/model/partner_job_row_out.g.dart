// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_job_row_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerJobRowOutCWProxy {
  PartnerJobRowOut id(String id);

  PartnerJobRowOut code(String code);

  PartnerJobRowOut status(String status);

  PartnerJobRowOut service(BookingServiceOut service);

  PartnerJobRowOut pickupAt(DateTime pickupAt);

  PartnerJobRowOut appointmentAt(DateTime? appointmentAt);

  PartnerJobRowOut memberName(String memberName);

  PartnerJobRowOut hospitalName(String hospitalName);

  PartnerJobRowOut area(String area);

  PartnerJobRowOut reconfirmNeeded(bool reconfirmNeeded);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerJobRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerJobRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerJobRowOut call({
    String id,
    String code,
    String status,
    BookingServiceOut service,
    DateTime pickupAt,
    DateTime? appointmentAt,
    String memberName,
    String hospitalName,
    String area,
    bool reconfirmNeeded,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerJobRowOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerJobRowOut.copyWith.fieldName(...)`
class _$PartnerJobRowOutCWProxyImpl implements _$PartnerJobRowOutCWProxy {
  const _$PartnerJobRowOutCWProxyImpl(this._value);

  final PartnerJobRowOut _value;

  @override
  PartnerJobRowOut id(String id) => this(id: id);

  @override
  PartnerJobRowOut code(String code) => this(code: code);

  @override
  PartnerJobRowOut status(String status) => this(status: status);

  @override
  PartnerJobRowOut service(BookingServiceOut service) => this(service: service);

  @override
  PartnerJobRowOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  PartnerJobRowOut appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  PartnerJobRowOut memberName(String memberName) =>
      this(memberName: memberName);

  @override
  PartnerJobRowOut hospitalName(String hospitalName) =>
      this(hospitalName: hospitalName);

  @override
  PartnerJobRowOut area(String area) => this(area: area);

  @override
  PartnerJobRowOut reconfirmNeeded(bool reconfirmNeeded) =>
      this(reconfirmNeeded: reconfirmNeeded);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerJobRowOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerJobRowOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerJobRowOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? hospitalName = const $CopyWithPlaceholder(),
    Object? area = const $CopyWithPlaceholder(),
    Object? reconfirmNeeded = const $CopyWithPlaceholder(),
  }) {
    return PartnerJobRowOut(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      code: code == const $CopyWithPlaceholder()
          ? _value.code
          // ignore: cast_nullable_to_non_nullable
          : code as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      service: service == const $CopyWithPlaceholder()
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as BookingServiceOut,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      appointmentAt: appointmentAt == const $CopyWithPlaceholder()
          ? _value.appointmentAt
          // ignore: cast_nullable_to_non_nullable
          : appointmentAt as DateTime?,
      memberName: memberName == const $CopyWithPlaceholder()
          ? _value.memberName
          // ignore: cast_nullable_to_non_nullable
          : memberName as String,
      hospitalName: hospitalName == const $CopyWithPlaceholder()
          ? _value.hospitalName
          // ignore: cast_nullable_to_non_nullable
          : hospitalName as String,
      area: area == const $CopyWithPlaceholder()
          ? _value.area
          // ignore: cast_nullable_to_non_nullable
          : area as String,
      reconfirmNeeded: reconfirmNeeded == const $CopyWithPlaceholder()
          ? _value.reconfirmNeeded
          // ignore: cast_nullable_to_non_nullable
          : reconfirmNeeded as bool,
    );
  }
}

extension $PartnerJobRowOutCopyWith on PartnerJobRowOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerJobRowOut.copyWith(...)` or like so:`instanceOfPartnerJobRowOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerJobRowOutCWProxy get copyWith => _$PartnerJobRowOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerJobRowOut _$PartnerJobRowOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PartnerJobRowOut', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'code',
          'status',
          'service',
          'pickupAt',
          'appointmentAt',
          'memberName',
          'hospitalName',
          'area',
          'reconfirmNeeded',
        ],
      );
      final val = PartnerJobRowOut(
        id: $checkedConvert('id', (v) => v as String),
        code: $checkedConvert('code', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        service: $checkedConvert(
          'service',
          (v) => BookingServiceOut.fromJson(v as Map<String, dynamic>),
        ),
        pickupAt: $checkedConvert(
          'pickupAt',
          (v) => DateTime.parse(v as String),
        ),
        appointmentAt: $checkedConvert(
          'appointmentAt',
          (v) => v == null ? null : DateTime.parse(v as String),
        ),
        memberName: $checkedConvert('memberName', (v) => v as String),
        hospitalName: $checkedConvert('hospitalName', (v) => v as String),
        area: $checkedConvert('area', (v) => v as String),
        reconfirmNeeded: $checkedConvert('reconfirmNeeded', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$PartnerJobRowOutToJson(PartnerJobRowOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'service': instance.service.toJson(),
      'pickupAt': instance.pickupAt.toIso8601String(),
      'appointmentAt': instance.appointmentAt?.toIso8601String(),
      'memberName': instance.memberName,
      'hospitalName': instance.hospitalName,
      'area': instance.area,
      'reconfirmNeeded': instance.reconfirmNeeded,
    };
