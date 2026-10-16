// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_booking_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdminBookingDetailOutCWProxy {
  AdminBookingDetailOut id(String id);

  AdminBookingDetailOut code(String code);

  AdminBookingDetailOut status(String status);

  AdminBookingDetailOut patientDeleted(bool patientDeleted);

  AdminBookingDetailOut serviceName(String serviceName);

  AdminBookingDetailOut partnerType(String partnerType);

  AdminBookingDetailOut visitType(String visitType);

  AdminBookingDetailOut pickupAt(DateTime pickupAt);

  AdminBookingDetailOut appointmentAt(DateTime? appointmentAt);

  AdminBookingDetailOut memberName(String memberName);

  AdminBookingDetailOut patientPhone(String patientPhone);

  AdminBookingDetailOut hospitalName(String hospitalName);

  AdminBookingDetailOut bookingFeePaise(int bookingFeePaise);

  AdminBookingDetailOut createdAt(DateTime createdAt);

  AdminBookingDetailOut temporaryPartner(bool? temporaryPartner);

  AdminBookingDetailOut service(BookingServiceOut service);

  AdminBookingDetailOut patient(AdminBookingPatientOut patient);

  AdminBookingDetailOut member(BookingMemberOut member);

  AdminBookingDetailOut address(BookingAddressOut address);

  AdminBookingDetailOut hospitalId(String? hospitalId);

  AdminBookingDetailOut hospitalText(String hospitalText);

  AdminBookingDetailOut doctorId(String? doctorId);

  AdminBookingDetailOut doctorName(String doctorName);

  AdminBookingDetailOut notes(String notes);

  AdminBookingDetailOut notesVisible(bool notesVisible);

  AdminBookingDetailOut rescheduleCount(int rescheduleCount);

  AdminBookingDetailOut documentsVisible(bool documentsVisible);

  AdminBookingDetailOut documents(List<BookingDocumentOut> documents);

  AdminBookingDetailOut timeline(List<AdminBookingEventOut> timeline);

  AdminBookingDetailOut reconfirmNeeded(bool reconfirmNeeded);

  AdminBookingDetailOut payments(List<AdminPaymentOut> payments);

  AdminBookingDetailOut refunds(List<AdminRefundOut> refunds);

  AdminBookingDetailOut canCancel(bool canCancel);

  AdminBookingDetailOut canReschedule(bool canReschedule);

  AdminBookingDetailOut timeStepMin(int timeStepMin);

  AdminBookingDetailOut visit(VisitOut? visit);

  AdminBookingDetailOut paidPaise(int paidPaise);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingDetailOut call({
    String id,
    String code,
    String status,
    bool patientDeleted,
    String serviceName,
    String partnerType,
    String visitType,
    DateTime pickupAt,
    DateTime? appointmentAt,
    String memberName,
    String patientPhone,
    String hospitalName,
    int bookingFeePaise,
    DateTime createdAt,
    bool? temporaryPartner,
    BookingServiceOut service,
    AdminBookingPatientOut patient,
    BookingMemberOut member,
    BookingAddressOut address,
    String? hospitalId,
    String hospitalText,
    String? doctorId,
    String doctorName,
    String notes,
    bool notesVisible,
    int rescheduleCount,
    bool documentsVisible,
    List<BookingDocumentOut> documents,
    List<AdminBookingEventOut> timeline,
    bool reconfirmNeeded,
    List<AdminPaymentOut> payments,
    List<AdminRefundOut> refunds,
    bool canCancel,
    bool canReschedule,
    int timeStepMin,
    VisitOut? visit,
    int paidPaise,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdminBookingDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdminBookingDetailOut.copyWith.fieldName(...)`
class _$AdminBookingDetailOutCWProxyImpl
    implements _$AdminBookingDetailOutCWProxy {
  const _$AdminBookingDetailOutCWProxyImpl(this._value);

  final AdminBookingDetailOut _value;

  @override
  AdminBookingDetailOut id(String id) => this(id: id);

  @override
  AdminBookingDetailOut code(String code) => this(code: code);

  @override
  AdminBookingDetailOut status(String status) => this(status: status);

  @override
  AdminBookingDetailOut patientDeleted(bool patientDeleted) =>
      this(patientDeleted: patientDeleted);

  @override
  AdminBookingDetailOut serviceName(String serviceName) =>
      this(serviceName: serviceName);

  @override
  AdminBookingDetailOut partnerType(String partnerType) =>
      this(partnerType: partnerType);

  @override
  AdminBookingDetailOut visitType(String visitType) =>
      this(visitType: visitType);

  @override
  AdminBookingDetailOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  AdminBookingDetailOut appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  AdminBookingDetailOut memberName(String memberName) =>
      this(memberName: memberName);

  @override
  AdminBookingDetailOut patientPhone(String patientPhone) =>
      this(patientPhone: patientPhone);

  @override
  AdminBookingDetailOut hospitalName(String hospitalName) =>
      this(hospitalName: hospitalName);

  @override
  AdminBookingDetailOut bookingFeePaise(int bookingFeePaise) =>
      this(bookingFeePaise: bookingFeePaise);

  @override
  AdminBookingDetailOut createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  AdminBookingDetailOut temporaryPartner(bool? temporaryPartner) =>
      this(temporaryPartner: temporaryPartner);

  @override
  AdminBookingDetailOut service(BookingServiceOut service) =>
      this(service: service);

  @override
  AdminBookingDetailOut patient(AdminBookingPatientOut patient) =>
      this(patient: patient);

  @override
  AdminBookingDetailOut member(BookingMemberOut member) => this(member: member);

  @override
  AdminBookingDetailOut address(BookingAddressOut address) =>
      this(address: address);

  @override
  AdminBookingDetailOut hospitalId(String? hospitalId) =>
      this(hospitalId: hospitalId);

  @override
  AdminBookingDetailOut hospitalText(String hospitalText) =>
      this(hospitalText: hospitalText);

  @override
  AdminBookingDetailOut doctorId(String? doctorId) => this(doctorId: doctorId);

  @override
  AdminBookingDetailOut doctorName(String doctorName) =>
      this(doctorName: doctorName);

  @override
  AdminBookingDetailOut notes(String notes) => this(notes: notes);

  @override
  AdminBookingDetailOut notesVisible(bool notesVisible) =>
      this(notesVisible: notesVisible);

  @override
  AdminBookingDetailOut rescheduleCount(int rescheduleCount) =>
      this(rescheduleCount: rescheduleCount);

  @override
  AdminBookingDetailOut documentsVisible(bool documentsVisible) =>
      this(documentsVisible: documentsVisible);

  @override
  AdminBookingDetailOut documents(List<BookingDocumentOut> documents) =>
      this(documents: documents);

  @override
  AdminBookingDetailOut timeline(List<AdminBookingEventOut> timeline) =>
      this(timeline: timeline);

  @override
  AdminBookingDetailOut reconfirmNeeded(bool reconfirmNeeded) =>
      this(reconfirmNeeded: reconfirmNeeded);

  @override
  AdminBookingDetailOut payments(List<AdminPaymentOut> payments) =>
      this(payments: payments);

  @override
  AdminBookingDetailOut refunds(List<AdminRefundOut> refunds) =>
      this(refunds: refunds);

  @override
  AdminBookingDetailOut canCancel(bool canCancel) => this(canCancel: canCancel);

  @override
  AdminBookingDetailOut canReschedule(bool canReschedule) =>
      this(canReschedule: canReschedule);

  @override
  AdminBookingDetailOut timeStepMin(int timeStepMin) =>
      this(timeStepMin: timeStepMin);

  @override
  AdminBookingDetailOut visit(VisitOut? visit) => this(visit: visit);

  @override
  AdminBookingDetailOut paidPaise(int paidPaise) => this(paidPaise: paidPaise);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdminBookingDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdminBookingDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  AdminBookingDetailOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? patientDeleted = const $CopyWithPlaceholder(),
    Object? serviceName = const $CopyWithPlaceholder(),
    Object? partnerType = const $CopyWithPlaceholder(),
    Object? visitType = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? patientPhone = const $CopyWithPlaceholder(),
    Object? hospitalName = const $CopyWithPlaceholder(),
    Object? bookingFeePaise = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? temporaryPartner = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? patient = const $CopyWithPlaceholder(),
    Object? member = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? hospitalId = const $CopyWithPlaceholder(),
    Object? hospitalText = const $CopyWithPlaceholder(),
    Object? doctorId = const $CopyWithPlaceholder(),
    Object? doctorName = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? notesVisible = const $CopyWithPlaceholder(),
    Object? rescheduleCount = const $CopyWithPlaceholder(),
    Object? documentsVisible = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? timeline = const $CopyWithPlaceholder(),
    Object? reconfirmNeeded = const $CopyWithPlaceholder(),
    Object? payments = const $CopyWithPlaceholder(),
    Object? refunds = const $CopyWithPlaceholder(),
    Object? canCancel = const $CopyWithPlaceholder(),
    Object? canReschedule = const $CopyWithPlaceholder(),
    Object? timeStepMin = const $CopyWithPlaceholder(),
    Object? visit = const $CopyWithPlaceholder(),
    Object? paidPaise = const $CopyWithPlaceholder(),
  }) {
    return AdminBookingDetailOut(
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
      patientDeleted: patientDeleted == const $CopyWithPlaceholder()
          ? _value.patientDeleted
          // ignore: cast_nullable_to_non_nullable
          : patientDeleted as bool,
      serviceName: serviceName == const $CopyWithPlaceholder()
          ? _value.serviceName
          // ignore: cast_nullable_to_non_nullable
          : serviceName as String,
      partnerType: partnerType == const $CopyWithPlaceholder()
          ? _value.partnerType
          // ignore: cast_nullable_to_non_nullable
          : partnerType as String,
      visitType: visitType == const $CopyWithPlaceholder()
          ? _value.visitType
          // ignore: cast_nullable_to_non_nullable
          : visitType as String,
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
      patientPhone: patientPhone == const $CopyWithPlaceholder()
          ? _value.patientPhone
          // ignore: cast_nullable_to_non_nullable
          : patientPhone as String,
      hospitalName: hospitalName == const $CopyWithPlaceholder()
          ? _value.hospitalName
          // ignore: cast_nullable_to_non_nullable
          : hospitalName as String,
      bookingFeePaise: bookingFeePaise == const $CopyWithPlaceholder()
          ? _value.bookingFeePaise
          // ignore: cast_nullable_to_non_nullable
          : bookingFeePaise as int,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      temporaryPartner: temporaryPartner == const $CopyWithPlaceholder()
          ? _value.temporaryPartner
          // ignore: cast_nullable_to_non_nullable
          : temporaryPartner as bool?,
      service: service == const $CopyWithPlaceholder()
          ? _value.service
          // ignore: cast_nullable_to_non_nullable
          : service as BookingServiceOut,
      patient: patient == const $CopyWithPlaceholder()
          ? _value.patient
          // ignore: cast_nullable_to_non_nullable
          : patient as AdminBookingPatientOut,
      member: member == const $CopyWithPlaceholder()
          ? _value.member
          // ignore: cast_nullable_to_non_nullable
          : member as BookingMemberOut,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as BookingAddressOut,
      hospitalId: hospitalId == const $CopyWithPlaceholder()
          ? _value.hospitalId
          // ignore: cast_nullable_to_non_nullable
          : hospitalId as String?,
      hospitalText: hospitalText == const $CopyWithPlaceholder()
          ? _value.hospitalText
          // ignore: cast_nullable_to_non_nullable
          : hospitalText as String,
      doctorId: doctorId == const $CopyWithPlaceholder()
          ? _value.doctorId
          // ignore: cast_nullable_to_non_nullable
          : doctorId as String?,
      doctorName: doctorName == const $CopyWithPlaceholder()
          ? _value.doctorName
          // ignore: cast_nullable_to_non_nullable
          : doctorName as String,
      notes: notes == const $CopyWithPlaceholder()
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
      notesVisible: notesVisible == const $CopyWithPlaceholder()
          ? _value.notesVisible
          // ignore: cast_nullable_to_non_nullable
          : notesVisible as bool,
      rescheduleCount: rescheduleCount == const $CopyWithPlaceholder()
          ? _value.rescheduleCount
          // ignore: cast_nullable_to_non_nullable
          : rescheduleCount as int,
      documentsVisible: documentsVisible == const $CopyWithPlaceholder()
          ? _value.documentsVisible
          // ignore: cast_nullable_to_non_nullable
          : documentsVisible as bool,
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<BookingDocumentOut>,
      timeline: timeline == const $CopyWithPlaceholder()
          ? _value.timeline
          // ignore: cast_nullable_to_non_nullable
          : timeline as List<AdminBookingEventOut>,
      reconfirmNeeded: reconfirmNeeded == const $CopyWithPlaceholder()
          ? _value.reconfirmNeeded
          // ignore: cast_nullable_to_non_nullable
          : reconfirmNeeded as bool,
      payments: payments == const $CopyWithPlaceholder()
          ? _value.payments
          // ignore: cast_nullable_to_non_nullable
          : payments as List<AdminPaymentOut>,
      refunds: refunds == const $CopyWithPlaceholder()
          ? _value.refunds
          // ignore: cast_nullable_to_non_nullable
          : refunds as List<AdminRefundOut>,
      canCancel: canCancel == const $CopyWithPlaceholder()
          ? _value.canCancel
          // ignore: cast_nullable_to_non_nullable
          : canCancel as bool,
      canReschedule: canReschedule == const $CopyWithPlaceholder()
          ? _value.canReschedule
          // ignore: cast_nullable_to_non_nullable
          : canReschedule as bool,
      timeStepMin: timeStepMin == const $CopyWithPlaceholder()
          ? _value.timeStepMin
          // ignore: cast_nullable_to_non_nullable
          : timeStepMin as int,
      visit: visit == const $CopyWithPlaceholder()
          ? _value.visit
          // ignore: cast_nullable_to_non_nullable
          : visit as VisitOut?,
      paidPaise: paidPaise == const $CopyWithPlaceholder()
          ? _value.paidPaise
          // ignore: cast_nullable_to_non_nullable
          : paidPaise as int,
    );
  }
}

extension $AdminBookingDetailOutCopyWith on AdminBookingDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfAdminBookingDetailOut.copyWith(...)` or like so:`instanceOfAdminBookingDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdminBookingDetailOutCWProxy get copyWith =>
      _$AdminBookingDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminBookingDetailOut _$AdminBookingDetailOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AdminBookingDetailOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'code',
      'status',
      'patientDeleted',
      'serviceName',
      'partnerType',
      'visitType',
      'pickupAt',
      'appointmentAt',
      'memberName',
      'patientPhone',
      'hospitalName',
      'bookingFeePaise',
      'createdAt',
      'service',
      'patient',
      'member',
      'address',
      'hospitalId',
      'hospitalText',
      'doctorId',
      'doctorName',
      'notes',
      'notesVisible',
      'rescheduleCount',
      'documentsVisible',
      'documents',
      'timeline',
      'reconfirmNeeded',
      'payments',
      'refunds',
      'canCancel',
      'canReschedule',
      'timeStepMin',
      'paidPaise',
    ],
  );
  final val = AdminBookingDetailOut(
    id: $checkedConvert('id', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    patientDeleted: $checkedConvert('patientDeleted', (v) => v as bool),
    serviceName: $checkedConvert('serviceName', (v) => v as String),
    partnerType: $checkedConvert('partnerType', (v) => v as String),
    visitType: $checkedConvert('visitType', (v) => v as String),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    appointmentAt: $checkedConvert(
      'appointmentAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    memberName: $checkedConvert('memberName', (v) => v as String),
    patientPhone: $checkedConvert('patientPhone', (v) => v as String),
    hospitalName: $checkedConvert('hospitalName', (v) => v as String),
    bookingFeePaise: $checkedConvert(
      'bookingFeePaise',
      (v) => (v as num).toInt(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    temporaryPartner: $checkedConvert(
      'temporaryPartner',
      (v) => v as bool? ?? false,
    ),
    service: $checkedConvert(
      'service',
      (v) => BookingServiceOut.fromJson(v as Map<String, dynamic>),
    ),
    patient: $checkedConvert(
      'patient',
      (v) => AdminBookingPatientOut.fromJson(v as Map<String, dynamic>),
    ),
    member: $checkedConvert(
      'member',
      (v) => BookingMemberOut.fromJson(v as Map<String, dynamic>),
    ),
    address: $checkedConvert(
      'address',
      (v) => BookingAddressOut.fromJson(v as Map<String, dynamic>),
    ),
    hospitalId: $checkedConvert('hospitalId', (v) => v as String?),
    hospitalText: $checkedConvert('hospitalText', (v) => v as String),
    doctorId: $checkedConvert('doctorId', (v) => v as String?),
    doctorName: $checkedConvert('doctorName', (v) => v as String),
    notes: $checkedConvert('notes', (v) => v as String),
    notesVisible: $checkedConvert('notesVisible', (v) => v as bool),
    rescheduleCount: $checkedConvert(
      'rescheduleCount',
      (v) => (v as num).toInt(),
    ),
    documentsVisible: $checkedConvert('documentsVisible', (v) => v as bool),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => BookingDocumentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    timeline: $checkedConvert(
      'timeline',
      (v) => (v as List<dynamic>)
          .map((e) => AdminBookingEventOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    reconfirmNeeded: $checkedConvert('reconfirmNeeded', (v) => v as bool),
    payments: $checkedConvert(
      'payments',
      (v) => (v as List<dynamic>)
          .map((e) => AdminPaymentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    refunds: $checkedConvert(
      'refunds',
      (v) => (v as List<dynamic>)
          .map((e) => AdminRefundOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    canCancel: $checkedConvert('canCancel', (v) => v as bool),
    canReschedule: $checkedConvert('canReschedule', (v) => v as bool),
    timeStepMin: $checkedConvert('timeStepMin', (v) => (v as num).toInt()),
    visit: $checkedConvert(
      'visit',
      (v) => v == null ? null : VisitOut.fromJson(v as Map<String, dynamic>),
    ),
    paidPaise: $checkedConvert('paidPaise', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$AdminBookingDetailOutToJson(
  AdminBookingDetailOut instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'status': instance.status,
  'patientDeleted': instance.patientDeleted,
  'serviceName': instance.serviceName,
  'partnerType': instance.partnerType,
  'visitType': instance.visitType,
  'pickupAt': instance.pickupAt.toIso8601String(),
  'appointmentAt': instance.appointmentAt?.toIso8601String(),
  'memberName': instance.memberName,
  'patientPhone': instance.patientPhone,
  'hospitalName': instance.hospitalName,
  'bookingFeePaise': instance.bookingFeePaise,
  'createdAt': instance.createdAt.toIso8601String(),
  'temporaryPartner': ?instance.temporaryPartner,
  'service': instance.service.toJson(),
  'patient': instance.patient.toJson(),
  'member': instance.member.toJson(),
  'address': instance.address.toJson(),
  'hospitalId': instance.hospitalId,
  'hospitalText': instance.hospitalText,
  'doctorId': instance.doctorId,
  'doctorName': instance.doctorName,
  'notes': instance.notes,
  'notesVisible': instance.notesVisible,
  'rescheduleCount': instance.rescheduleCount,
  'documentsVisible': instance.documentsVisible,
  'documents': instance.documents.map((e) => e.toJson()).toList(),
  'timeline': instance.timeline.map((e) => e.toJson()).toList(),
  'reconfirmNeeded': instance.reconfirmNeeded,
  'payments': instance.payments.map((e) => e.toJson()).toList(),
  'refunds': instance.refunds.map((e) => e.toJson()).toList(),
  'canCancel': instance.canCancel,
  'canReschedule': instance.canReschedule,
  'timeStepMin': instance.timeStepMin,
  'visit': ?instance.visit?.toJson(),
  'paidPaise': instance.paidPaise,
};
