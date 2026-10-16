import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../family/family_controller.dart';
import '../session/session_controller.dart';

/// The booking flow (W-P2, W-P3): services (P10/P11) → visit details (P12) → address (P13) →
/// documents (P14) → review (P15). What the patient picks is kept in a draft until "Book".

/// A hospital or doctor picked in the directory.
class BookingPlace {
  const BookingPlace({required this.id, required this.name, this.lat, this.lng, this.hospitalIds = const []});

  final String id;
  final String name;
  final String? lat;
  final String? lng;

  /// A doctor: the hospitals they are listed at (another hospital drops the doctor).
  final List<String> hospitalIds;
}

BookingPlace placeOfDoctor(PatientDoctorOut d) =>
    BookingPlace(id: d.id, name: d.fullName, hospitalIds: [for (final h in d.hospitals) h.id]);

/// The page on top (a pushed page's own location; `uri` stays the base location).
String _topLocation(GoRouter router) => router.routerDelegate.currentConfiguration.last.matchedLocation;

/// Opens a step unless it is already on top (a double tap on Next opens it once).
void pushStep(BuildContext context, String path) {
  final router = GoRouter.of(context);
  if (_topLocation(router) != path) router.push(path);
}

/// Back to an earlier step of the flow (after the server refused something on Review). The pops
/// are counted from the stack first: the router's own record changes only after each animation.
void popToStep(GoRouter router, String path) {
  final locations = [for (final m in router.routerDelegate.currentConfiguration.matches) m.matchedLocation];
  final index = locations.lastIndexOf(path);
  if (index < 0) return;
  for (var i = locations.length - 1; i > index; i--) {
    if (router.canPop()) router.pop();
  }
}

const _keep = Object();

class BookingDraft {
  const BookingDraft({
    this.partnerType = 'COMPANION',
    this.service,
    this.memberId,
    this.hospital,
    this.notListed = false,
    this.hospitalText = '',
    this.doctor,
    this.fromDirectory = false,
    this.date,
    this.pickupAt,
    this.appointmentAt,
    this.address,
    this.documentIds = const {},
    this.notes = '',
    this.key,
  });

  final String partnerType;
  final ServiceOut? service;
  final String? memberId;
  final BookingPlace? hospital;

  /// "My hospital isn't listed": [hospitalText] is sent instead of a hospital id.
  final bool notListed;
  final String hospitalText;
  final BookingPlace? doctor;

  /// Started from a hospital or doctor page: only hospital-visit services are offered.
  final bool fromDirectory;

  /// The India date picked in the date strip (year, month, day only).
  final DateTime? date;

  /// Instants (UTC). Shown in India time.
  final DateTime? pickupAt;
  final DateTime? appointmentAt;
  final AddressOut? address;
  final Set<String> documentIds;
  final String notes;

  /// The Idempotency-Key of this Review screen: a double tap or a retry sends the same key, so
  /// the server returns the same booking (§6.9). Any change to the draft makes a new one.
  final String? key;

  String get visitType => service?.visitType ?? '';
  bool get hasPlace => visitType == 'HOSPITAL_VISIT' || visitType == 'ERRAND';
  bool get needsHospital => visitType == 'HOSPITAL_VISIT';

  BookingDraft copyWith({
    Object? service = _keep,
    Object? memberId = _keep,
    Object? hospital = _keep,
    bool? notListed,
    String? hospitalText,
    Object? doctor = _keep,
    Object? date = _keep,
    Object? pickupAt = _keep,
    Object? appointmentAt = _keep,
    Object? address = _keep,
    Set<String>? documentIds,
    String? notes,
    Object? key,
  }) => BookingDraft(
    partnerType: partnerType,
    service: identical(service, _keep) ? this.service : service as ServiceOut?,
    memberId: identical(memberId, _keep) ? this.memberId : memberId as String?,
    hospital: identical(hospital, _keep) ? this.hospital : hospital as BookingPlace?,
    notListed: notListed ?? this.notListed,
    hospitalText: hospitalText ?? this.hospitalText,
    doctor: identical(doctor, _keep) ? this.doctor : doctor as BookingPlace?,
    fromDirectory: fromDirectory,
    date: identical(date, _keep) ? this.date : date as DateTime?,
    pickupAt: identical(pickupAt, _keep) ? this.pickupAt : pickupAt as DateTime?,
    appointmentAt: identical(appointmentAt, _keep) ? this.appointmentAt : appointmentAt as DateTime?,
    address: identical(address, _keep) ? this.address : address as AddressOut?,
    documentIds: documentIds ?? this.documentIds,
    notes: notes ?? this.notes,
    key: key as String?, // every change drops the key unless it is passed on
  );
}

class BookingDraftController extends Notifier<BookingDraft> {
  @override
  BookingDraft build() {
    ref.watch(sessionProvider.select((s) => s.me?.id)); // another account: a fresh draft
    return const BookingDraft();
  }

  void start({required String partnerType, BookingPlace? hospital, BookingPlace? doctor, String? memberId}) {
    state = BookingDraft(
      partnerType: partnerType,
      hospital: hospital,
      doctor: doctor,
      memberId: memberId,
      fromDirectory: hospital != null || doctor != null,
    );
  }

  void chooseService(ServiceOut service) {
    final visit = service.visitType;
    state = state.copyWith(
      service: service,
      hospital: visit == 'HOME_VISIT' ? null : state.hospital,
      notListed: visit == 'HOME_VISIT' ? false : state.notListed,
      hospitalText: visit == 'HOME_VISIT' ? '' : state.hospitalText,
      doctor: visit == 'HOSPITAL_VISIT' ? state.doctor : null,
      date: null,
      pickupAt: null,
      appointmentAt: null,
    );
  }

