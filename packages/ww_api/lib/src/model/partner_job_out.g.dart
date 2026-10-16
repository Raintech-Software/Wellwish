// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_job_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PartnerJobOutCWProxy {
  PartnerJobOut id(String id);

  PartnerJobOut code(String code);

  PartnerJobOut status(String status);

  PartnerJobOut service(BookingServiceOut service);

  PartnerJobOut pickupAt(DateTime pickupAt);

  PartnerJobOut appointmentAt(DateTime? appointmentAt);

  PartnerJobOut memberName(String memberName);

  PartnerJobOut hospitalName(String hospitalName);

  PartnerJobOut area(String area);

  PartnerJobOut reconfirmNeeded(bool reconfirmNeeded);

  PartnerJobOut member(JobMemberOut member);

  PartnerJobOut bookerName(String bookerName);

  PartnerJobOut bookerPhone(String bookerPhone);

  PartnerJobOut address(BookingAddressOut address);

  PartnerJobOut hospitalText(String hospitalText);

  PartnerJobOut doctorName(String doctorName);

  PartnerJobOut notes(String notes);

  PartnerJobOut documents(List<BookingDocumentOut> documents);

  PartnerJobOut balancePaise(int balancePaise);

  PartnerJobOut visit(VisitOut? visit);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerJobOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerJobOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerJobOut call({
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
    JobMemberOut member,
    String bookerName,
    String bookerPhone,
    BookingAddressOut address,
    String hospitalText,
    String doctorName,
    String notes,
    List<BookingDocumentOut> documents,
    int balancePaise,
    VisitOut? visit,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPartnerJobOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPartnerJobOut.copyWith.fieldName(...)`
class _$PartnerJobOutCWProxyImpl implements _$PartnerJobOutCWProxy {
  const _$PartnerJobOutCWProxyImpl(this._value);

  final PartnerJobOut _value;

  @override
  PartnerJobOut id(String id) => this(id: id);

  @override
  PartnerJobOut code(String code) => this(code: code);

  @override
  PartnerJobOut status(String status) => this(status: status);

  @override
  PartnerJobOut service(BookingServiceOut service) => this(service: service);

  @override
  PartnerJobOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  PartnerJobOut appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  PartnerJobOut memberName(String memberName) => this(memberName: memberName);

  @override
  PartnerJobOut hospitalName(String hospitalName) =>
      this(hospitalName: hospitalName);

  @override
  PartnerJobOut area(String area) => this(area: area);

  @override
  PartnerJobOut reconfirmNeeded(bool reconfirmNeeded) =>
      this(reconfirmNeeded: reconfirmNeeded);

  @override
  PartnerJobOut member(JobMemberOut member) => this(member: member);

  @override
  PartnerJobOut bookerName(String bookerName) => this(bookerName: bookerName);

  @override
  PartnerJobOut bookerPhone(String bookerPhone) =>
      this(bookerPhone: bookerPhone);

  @override
  PartnerJobOut address(BookingAddressOut address) => this(address: address);

  @override
  PartnerJobOut hospitalText(String hospitalText) =>
      this(hospitalText: hospitalText);

  @override
  PartnerJobOut doctorName(String doctorName) => this(doctorName: doctorName);

  @override
  PartnerJobOut notes(String notes) => this(notes: notes);

  @override
  PartnerJobOut documents(List<BookingDocumentOut> documents) =>
      this(documents: documents);

  @override
  PartnerJobOut balancePaise(int balancePaise) =>
      this(balancePaise: balancePaise);

  @override
  PartnerJobOut visit(VisitOut? visit) => this(visit: visit);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PartnerJobOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PartnerJobOut(...).copyWith(id: 12, name: "My name")
  /// ````
  PartnerJobOut call({
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
    Object? member = const $CopyWithPlaceholder(),
    Object? bookerName = const $CopyWithPlaceholder(),
    Object? bookerPhone = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? hospitalText = const $CopyWithPlaceholder(),
    Object? doctorName = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? balancePaise = const $CopyWithPlaceholder(),
    Object? visit = const $CopyWithPlaceholder(),
  }) {
    return PartnerJobOut(
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
      member: member == const $CopyWithPlaceholder()
          ? _value.member
          // ignore: cast_nullable_to_non_nullable
          : member as JobMemberOut,
      bookerName: bookerName == const $CopyWithPlaceholder()
          ? _value.bookerName
          // ignore: cast_nullable_to_non_nullable
          : bookerName as String,
      bookerPhone: bookerPhone == const $CopyWithPlaceholder()
          ? _value.bookerPhone
          // ignore: cast_nullable_to_non_nullable
          : bookerPhone as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as BookingAddressOut,
      hospitalText: hospitalText == const $CopyWithPlaceholder()
          ? _value.hospitalText
          // ignore: cast_nullable_to_non_nullable
          : hospitalText as String,
      doctorName: doctorName == const $CopyWithPlaceholder()
          ? _value.doctorName
          // ignore: cast_nullable_to_non_nullable
          : doctorName as String,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<BookingDocumentOut>,
      balancePaise: balancePaise == const $CopyWithPlaceholder()
          ? _value.balancePaise
          // ignore: cast_nullable_to_non_nullable
          : balancePaise as int,
      visit: visit == const $CopyWithPlaceholder()
          ? _value.visit
          // ignore: cast_nullable_to_non_nullable
          : visit as VisitOut?,
    );
  }
}

extension $PartnerJobOutCopyWith on PartnerJobOut {
  /// Returns a callable class that can be used as follows: `instanceOfPartnerJobOut.copyWith(...)` or like so:`instanceOfPartnerJobOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PartnerJobOutCWProxy get copyWith => _$PartnerJobOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerJobOut _$PartnerJobOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PartnerJobOut', json, ($checkedConvert) {
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
      'member',
      'bookerName',
      'bookerPhone',
      'address',
      'hospitalText',
      'doctorName',
      'notes',
      'documents',
      'balancePaise',
    ],
  );
  final val = PartnerJobOut(
    id: $checkedConvert('id', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    service: $checkedConvert(
      'service',
      (v) => BookingServiceOut.fromJson(v as Map<String, dynamic>),
    ),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    appointmentAt: $checkedConvert(
      'appointmentAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    memberName: $checkedConvert('memberName', (v) => v as String),
    hospitalName: $checkedConvert('hospitalName', (v) => v as String),
    area: $checkedConvert('area', (v) => v as String),
    reconfirmNeeded: $checkedConvert('reconfirmNeeded', (v) => v as bool),
    member: $checkedConvert(
      'member',
      (v) => JobMemberOut.fromJson(v as Map<String, dynamic>),
    ),
    bookerName: $checkedConvert('bookerName', (v) => v as String),
    bookerPhone: $checkedConvert('bookerPhone', (v) => v as String),
    address: $checkedConvert(
      'address',
      (v) => BookingAddressOut.fromJson(v as Map<String, dynamic>),
    ),
    hospitalText: $checkedConvert('hospitalText', (v) => v as String),
    doctorName: $checkedConvert('doctorName', (v) => v as String),
    notes: $checkedConvert('notes', (v) => v as String),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => BookingDocumentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    balancePaise: $checkedConvert('balancePaise', (v) => (v as num).toInt()),
    visit: $checkedConvert(
      'visit',
      (v) => v == null ? null : VisitOut.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$PartnerJobOutToJson(PartnerJobOut instance) =>
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
      'member': instance.member.toJson(),
      'bookerName': instance.bookerName,
      'bookerPhone': instance.bookerPhone,
      'address': instance.address.toJson(),
      'hospitalText': instance.hospitalText,
      'doctorName': instance.doctorName,
      'notes': instance.notes,
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'balancePaise': instance.balancePaise,
      'visit': ?instance.visit?.toJson(),
    };
