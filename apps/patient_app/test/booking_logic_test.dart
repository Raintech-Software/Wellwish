import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patient_app/features/booking/booking_flow.dart';
import 'package:patient_app/features/common/booking_format.dart';
import 'package:ww_core/ww_core.dart';

/// India time, money and the booking draft, independent of the computer's time zone.
void main() {
  group('India time', () {
    test('a UTC instant reads as India time', () {
      final ist = toIst(DateTime.utc(2026, 10, 9, 20, 0)); // 8 PM UTC = 1:30 AM next day in India
      expect((ist.year, ist.month, ist.day, ist.hour, ist.minute), (2026, 10, 10, 1, 30));
    });

    test('an India date and time is the right instant', () {
      expect(fromIst(DateTime(2026, 10, 10), 9, 30), DateTime.utc(2026, 10, 10, 4, 0));
      expect(fromIst(DateTime(2026, 10, 10), 3, 0), DateTime.utc(2026, 10, 9, 21, 30));
    });

    test("India's today, also late at night in UTC", () {
      expect(istToday(DateTime.utc(2026, 10, 9, 19, 0)), DateTime(2026, 10, 10)); // 00:30 IST
      expect(istToday(DateTime.utc(2026, 10, 9, 18, 0)), DateTime(2026, 10, 9)); // 23:30 IST
    });
  });

  test('money in paise, Indian grouping', () {
    expect(inr(10000), '₹100');
    expect(inr(150000), '₹1,500');
    expect(inr(12345600), '₹1,23,456');
    expect(inr(49950), '₹499.50');
    expect(inr(5), '₹0.05');
  });

  group('booking draft', () {
    ServiceOut service(String visit) => ServiceOut(
      id: 's-$visit',
      name: 'S',
      nameHi: '',
      nameOr: '',
      description: '',
      descriptionHi: '',
      descriptionOr: '',
      partnerType: 'COMPANION',
      visitType: visit,
      pricePaise: 50000,
      bookingFeePaise: 10000,
      balancePaise: 40000,
      durationMin: 240,
      docsRequired: false,
      isActive: true,
      sort: 0,
    );

    test('the key stays for a retry and changes with the booking', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final draft = container.read(bookingDraftProvider.notifier)
        ..start(partnerType: 'COMPANION')
        ..chooseService(service('HOSPITAL_VISIT'));
      final key = draft.ensureKey();
      expect(key, matches(RegExp(r'^[0-9a-f]{32}$')));
      expect(draft.ensureKey(), key); // Pay again after an error: same key
      draft.setNotes('Wheelchair');
      expect(draft.ensureKey(), isNot(key)); // another booking: a new key
    });

    test('a new hospital keeps the doctor only if they work there', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      const doctor = BookingPlace(id: 'dr-1', name: 'Dr. A', hospitalIds: ['h-1', 'h-2']);
      final draft = container.read(bookingDraftProvider.notifier)
        ..start(
          partnerType: 'COMPANION',
          hospital: const BookingPlace(id: 'h-1', name: 'One'),
          doctor: doctor,
        )
        ..chooseService(service('HOSPITAL_VISIT'))
        ..setHospital(const BookingPlace(id: 'h-2', name: 'Two'));
      expect(container.read(bookingDraftProvider).doctor?.id, 'dr-1');
      draft.setHospital(const BookingPlace(id: 'h-3', name: 'Three'));
      expect(container.read(bookingDraftProvider).doctor, isNull);
    });

    test('changes clear what depends on them', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final draft = container.read(bookingDraftProvider.notifier)
        ..start(partnerType: 'COMPANION', memberId: 'm-1')
        ..chooseService(service('HOSPITAL_VISIT'))
        ..setDate(DateTime(2026, 10, 10))
        ..setPickup(DateTime.utc(2026, 10, 10, 4))
        ..toggleDocument('d-1');
      draft.setDate(DateTime(2026, 10, 11));
      expect(container.read(bookingDraftProvider).pickupAt, isNull); // another day: pick again
      draft.setMember('m-2');
      expect(container.read(bookingDraftProvider).documentIds, isEmpty); // Mother's documents only
      draft
        ..setHospital(const BookingPlace(id: 'h-1', name: 'One'))
        ..chooseService(service('HOME_VISIT'));
      expect(container.read(bookingDraftProvider).hospital, isNull); // a home visit has none
    });
  });
}