  /// Another member: their own addresses and documents are offered (§6.18).
  void setMember(String id) {
    if (id == state.memberId) return;
    state = state.copyWith(memberId: id, address: null, documentIds: const {});
  }

  /// The doctor stays only if they are listed at the new hospital too.
  void setHospital(BookingPlace place) {
    final doctor = state.doctor;
    final keep = doctor != null && doctor.hospitalIds.contains(place.id);
    state = state.copyWith(hospital: place, doctor: keep ? doctor : null, notListed: false, hospitalText: '');
  }

  void setNotListed(bool notListed) =>
      state = state.copyWith(notListed: notListed, hospital: notListed ? null : state.hospital, doctor: null);

  void setHospitalText(String text) {
    if (text != state.hospitalText) state = state.copyWith(hospitalText: text);
  }

  void setDoctor(BookingPlace? doctor) => state = state.copyWith(doctor: doctor);

  void setDate(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    if (date == state.date) return;
    state = state.copyWith(date: date, pickupAt: null, appointmentAt: null);
  }

  void setPickup(DateTime? at) => state = state.copyWith(pickupAt: at);

  void setAppointment(DateTime? at) => state = state.copyWith(appointmentAt: at);

  void setAddress(AddressOut? address) => state = state.copyWith(address: address);

  void toggleDocument(String id) {
    final ids = {...state.documentIds};
    if (!ids.remove(id)) ids.add(id);
    state = state.copyWith(documentIds: ids);
  }

  void setNotes(String notes) {
    if (notes != state.notes) state = state.copyWith(notes: notes);
  }

  /// The Review screen's key: kept while nothing changes.
  String ensureKey() {
    final existing = state.key;
    if (existing != null) return existing;
    final random = Random.secure();
    final key = List.generate(32, (_) => random.nextInt(16).toRadixString(16)).join();
    state = state.copyWith(key: key);
    return key;
  }

  void reset() => state = const BookingDraft();
}

final bookingDraftProvider = NotifierProvider<BookingDraftController, BookingDraft>(BookingDraftController.new);

/// Opens Book a Companion / Book a Nurse with what is already known (a hospital, a doctor, the
/// family member whose profile it was started from).
void startBooking(
  BuildContext context, {
  required String partnerType,
  BookingPlace? hospital,
  BookingPlace? doctor,
  String? memberId,
}) {
  ProviderScope.containerOf(context, listen: false)
      .read(bookingDraftProvider.notifier)
      .start(partnerType: partnerType, hospital: hospital, doctor: doctor, memberId: memberId);
  context.push('/book/$partnerType');
}

/// Active services of one type, in the admin's order (P10, P11).
final servicesProvider = FutureProvider.autoDispose.family<List<ServiceOut>, String>(
  (ref, type) async => (await ref.watch(publicApiProvider).publicServices(partnerType: type)).data!,
);

/// The date strip and time grid for a service (§6.17). Date null: the server picks the first
/// date with a free time.
final bookingTimesProvider = FutureProvider.autoDispose.family<BookingTimesOut, (String, DateTime?)>(
  (ref, key) async => (await ref.watch(patientApiProvider).patientBookingTimes(serviceId: key.$1, date: key.$2)).data!,
);

/// Refund % for the cancellation rule on Review.
final publicConfigProvider = FutureProvider.autoDispose<AppConfigOut>(
  (ref) async => (await ref.watch(publicApiProvider).publicAppConfig()).data!,
);

/// A family member's documents to tick (P14).
final memberDocumentsProvider = FutureProvider.autoDispose.family<List<PatientDocumentOut>, String>(
  (ref, memberId) async =>
      (await ref.watch(patientApiProvider).patientDocumentList(memberId: memberId, pageSize: 100)).data!.items,
);

/// Every saved address of the account (P13's "other saved addresses").
final allAddressesProvider = FutureProvider.autoDispose<List<AddressOut>>(
  (ref) async => (await ref.watch(patientApiProvider).patientAddressList()).data!,
);

/// The Home card: a job in progress first, else the soonest upcoming booking.
final nextBookingProvider = FutureProvider.autoDispose<BookingRowOut?>((ref) async {
  ref.watch(sessionProvider.select((s) => s.me?.id));
  final api = ref.watch(patientApiProvider);
  final ongoing = (await api.patientBookingList(bucket: 'ongoing', pageSize: 1)).data!;
  if (ongoing.items.isNotEmpty) return ongoing.items.first;
  final upcoming = (await api.patientBookingList(bucket: 'upcoming', pageSize: 1)).data!;
  return upcoming.items.firstOrNull;
});

final bookingDetailProvider = FutureProvider.autoDispose.family<BookingDetailOut, String>(
  (ref, id) async => (await ref.watch(patientApiProvider).patientBookingGet(bookingId: id)).data!,
);

/// P30: the dates and times a booking can move to (its own place is free for it).
final rescheduleTimesProvider = FutureProvider.autoDispose.family<BookingTimesOut, (String, DateTime?)>(
  (ref, key) async =>
      (await ref.watch(patientApiProvider).patientBookingRescheduleTimes(bookingId: key.$1, date: key.$2)).data!,
);

/// My bookings (P17): one page of a tab ('upcoming', 'ongoing', 'past').
final myBookingsProvider = FutureProvider.autoDispose.family<PagedBookingRowOut, (String, int)>(
  (ref, key) async =>
      (await ref.watch(patientApiProvider).patientBookingList(bucket: key.$1, page: key.$2, pageSize: 20)).data!,
);

/// After a booking: the Home card and the member's bookings change.
void bookingsChanged(ProviderContainer container, {String? memberId}) {
  container.invalidate(nextBookingProvider);
  container.invalidate(myBookingsProvider);
  if (memberId != null) container.invalidate(memberDetailProvider(memberId));
}
