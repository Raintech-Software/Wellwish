import 'package:flutter/material.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'auth_messages.dart';
import 'sms_code_reader.dart';

/// What the OTP screen needs to know.
class OtpArgs {
  const OtpArgs({required this.phone, required this.resendAfterSeconds, this.googleLinkToken});

  /// 10 digits, no +91.
  final String phone;
  final int resendAfterSeconds;

  /// Set when finishing a Google sign-in (patients).
  final String? googleLinkToken;
}

/// Result of the patient app's Google button.
class GoogleResult {
  const GoogleResult.loggedIn() : loggedIn = true, linkToken = null, cancelled = false;
  const GoogleResult.phoneRequired(String this.linkToken) : loggedIn = false, cancelled = false;
  const GoogleResult.cancelled() : loggedIn = false, linkToken = null, cancelled = true;

  final bool loggedIn;
  final String? linkToken;
  final bool cancelled;
}

/// P02 / R02 Login (mockup 2): phone number → Send OTP. The patient app adds Google and
/// "Create Account"; the partner app shows the "Partner" badge.
class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({
    super.key,
    required this.auth,
    required this.smsReader,
    required this.onCodeSent,
    this.partner = false,
    this.onGoogle,
    this.notice,
  });

  final AuthRepository auth;
  final SmsCodeReader smsReader;
  final void Function(OtpArgs args) onCodeSent;
  final bool partner;

  /// Shown only when set (patient app with Google sign-in configured).
  final Future<GoogleResult> Function()? onGoogle;

  /// e.g. "You logged in on another phone…"
  final String? notice;

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phone = TextEditingController();
  bool _creating = false;
  bool _sending = false;
  bool _googleBusy = false;
  String? _error;
  String? _googleLinkToken;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = WWLocalizations.of(context);
    final phone = _phone.text.trim();
    if (!isValidIndianMobile(phone)) {
      setState(() => _error = l10n.invalidPhone);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final sent = await widget.auth.sendOtp(phone, appHash: await widget.smsReader.appHash());
      if (!mounted) return;
      widget.onCodeSent(
        OtpArgs(phone: phone, resendAfterSeconds: sent.resendAfterSeconds, googleLinkToken: _googleLinkToken),
      );
    } on ApiException catch (e) {
      if (e.code == 'OTP_RESEND_TOO_SOON') {
        // A code was sent a moment ago: go straight to the code screen.
        final wait = e.details['retryAfterSeconds'];
        widget.onCodeSent(
          OtpArgs(phone: phone, resendAfterSeconds: wait is int ? wait : 30, googleLinkToken: _googleLinkToken),
        );
      } else {
        setState(() => _error = authErrorMessage(l10n, e));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _google() async {
    final l10n = WWLocalizations.of(context);
    setState(() {
      _googleBusy = true;
      _error = null;
    });
    try {
      final result = await widget.onGoogle!();
      if (!mounted || result.loggedIn || result.cancelled) return;
      setState(() => _googleLinkToken = result.linkToken);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(l10n, e));
    } catch (_) {
      if (mounted) setState(() => _error = l10n.googleFailed);
    } finally {
      if (mounted) setState(() => _googleBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final notice = _googleLinkToken != null ? l10n.googleVerifyPhone : widget.notice;
    final String title;
    final String subtitle;
    if (widget.partner) {
      // the same login for partners and for new companions / nurses who join (§6.3)
      title = l10n.partnerLoginTitle;
      subtitle = l10n.partnerLoginSubtitle;
    } else if (_creating) {
      title = l10n.createAccountTitle;
      subtitle = l10n.createAccountSubtitle;
    } else {
      title = l10n.loginWelcomeBack;
      subtitle = l10n.loginSubtitle;
    }

    return WWAuthLayout(
      title: title,
      subtitle: subtitle,
      logoSemanticLabel: '${l10n.appName}. ${l10n.brandTagline}',
      badge: widget.partner ? l10n.partnerBadge : null,
      footer: widget.partner
          ? Text(
              l10n.partnerJoinHint,
              key: const Key('partner-join-hint'),
              style: WWType.body,
              textAlign: TextAlign.center,
            )
          : Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(_creating ? l10n.haveAccount : l10n.newHere, style: WWType.body),
                WWLinkButton(
                  label: _creating ? l10n.login : l10n.createAccount,
                  onPressed: () => setState(() => _creating = !_creating),
                ),
              ],
            ),
      children: [
        if (notice != null && notice.isNotEmpty) ...[
          WWMessageBox(message: notice),
          const SizedBox(height: WWSpacing.lg),
        ],
        WWPhoneField(
          controller: _phone,
          hint: l10n.phoneHint,
          errorText: _error,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
        ),
        const SizedBox(height: WWSpacing.lg),
        WWPrimaryButton(label: l10n.sendOtp, loading: _sending, onPressed: _send),
        if (widget.onGoogle != null && _googleLinkToken == null) ...[
          const SizedBox(height: WWSpacing.xl),
          WWOrDivider(label: l10n.orDivider),
          const SizedBox(height: WWSpacing.lg),
          Center(child: Text(l10n.loginWith, style: WWType.caption)),
          const SizedBox(height: WWSpacing.md),
          WWGoogleButton(label: l10n.google, loading: _googleBusy, onPressed: _google),
        ],
      ],
    );
  }
}
