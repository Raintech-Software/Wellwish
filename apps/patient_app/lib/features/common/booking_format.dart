import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

/// Money, India time and status texts for the directory and booking screens.

/// Paise → "₹500", "₹1,500", "₹499.50" (Indian digit grouping). Money is never a double.
String inr(int paise) {
  final rupees = paise ~/ 100;
  final rest = paise % 100;
  final digits = rupees.toString();
  String grouped;
  if (digits.length <= 3) {
    grouped = digits;
  } else {
    final head = digits.substring(0, digits.length - 3);
    final tail = digits.substring(digits.length - 3);
    final parts = <String>[];
    for (var end = head.length; end > 0; end -= 2) {
      parts.insert(0, head.substring(end - 2 < 0 ? 0 : end - 2, end));
    }
    grouped = '${parts.join(',')},$tail';
  }
  return rest == 0 ? '₹$grouped' : '₹$grouped.${rest.toString().padLeft(2, '0')}';
}

/// India is UTC+5:30 all year. Booking times are hospital times, so they are always shown in
/// India time, even on a phone set to another time zone (a son booking from Dubai).
const istOffset = Duration(hours: 5, minutes: 30);

/// The India wall-clock time of [instant], as a UTC DateTime whose fields read as IST.
DateTime toIst(DateTime instant) => instant.toUtc().add(istOffset);

/// The instant for an India date and time (e.g. the 10:30 appointment on 10 Oct).
DateTime fromIst(DateTime day, int hour, int minute) =>
    DateTime.utc(day.year, day.month, day.day, hour, minute).subtract(istOffset);

/// Today's date in India.
DateTime istToday([DateTime? now]) {
  final ist = toIst(now ?? DateTime.now());
  return DateTime(ist.year, ist.month, ist.day);
}

String _locale(BuildContext context) => Localizations.localeOf(context).toString();

/// "9:30 AM".
String istTime(BuildContext context, DateTime instant) => DateFormat.jm(_locale(context)).format(toIst(instant));

/// "Fri, 10 Oct".
String istDay(BuildContext context, DateTime instant) =>
    DateFormat('EEE, d MMM', _locale(context)).format(toIst(instant));

/// "Fri, 10 Oct · 9:30 AM".
String istDateTime(BuildContext context, DateTime instant) =>
    '${istDay(context, instant)} · ${istTime(context, instant)}';

/// The service name in the app's language (English when no translation was entered).
String localName(BuildContext context, {required String en, String hi = '', String or = ''}) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'hi' && hi.isNotEmpty) return hi;
  if (code == 'or' && or.isNotEmpty) return or;
  return en;
}

String serviceName(BuildContext context, ServiceOut s) => localName(context, en: s.name, hi: s.nameHi, or: s.nameOr);

String serviceDescription(BuildContext context, ServiceOut s) =>
    localName(context, en: s.description, hi: s.descriptionHi, or: s.descriptionOr);

String bookedServiceName(BuildContext context, BookingServiceOut s) =>
    localName(context, en: s.name, hi: s.nameHi, or: s.nameOr);

String specialityName(BuildContext context, SpecialityOut s) =>
    localName(context, en: s.name, hi: s.nameHi, or: s.nameOr);

/// "About 45 min", "About 4 h".
String durationLabel(WWLocalizations l10n, int minutes) =>
    minutes < 60 || minutes % 60 != 0 ? l10n.durationMinutes(minutes) : l10n.durationHours(minutes ~/ 60);

String hospitalTypeLabel(WWLocalizations l10n, String type) => switch (type) {
  'CLINIC' => l10n.hospitalTypeClinic,
  'DIAGNOSTIC' => l10n.hospitalTypeDiagnostic,
  _ => l10n.hospitalTypeHospital,
};

/// What the patient sees for each booking status (§6.9 table).
String bookingStatusLabel(WWLocalizations l10n, String status) => switch (status) {
  'PENDING_PAYMENT' => l10n.statusPendingPayment,
  'NEW' || 'OFFERED' => l10n.statusAssigning,
  'ACCEPTED' => l10n.statusAssigned,
  'IN_PROGRESS' => l10n.statusInProgress,
  'COMPLETED' => l10n.statusCompleted,
  'PATIENT_NO_SHOW' => l10n.statusNoShow,
  'CANCELLED' => l10n.statusCancelled,
  'EXPIRED' => l10n.statusExpired,
  _ => status,
};

/// "Pickup time" / "Visit time" / "Start time" by visit type (§6.17).
String timeLabelFor(WWLocalizations l10n, String visitType) => switch (visitType) {
  'HOSPITAL_VISIT' => l10n.pickupTimeLabel,
  'HOME_VISIT' => l10n.visitTimeLabel,
  _ => l10n.startTimeLabel,
};
