// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_detail_out.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$BookingDetailOutCWProxy {
  BookingDetailOut id(String id);

  BookingDetailOut code(String code);

  BookingDetailOut status(String status);

  BookingDetailOut service(BookingServiceOut service);

  BookingDetailOut memberName(String memberName);

  BookingDetailOut pickupAt(DateTime pickupAt);

  BookingDetailOut appointmentAt(DateTime? appointmentAt);

  BookingDetailOut hospitalName(String hospitalName);

  BookingDetailOut createdAt(DateTime createdAt);

  BookingDetailOut payBy(DateTime? payBy);

  BookingDetailOut member(BookingMemberOut member);

  BookingDetailOut address(BookingAddressOut address);

  BookingDetailOut hospitalId(String? hospitalId);

  BookingDetailOut doctorId(String? doctorId);

  BookingDetailOut doctorName(String doctorName);

  BookingDetailOut notes(String notes);

  BookingDetailOut documents(List<BookingDocumentOut> documents);

  BookingDetailOut timeline(List<BookingTimelineOut> timeline);

  BookingDetailOut paidPaise(int paidPaise);

  BookingDetailOut refunds(List<BookingRefundOut> refunds);

  BookingDetailOut canCancel(bool canCancel);

  BookingDetailOut canReschedule(bool canReschedule);

  BookingDetailOut rescheduleProblem(String? rescheduleProblem);

  BookingDetailOut reschedulesLeft(int reschedulesLeft);

  BookingDetailOut reconfirmNeeded(bool reconfirmNeeded);

  BookingDetailOut paymentPending(bool? paymentPending);

  BookingDetailOut partner(AssignedPartnerOut? partner);

  BookingDetailOut visit(VisitOut? visit);

  BookingDetailOut review(ReviewOut? review);

  BookingDetailOut canReview(bool? canReview);

  BookingDetailOut canReport(bool? canReport);

  BookingDetailOut tickets(List<TicketOut>? tickets);

  BookingDetailOut jobOtp(String? jobOtp);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDetailOut call({
    String id,
    String code,
    String status,
    BookingServiceOut service,
    String memberName,
    DateTime pickupAt,
    DateTime? appointmentAt,
    String hospitalName,
    DateTime createdAt,
    DateTime? payBy,
    BookingMemberOut member,
    BookingAddressOut address,
    String? hospitalId,
    String? doctorId,
    String doctorName,
    String notes,
    List<BookingDocumentOut> documents,
    List<BookingTimelineOut> timeline,
    int paidPaise,
    List<BookingRefundOut> refunds,
    bool canCancel,
    bool canReschedule,
    String? rescheduleProblem,
    int reschedulesLeft,
    bool reconfirmNeeded,
    bool? paymentPending,
    AssignedPartnerOut? partner,
    VisitOut? visit,
    ReviewOut? review,
    bool? canReview,
    bool? canReport,
    List<TicketOut>? tickets,
    String? jobOtp,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfBookingDetailOut.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfBookingDetailOut.copyWith.fieldName(...)`
class _$BookingDetailOutCWProxyImpl implements _$BookingDetailOutCWProxy {
  const _$BookingDetailOutCWProxyImpl(this._value);

  final BookingDetailOut _value;

  @override
  BookingDetailOut id(String id) => this(id: id);

  @override
  BookingDetailOut code(String code) => this(code: code);

  @override
  BookingDetailOut status(String status) => this(status: status);

  @override
  BookingDetailOut service(BookingServiceOut service) => this(service: service);

  @override
  BookingDetailOut memberName(String memberName) =>
      this(memberName: memberName);

  @override
  BookingDetailOut pickupAt(DateTime pickupAt) => this(pickupAt: pickupAt);

  @override
  BookingDetailOut appointmentAt(DateTime? appointmentAt) =>
      this(appointmentAt: appointmentAt);

  @override
  BookingDetailOut hospitalName(String hospitalName) =>
      this(hospitalName: hospitalName);

  @override
  BookingDetailOut createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  BookingDetailOut payBy(DateTime? payBy) => this(payBy: payBy);

  @override
  BookingDetailOut member(BookingMemberOut member) => this(member: member);

  @override
  BookingDetailOut address(BookingAddressOut address) => this(address: address);

  @override
  BookingDetailOut hospitalId(String? hospitalId) =>
      this(hospitalId: hospitalId);

  @override
  BookingDetailOut doctorId(String? doctorId) => this(doctorId: doctorId);

  @override
  BookingDetailOut doctorName(String doctorName) =>
      this(doctorName: doctorName);

  @override
  BookingDetailOut notes(String notes) => this(notes: notes);

  @override
  BookingDetailOut documents(List<BookingDocumentOut> documents) =>
      this(documents: documents);

  @override
  BookingDetailOut timeline(List<BookingTimelineOut> timeline) =>
      this(timeline: timeline);

  @override
  BookingDetailOut paidPaise(int paidPaise) => this(paidPaise: paidPaise);

  @override
  BookingDetailOut refunds(List<BookingRefundOut> refunds) =>
      this(refunds: refunds);

  @override
  BookingDetailOut canCancel(bool canCancel) => this(canCancel: canCancel);

  @override
  BookingDetailOut canReschedule(bool canReschedule) =>
      this(canReschedule: canReschedule);

  @override
  BookingDetailOut rescheduleProblem(String? rescheduleProblem) =>
      this(rescheduleProblem: rescheduleProblem);

  @override
  BookingDetailOut reschedulesLeft(int reschedulesLeft) =>
      this(reschedulesLeft: reschedulesLeft);

  @override
  BookingDetailOut reconfirmNeeded(bool reconfirmNeeded) =>
      this(reconfirmNeeded: reconfirmNeeded);

  @override
  BookingDetailOut paymentPending(bool? paymentPending) =>
      this(paymentPending: paymentPending);

  @override
  BookingDetailOut partner(AssignedPartnerOut? partner) =>
      this(partner: partner);

  @override
  BookingDetailOut visit(VisitOut? visit) => this(visit: visit);

  @override
  BookingDetailOut review(ReviewOut? review) => this(review: review);

  @override
  BookingDetailOut canReview(bool? canReview) => this(canReview: canReview);

  @override
  BookingDetailOut canReport(bool? canReport) => this(canReport: canReport);

  @override
  BookingDetailOut tickets(List<TicketOut>? tickets) => this(tickets: tickets);

  @override
  BookingDetailOut jobOtp(String? jobOtp) => this(jobOtp: jobOtp);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `BookingDetailOut(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// BookingDetailOut(...).copyWith(id: 12, name: "My name")
  /// ````
  BookingDetailOut call({
    Object? id = const $CopyWithPlaceholder(),
    Object? code = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? service = const $CopyWithPlaceholder(),
    Object? memberName = const $CopyWithPlaceholder(),
    Object? pickupAt = const $CopyWithPlaceholder(),
    Object? appointmentAt = const $CopyWithPlaceholder(),
    Object? hospitalName = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? payBy = const $CopyWithPlaceholder(),
    Object? member = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? hospitalId = const $CopyWithPlaceholder(),
    Object? doctorId = const $CopyWithPlaceholder(),
    Object? doctorName = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? documents = const $CopyWithPlaceholder(),
    Object? timeline = const $CopyWithPlaceholder(),
    Object? paidPaise = const $CopyWithPlaceholder(),
    Object? refunds = const $CopyWithPlaceholder(),
    Object? canCancel = const $CopyWithPlaceholder(),
    Object? canReschedule = const $CopyWithPlaceholder(),
    Object? rescheduleProblem = const $CopyWithPlaceholder(),
    Object? reschedulesLeft = const $CopyWithPlaceholder(),
    Object? reconfirmNeeded = const $CopyWithPlaceholder(),
    Object? paymentPending = const $CopyWithPlaceholder(),
    Object? partner = const $CopyWithPlaceholder(),
    Object? visit = const $CopyWithPlaceholder(),
    Object? review = const $CopyWithPlaceholder(),
    Object? canReview = const $CopyWithPlaceholder(),
    Object? canReport = const $CopyWithPlaceholder(),
    Object? tickets = const $CopyWithPlaceholder(),
    Object? jobOtp = const $CopyWithPlaceholder(),
  }) {
    return BookingDetailOut(
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
      memberName: memberName == const $CopyWithPlaceholder()
          ? _value.memberName
          // ignore: cast_nullable_to_non_nullable
          : memberName as String,
      pickupAt: pickupAt == const $CopyWithPlaceholder()
          ? _value.pickupAt
          // ignore: cast_nullable_to_non_nullable
          : pickupAt as DateTime,
      appointmentAt: appointmentAt == const $CopyWithPlaceholder()
          ? _value.appointmentAt
          // ignore: cast_nullable_to_non_nullable
          : appointmentAt as DateTime?,
      hospitalName: hospitalName == const $CopyWithPlaceholder()
          ? _value.hospitalName
          // ignore: cast_nullable_to_non_nullable
          : hospitalName as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      payBy: payBy == const $CopyWithPlaceholder()
          ? _value.payBy
          // ignore: cast_nullable_to_non_nullable
          : payBy as DateTime?,
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
      documents: documents == const $CopyWithPlaceholder()
          ? _value.documents
          // ignore: cast_nullable_to_non_nullable
          : documents as List<BookingDocumentOut>,
      timeline: timeline == const $CopyWithPlaceholder()
          ? _value.timeline
          // ignore: cast_nullable_to_non_nullable
          : timeline as List<BookingTimelineOut>,
      paidPaise: paidPaise == const $CopyWithPlaceholder()
          ? _value.paidPaise
          // ignore: cast_nullable_to_non_nullable
          : paidPaise as int,
      refunds: refunds == const $CopyWithPlaceholder()
          ? _value.refunds
          // ignore: cast_nullable_to_non_nullable
          : refunds as List<BookingRefundOut>,
      canCancel: canCancel == const $CopyWithPlaceholder()
          ? _value.canCancel
          // ignore: cast_nullable_to_non_nullable
          : canCancel as bool,
      canReschedule: canReschedule == const $CopyWithPlaceholder()
          ? _value.canReschedule
          // ignore: cast_nullable_to_non_nullable
          : canReschedule as bool,
      rescheduleProblem: rescheduleProblem == const $CopyWithPlaceholder()
          ? _value.rescheduleProblem
          // ignore: cast_nullable_to_non_nullable
          : rescheduleProblem as String?,
      reschedulesLeft: reschedulesLeft == const $CopyWithPlaceholder()
          ? _value.reschedulesLeft
          // ignore: cast_nullable_to_non_nullable
          : reschedulesLeft as int,
      reconfirmNeeded: reconfirmNeeded == const $CopyWithPlaceholder()
          ? _value.reconfirmNeeded
          // ignore: cast_nullable_to_non_nullable
          : reconfirmNeeded as bool,
      paymentPending: paymentPending == const $CopyWithPlaceholder()
          ? _value.paymentPending
          // ignore: cast_nullable_to_non_nullable
          : paymentPending as bool?,
      partner: partner == const $CopyWithPlaceholder()
          ? _value.partner
          // ignore: cast_nullable_to_non_nullable
          : partner as AssignedPartnerOut?,
      visit: visit == const $CopyWithPlaceholder()
          ? _value.visit
          // ignore: cast_nullable_to_non_nullable
          : visit as VisitOut?,
      review: review == const $CopyWithPlaceholder()
          ? _value.review
          // ignore: cast_nullable_to_non_nullable
          : review as ReviewOut?,
      canReview: canReview == const $CopyWithPlaceholder()
          ? _value.canReview
          // ignore: cast_nullable_to_non_nullable
          : canReview as bool?,
      canReport: canReport == const $CopyWithPlaceholder()
          ? _value.canReport
          // ignore: cast_nullable_to_non_nullable
          : canReport as bool?,
      tickets: tickets == const $CopyWithPlaceholder()
          ? _value.tickets
          // ignore: cast_nullable_to_non_nullable
          : tickets as List<TicketOut>?,
      jobOtp: jobOtp == const $CopyWithPlaceholder()
          ? _value.jobOtp
          // ignore: cast_nullable_to_non_nullable
          : jobOtp as String?,
    );
  }
}

extension $BookingDetailOutCopyWith on BookingDetailOut {
  /// Returns a callable class that can be used as follows: `instanceOfBookingDetailOut.copyWith(...)` or like so:`instanceOfBookingDetailOut.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$BookingDetailOutCWProxy get copyWith => _$BookingDetailOutCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDetailOut _$BookingDetailOutFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('BookingDetailOut', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'code',
      'status',
      'service',
      'memberName',
      'pickupAt',
      'appointmentAt',
      'hospitalName',
      'createdAt',
      'member',
      'address',
      'hospitalId',
      'doctorId',
      'doctorName',
      'notes',
      'documents',
      'timeline',
      'paidPaise',
      'refunds',
      'canCancel',
      'canReschedule',
      'reschedulesLeft',
      'reconfirmNeeded',
    ],
  );
  final val = BookingDetailOut(
    id: $checkedConvert('id', (v) => v as String),
    code: $checkedConvert('code', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    service: $checkedConvert(
      'service',
      (v) => BookingServiceOut.fromJson(v as Map<String, dynamic>),
    ),
    memberName: $checkedConvert('memberName', (v) => v as String),
    pickupAt: $checkedConvert('pickupAt', (v) => DateTime.parse(v as String)),
    appointmentAt: $checkedConvert(
      'appointmentAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    hospitalName: $checkedConvert('hospitalName', (v) => v as String),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    payBy: $checkedConvert(
      'payBy',
      (v) => v == null ? null : DateTime.parse(v as String),
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
    doctorId: $checkedConvert('doctorId', (v) => v as String?),
    doctorName: $checkedConvert('doctorName', (v) => v as String),
    notes: $checkedConvert('notes', (v) => v as String),
    documents: $checkedConvert(
      'documents',
      (v) => (v as List<dynamic>)
          .map((e) => BookingDocumentOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    timeline: $checkedConvert(
      'timeline',
      (v) => (v as List<dynamic>)
          .map((e) => BookingTimelineOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    paidPaise: $checkedConvert('paidPaise', (v) => (v as num).toInt()),
    refunds: $checkedConvert(
      'refunds',
      (v) => (v as List<dynamic>)
          .map((e) => BookingRefundOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    canCancel: $checkedConvert('canCancel', (v) => v as bool),
    canReschedule: $checkedConvert('canReschedule', (v) => v as bool),
    rescheduleProblem: $checkedConvert(
      'rescheduleProblem',
      (v) => v as String?,
    ),
    reschedulesLeft: $checkedConvert(
      'reschedulesLeft',
      (v) => (v as num).toInt(),
    ),
    reconfirmNeeded: $checkedConvert('reconfirmNeeded', (v) => v as bool),
    paymentPending: $checkedConvert(
      'paymentPending',
      (v) => v as bool? ?? false,
    ),
    partner: $checkedConvert(
      'partner',
      (v) => v == null
          ? null
          : AssignedPartnerOut.fromJson(v as Map<String, dynamic>),
    ),
    visit: $checkedConvert(
      'visit',
      (v) => v == null ? null : VisitOut.fromJson(v as Map<String, dynamic>),
    ),
    review: $checkedConvert(
      'review',
      (v) => v == null ? null : ReviewOut.fromJson(v as Map<String, dynamic>),
    ),
    canReview: $checkedConvert('canReview', (v) => v as bool? ?? false),
    canReport: $checkedConvert('canReport', (v) => v as bool? ?? false),
    tickets: $checkedConvert(
      'tickets',
      (v) => (v as List<dynamic>?)
          ?.map((e) => TicketOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    jobOtp: $checkedConvert('jobOtp', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$BookingDetailOutToJson(BookingDetailOut instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'service': instance.service.toJson(),
      'memberName': instance.memberName,
      'pickupAt': instance.pickupAt.toIso8601String(),
      'appointmentAt': instance.appointmentAt?.toIso8601String(),
      'hospitalName': instance.hospitalName,
      'createdAt': instance.createdAt.toIso8601String(),
      'payBy': ?instance.payBy?.toIso8601String(),
      'member': instance.member.toJson(),
      'address': instance.address.toJson(),
      'hospitalId': instance.hospitalId,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'notes': instance.notes,
      'documents': instance.documents.map((e) => e.toJson()).toList(),
      'timeline': instance.timeline.map((e) => e.toJson()).toList(),
      'paidPaise': instance.paidPaise,
      'refunds': instance.refunds.map((e) => e.toJson()).toList(),
      'canCancel': instance.canCancel,
      'canReschedule': instance.canReschedule,
      'rescheduleProblem': ?instance.rescheduleProblem,
      'reschedulesLeft': instance.reschedulesLeft,
      'reconfirmNeeded': instance.reconfirmNeeded,
      'paymentPending': ?instance.paymentPending,
      'partner': ?instance.partner?.toJson(),
      'visit': ?instance.visit?.toJson(),
      'review': ?instance.review?.toJson(),
      'canReview': ?instance.canReview,
      'canReport': ?instance.canReport,
      'tickets': ?instance.tickets?.map((e) => e.toJson()).toList(),
      'jobOtp': ?instance.jobOtp,
    };
