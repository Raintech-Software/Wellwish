import 'package:flutter/material.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

/// A registration or document error in the user's language (the server's English text is
/// not shown). Login/OTP codes fall back to the shared login messages.
String partnerErrorMessage(WWLocalizations l10n, Object error) {
  final e = error is ApiException ? error : toApiException(error);
  switch (e.code) {
    case 'TOO_MANY_REQUESTS':
      return l10n.errTooManyRequests;
    case 'SAME_AS_PRIMARY':
      return l10n.errSameAsPrimary;
    case 'EMAIL_TAKEN':
      return l10n.errEmailTaken;
    case 'EMAIL_CODE_INVALID':
      return l10n.errCodeWrong;
    case 'EMAIL_CODE_EXPIRED':
      return l10n.otpExpired;
    case 'EMAIL_CODE_TOO_MANY_ATTEMPTS':
      return l10n.otpTooManyAttempts;
    case 'EMAIL_RESEND_TOO_SOON':
    case 'EMAIL_RATE_LIMITED':
    case 'OTP_RESEND_TOO_SOON':
      return l10n.errWaitBeforeResend;
    case 'EMAIL_NOT_SENT':
      return l10n.errEmailNotSent;
    case 'TOO_YOUNG':
      return l10n.errTooYoung;
    case 'EMERGENCY_IS_YOU':
      return l10n.errEmergencyIsYou;
    case 'INVALID_EMERGENCY_PHONE':
      return l10n.invalidPhone;
    case 'INVALID_AADHAAR':
      return l10n.errInvalidAadhaar;
    case 'INVALID_PAN':
      return l10n.errInvalidPan;
    case 'NUMBER_REQUIRED':
    case 'INVALID_NUMBER':
      return l10n.numberRequired;
    case 'EXPIRY_REQUIRED':
      return l10n.expiryRequired;
    case 'ALREADY_EXPIRED':
      return l10n.errAlreadyExpired;
    case 'INVALID_FILE':
    case 'FILE_NOT_FOUND':
      return l10n.errInvalidFile;
    case 'FILE_TOO_LARGE':
      return l10n.errFileTooLarge;
    case 'UPLOAD_EXPIRED': // the signed upload ran out (§6.8)
      return l10n.errUploadAgain;
    case 'DOCUMENTS_MISSING':
      return l10n.errDocumentsMissing;
    case 'DETAILS_MISSING':
      return l10n.errDetailsMissing;
    case 'NOT_EDITABLE':
    case 'ROLE_LOCKED':
      return l10n.errNotEditable;
    case 'ACTIVE_JOBS': // §6.20: deleting the account with a job still theirs
      return l10n.errorActiveJobs;
    case 'OFFER_NOT_OPEN':
      return l10n.errOfferNotOpen;
    case 'PARTNER_BUSY':
      return l10n.errPartnerBusy;
    case 'SELFIE_REQUIRED':
      return l10n.selfieNeeded;
    case 'NOT_FOUND':
      return l10n.errNotFound;
    default:
      return authErrorMessage(l10n, e);
  }
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
