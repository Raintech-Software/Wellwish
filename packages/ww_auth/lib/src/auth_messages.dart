import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

/// Turns a login error into a translated message (the server's English text is not shown,
/// so Hindi and Odia users read their own language).
String authErrorMessage(WWLocalizations l10n, ApiException error) {
  if (error.isConnectivity) return l10n.noInternet;
  switch (error.code) {
    case 'INVALID_PHONE':
      return l10n.invalidPhone;
    case 'OTP_INVALID':
      final left = error.details['attemptsLeft'];
      return l10n.otpWrong(left is int ? left : 0);
    case 'OTP_EXPIRED':
      return l10n.otpExpired;
    case 'OTP_TOO_MANY_ATTEMPTS':
      return l10n.otpTooManyAttempts;
    case 'OTP_LOCKED':
      return l10n.otpLocked;
    case 'OTP_RATE_LIMITED':
      return l10n.otpRateLimited;
    case 'TOO_MANY_REQUESTS':
      return l10n.errTooManyRequests;
    case 'SMS_NOT_SENT':
      return l10n.smsNotSent;
    case 'ACCOUNT_BLOCKED':
      return l10n.accountBlocked;
    case 'GOOGLE_TOKEN_INVALID':
    case 'GOOGLE_NOT_CONFIGURED':
    case 'GOOGLE_LINK_EXPIRED':
    case 'GOOGLE_ALREADY_LINKED':
      return l10n.googleFailed;
    default:
      return l10n.somethingWentWrong;
  }
}

String sessionEndMessage(WWLocalizations l10n, SessionEndReason? reason) => switch (reason) {
  SessionEndReason.loggedInElsewhere => l10n.loggedInElsewhere,
  SessionEndReason.expired || SessionEndReason.revoked => l10n.sessionExpired,
  SessionEndReason.accountDeleted => l10n.accountDeletionRequested,
  SessionEndReason.accountErased => l10n.accountErased,
  SessionEndReason.accountBlocked => l10n.accountBlocked,
  SessionEndReason.jobOver => l10n.tempJobOver,
  SessionEndReason.loggedOut || null => '',
};

/// "+91 98765 43210" for display.
String formatIndianPhone(String digits) {
  final d = digits.replaceAll(RegExp(r'\D'), '');
  final local = d.length > 10 ? d.substring(d.length - 10) : d;
  if (local.length != 10) return digits;
  return '+91 ${local.substring(0, 5)} ${local.substring(5)}';
}

bool isValidIndianMobile(String digits) => RegExp(r'^[6-9]\d{9}$').hasMatch(digits);
