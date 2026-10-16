import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

/// Money, India time and labels for the partner's offers and jobs.

/// Paise → "₹400", "₹1,500", "₹499.50" (Indian grouping). Money is never a double.
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

const _istOffset = Duration(hours: 5, minutes: 30);

DateTime _ist(DateTime instant) => instant.toUtc().add(_istOffset);

String _locale(BuildContext context) => Localizations.localeOf(context).toString();

/// "Fri, 10 Oct · 9:30 AM" in India time (jobs are at hospital times).
String istDateTime(BuildContext context, DateTime instant) =>
    '${DateFormat('EEE, d MMM', _locale(context)).format(_ist(instant))} · '
    '${DateFormat.jm(_locale(context)).format(_ist(instant))}';

String istTime(BuildContext context, DateTime instant) => DateFormat.jm(_locale(context)).format(_ist(instant));

/// The India date of [instant] (midnight UTC of that date, for comparing days).
DateTime istDay(DateTime instant) {
  final ist = _ist(instant);
  return DateTime.utc(ist.year, ist.month, ist.day);
}

/// The service name in the app's language (English when no translation was entered).
/// The member's language as stored (the words partners pick: "Odia") in the app's language.
String spokenLanguage(WWLocalizations l10n, String language) => switch (language) {
  'Odia' => l10n.spokenOdia,
  'Hindi' => l10n.spokenHindi,
  'English' => l10n.spokenEnglish,
  'Bengali' => l10n.spokenBengali,
  'Telugu' => l10n.spokenTelugu,
  _ => language,
};

String serviceName(BuildContext context, BookingServiceOut s) {
  final code = Localizations.localeOf(context).languageCode;
  if (code == 'hi' && s.nameHi.isNotEmpty) return s.nameHi;
  if (code == 'or' && s.nameOr.isNotEmpty) return s.nameOr;
  return s.name;
}

String mobilityLabel(WWLocalizations l10n, String mobility) => switch (mobility) {
  'WALKS_ALONE' => l10n.mobilityWalksAlone,
  'NEEDS_SUPPORT' => l10n.mobilityNeedsSupport,
  'WHEELCHAIR' => l10n.mobilityWheelchair,
  _ => '',
};

String genderLabel(WWLocalizations l10n, String gender) => switch (gender) {
  'MALE' => l10n.genderMale,
  'FEMALE' => l10n.genderFemale,
  'OTHER' => l10n.genderOther,
  _ => '',
};

/// "Female · 72 yrs".
String personLine(WWLocalizations l10n, String gender, int? age) =>
    [genderLabel(l10n, gender), if (age != null) l10n.ageYears(age)].where((s) => s.isNotEmpty).join(' · ');

String jobStatusLabel(WWLocalizations l10n, String status) => switch (status) {
  'ACCEPTED' => l10n.jobAccepted,
  'IN_PROGRESS' => l10n.statusInProgress,
  'COMPLETED' => l10n.statusCompleted,
  'PATIENT_NO_SHOW' => l10n.statusNoShow,
  'CANCELLED' => l10n.statusCancelled,
  _ => status,
};

/// "1:42".
String clock(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
