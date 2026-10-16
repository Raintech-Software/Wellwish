import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import 'auth_messages.dart';
import 'phone_login_screen.dart';
import 'sms_code_reader.dart';

/// P03 / R02 OTP (style of mockup 2): 6 boxes, resend countdown, Android SMS auto-read.
/// Checks the code as soon as 6 digits are in.
class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.auth,
    required this.smsReader,
    required this.args,
    required this.onVerified,
    required this.onChangeNumber,
    this.partner = false,
  });

  final AuthRepository auth;
  final SmsCodeReader smsReader;
  final OtpArgs args;

  /// Called after the tokens are saved. `isNewUser` is true for a brand-new account.
  final Future<void> Function(bool isNewUser) onVerified;
  final VoidCallback onChangeNumber;
  final bool partner;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  late int _secondsLeft = widget.args.resendAfterSeconds;
  bool _verifying = false;
  bool _resending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startCountdown(widget.args.resendAfterSeconds);
    _listenForSms();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.smsReader.stop();
    _code.dispose();
    super.dispose();
  }

  Future<void> _listenForSms() async {
    final code = await widget.smsReader.waitForCode();
    if (mounted && code != null && code.length == 6 && !_verifying) {
      _code.text = code; // the field calls _verify once 6 digits are in
    }
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 9999));
      if (_secondsLeft == 0) timer.cancel();
    });
  }

  Future<void> _verify(String code) async {
    if (_verifying) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _verifying = true;
      _error = null;
    });
    final bool isNew;
    try {
      isNew = await widget.auth.verifyOtp(
        widget.args.phone,
        code,
        googleLinkToken: widget.args.googleLinkToken,
        // a new account starts in the language the app is showing now (§5)
        language: Localizations.localeOf(context).languageCode,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _code.clear();
      setState(() => _error = authErrorMessage(l10n, e));
      if (mounted) setState(() => _verifying = false);
      return;
    }
    // The code was right and the tokens are saved: whatever the app does next is its job.
    try {
      await widget.onVerified(isNew);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(l10n, toApiException(e)));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    final l10n = WWLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _resending = true;
      _error = null;
    });
    try {
      final sent = await widget.auth.sendOtp(widget.args.phone, appHash: await widget.smsReader.appHash());
      _code.clear();
      _startCountdown(sent.resendAfterSeconds);
      unawaited(_listenForSms());
      messenger.showSnackBar(SnackBar(content: Text(l10n.codeResent)));
    } on ApiException catch (e) {
      final wait = e.details['retryAfterSeconds'];
      if (e.code == 'OTP_RESEND_TOO_SOON' && wait is int) {
        _startCountdown(wait);
      } else if (mounted) {
        setState(() => _error = authErrorMessage(l10n, e));
      }
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    return WWAuthLayout(
      title: l10n.otpTitle,
      subtitle: l10n.otpSentTo(formatIndianPhone(widget.args.phone)),
      logoSemanticLabel: '${l10n.appName}. ${l10n.brandTagline}',
      badge: widget.partner ? l10n.partnerBadge : null,
      onBack: widget.onChangeNumber,
      children: [
        WWOtpField(
          controller: _code,
          semanticLabel: l10n.otpFieldLabel,
          hasError: _error != null,
          onCompleted: _verify,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
        ),
        if (_error != null) ...[const SizedBox(height: WWSpacing.md), WWMessageBox(message: _error!, isError: true)],
        const SizedBox(height: WWSpacing.lg),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: WWSpacing.sm,
          children: [
            WWLinkButton(label: l10n.changeNumber, onPressed: widget.onChangeNumber),
            if (_secondsLeft > 0)
              Text(l10n.resendIn(_secondsLeft), style: WWType.caption)
            else
              WWLinkButton(label: l10n.resendCode, onPressed: _resending ? null : _resend),
          ],
        ),
        const SizedBox(height: WWSpacing.lg),
        WWPrimaryButton(
          label: l10n.verify,
          loading: _verifying,
          onPressed: () {
            if (_code.text.length == 6) _verify(_code.text);
          },
        ),
      ],
    );
  }
}
