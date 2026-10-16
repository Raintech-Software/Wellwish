import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';

/// Shared texts and small helpers for the family, address and document screens.

/// The error a screen shows for a failed call (server codes from ARCHITECTURE §10.3).
String patientErrorMessage(WWLocalizations l10n, Object error) {
  final e = toApiException(error);
  if (e.isConnectivity) return l10n.noInternet;
  return switch (e.code) {
    'TOO_MANY_MEMBERS' => l10n.errTooManyMembers,
    'TOO_MANY_ADDRESSES' => l10n.errTooManyAddresses,
    'STORAGE_FULL' => l10n.errStorageFull,
    'INVALID_FILE' || 'FILE_NOT_FOUND' || 'ALREADY_ADDED' => l10n.errInvalidFile,
    'FILE_TOO_LARGE' => l10n.errFileTooLarge,
    'UPLOAD_EXPIRED' => l10n.errUploadAgain, // the signed upload ran out (§6.8)
    'INVALID_DATE' => l10n.errDateInFuture,
    'INVALID_PHONE' => l10n.invalidPhone,
    'EMERGENCY_INCOMPLETE' => l10n.emergencyIncomplete,
    'CONSENT_REQUIRED' => l10n.consentRequired,
    'INVALID_NAME' => l10n.nameRequired,
    'INVALID_DOB' => l10n.dobRequired,
    'NOT_FOUND' => l10n.errNotFound,
    'TIME_NOT_AVAILABLE' => l10n.errTimeNotAvailable,
    'PRESCRIPTION_REQUIRED' => l10n.errPrescriptionRequired,
    'OUTSIDE_SERVICE_AREA' => l10n.errOutsideServiceArea,
    'TOO_MANY_UNPAID' => l10n.errTooManyUnpaid,
    'TOO_MANY_REQUESTS' => l10n.errTooManyRequests,
    'INVALID_BOOKING' => l10n.errInvalidBooking,
    'MEMBER_HAS_BOOKINGS' => l10n.errMemberHasBookings,
    'ACTIVE_BOOKINGS' => l10n.errActiveBookings,
    'BOOKING_NOT_PAYABLE' => l10n.errNotPayable,
    'PAYMENTS_NOT_SET_UP' => l10n.errPaymentsNotSetUp,
    'INVALID_SIGNATURE' => l10n.errInvalidSignature,
    'PAYMENT_GATEWAY_ERROR' => l10n.errGateway,
    'CANCEL_NOT_ALLOWED' => l10n.cancelNotAllowed,
    'ALREADY_REVIEWED' => l10n.errAlreadyReviewed,
    'NOT_REVIEWABLE' => l10n.errNotReviewable,
    'REPORT_TOO_LATE' => l10n.errReportTooLate,
    'NOT_IN_PROGRESS' => l10n.errNotInProgress,
    'RESCHEDULE_NOT_ALLOWED' => switch (e.details['reason']) {
      'TOO_LATE' => l10n.rescheduleTooLate,
      'LIMIT' => l10n.rescheduleLimit,
      _ => l10n.rescheduleNotAllowed,
    },
    _ => authErrorMessage(l10n, e),
  };
}

String relationLabel(WWLocalizations l10n, String relation) => switch (relation) {
  'SELF' => l10n.relationSelf,
  'MOTHER' => l10n.relationMother,
  'FATHER' => l10n.relationFather,
  'GRANDMOTHER' => l10n.relationGrandmother,
  'GRANDFATHER' => l10n.relationGrandfather,
  'SPOUSE' => l10n.relationSpouse,
  'CHILD' => l10n.relationChild,
  'SIBLING' => l10n.relationSibling,
  _ => l10n.relationOther,
};

String mobilityLabel(WWLocalizations l10n, String mobility) => switch (mobility) {
  'WALKS_ALONE' => l10n.mobilityWalksAlone,
  'NEEDS_SUPPORT' => l10n.mobilityNeedsSupport,
  'WHEELCHAIR' => l10n.mobilityWheelchair,
  _ => l10n.notGiven,
};

/// Member languages are the words partners use ("Odia"), shown in the app's language.
String memberLanguageLabel(WWLocalizations l10n, String language) => switch (language) {
  'Odia' => l10n.spokenOdia,
  'Hindi' => l10n.spokenHindi,
  'English' => l10n.spokenEnglish,
  'Bengali' => l10n.spokenBengali,
  'Telugu' => l10n.spokenTelugu,
  _ => l10n.notGiven,
};

/// A language word from the directory ("Odia") in the app's language; others as typed.
String spokenLanguage(WWLocalizations l10n, String language) => switch (language) {
  'Odia' || 'Hindi' || 'English' || 'Bengali' || 'Telugu' => memberLanguageLabel(l10n, language),
  _ => language,
};

String documentTypeLabel(WWLocalizations l10n, String type) => switch (type) {
  'PRESCRIPTION' => l10n.docTypePrescription,
  'LAB_REPORT' => l10n.docTypeLabReport,
  'SCAN' => l10n.docTypeScan,
  'DISCHARGE' => l10n.docTypeDischarge,
  'ID' => l10n.docTypeId,
  'CARE_NOTE' => l10n.docTypeCareNote,
  _ => l10n.docTypeOther,
};

String formatDate(BuildContext context, DateTime date) =>
    DateFormat('d MMM y', Localizations.localeOf(context).toString()).format(date);

/// "12 MB", "640 KB".
String formatBytes(int bytes) {
  if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(bytes < 10 * 1024 * 1024 ? 1 : 0)} MB';
  return '${(bytes / 1024).ceil()} KB';
}

/// "Sabitri Gouda · Mother · 72 yrs".
String memberSubtitle(WWLocalizations l10n, MemberOut member) =>
    [relationLabel(l10n, member.relation), if (member.age != null) l10n.ageYears(member.age!)].join(' · ');

/// Confirm dialog with a red action. Returns true when confirmed.
Future<bool> confirmDanger(
  BuildContext context, {
  required String title,
  required String body,
  required String action,
}) async {
  final l10n = WWLocalizations.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(action, style: const TextStyle(color: WWColors.danger)),
        ),
      ],
    ),
  );
  return ok ?? false;
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Opens a legal page (§6.20) in the browser, in the app's language. Offline: a message.
/// What it needs is read before waiting: the screen may be gone when the app-config arrives.
Future<void> openLegalPage(BuildContext context, WidgetRef ref, PublicPage page) async {
  final l10n = WWLocalizations.of(context);
  final language = Localizations.localeOf(context).languageCode;
  final container = ProviderScope.containerOf(context, listen: false);
  final open = container.read(openPublicPageProvider);
  final messenger = ScaffoldMessenger.maybeOf(context);
  void say(String message) => messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  try {
    final urls = await container.read(legalUrlsProvider.future);
    if (!await open(urls.linkOf(page), language)) say(l10n.somethingWentWrong); // no browser
  } catch (e) {
    container.invalidate(legalUrlsProvider); // try the app-config again next time
    say(patientErrorMessage(l10n, e));
  }
}
