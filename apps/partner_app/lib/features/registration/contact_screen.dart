import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../session/session_controller.dart';
import 'partner_errors.dart';
import 'registration_controller.dart';
import 'widgets.dart';

/// R04 Register — phones and email (§6.3 steps 2–4). The login number is already verified;
/// the alternate number gets an OTP, the email a 6-digit code.
class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  static const path = '/register/contact';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final data = ref.watch(registrationProvider).value;
    final login = ref.watch(sessionProvider.select((s) => s.me?.phone)) ?? '';
    final phones = {for (final p in data?.profile.phones ?? <PhoneOut>[]) p.kind: p};
    final alternate = phones['ALTERNATE'];
    final profile = data?.profile;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contactTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            WWCard(
              child: Row(
                children: [
                  const Icon(Icons.phone_android, color: WWColors.primary),
                  const SizedBox(width: WWSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.loginNumber, style: WWType.caption),
                        Text(formatIndianPhone(login), style: WWType.cardTitle),
                      ],
                    ),
                  ),
                  WWBadge(
                    label: l10n.verified,
                    icon: Icons.check_circle,
                    color: WWColors.brandGreen,
                    background: WWColors.greenTint,
                  ),
                ],
              ),
            ),
            const SizedBox(height: WWSpacing.lg),
            _VerifyBlock(
              key: const Key('alternate-block'),
              title: l10n.alternateNumber,
              help: l10n.alternateHelp,
              verifiedValue: alternate != null && alternate.verified ? formatIndianPhone(alternate.phone) : null,
              // added by an admin: the number is on file, the partner only has to verify it
              initialValue: alternate != null && !alternate.verified ? alternate.phone.replaceFirst('+91', '') : '',
              isPhone: true,
              send: (value) async {
                final sent = await ref.read(registrationProvider.notifier).sendAlternate(value);
                return sent.resendAfterSeconds;
              },
              verify: (code) => ref.read(registrationProvider.notifier).verifyAlternate(code),
              targetLabel: formatIndianPhone,
              canChange: data?.canEdit ?? false,
            ),
            const SizedBox(height: WWSpacing.lg),
            _VerifyBlock(
              key: const Key('email-block'),
              title: l10n.emailLabel,
              help: l10n.emailHelp,
              verifiedValue: profile != null && profile.emailVerified ? profile.email : null,
              initialValue: profile != null && !profile.emailVerified ? profile.email : '',
              isPhone: false,
              send: (value) async {
                final sent = await ref.read(registrationProvider.notifier).sendEmail(value);
                return sent.resendAfterSeconds;
              },
              verify: (code) => ref.read(registrationProvider.notifier).verifyEmail(code),
              targetLabel: (v) => v,
              canChange: data?.canEdit ?? false,
            ),
          ],
        ),
      ),
    );
  }
}

/// Enter a phone or email → Send code → enter the 6 digits → verified.
class _VerifyBlock extends StatefulWidget {
  const _VerifyBlock({
    super.key,
    required this.title,
    required this.help,
    required this.verifiedValue,
    this.initialValue = '',
    required this.isPhone,
    required this.send,
    required this.verify,
    required this.targetLabel,
    required this.canChange,
  });

  final bool canChange;
  final String title;
  final String help;
  final String? verifiedValue;
  final String initialValue;
  final bool isPhone;
  final Future<int> Function(String value) send;
  final Future<void> Function(String code) verify;
  final String Function(String value) targetLabel;

  @override
  State<_VerifyBlock> createState() => _VerifyBlockState();
}

class _VerifyBlockState extends State<_VerifyBlock> {
  final _value = TextEditingController();
  final _code = TextEditingController();
  bool _editing = false;
  bool _codeSent = false;
  bool _busy = false;
  bool _submitted = false;
  String? _error;
  int _wait = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _value.text = widget.initialValue;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _value.dispose();
    _code.dispose();
    super.dispose();
  }

  bool get _valid => widget.isPhone
      ? isValidIndianMobile(_value.text.trim())
      : RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(_value.text.trim());

  void _countdown(int seconds) {
    _timer?.cancel();
    setState(() => _wait = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted || _wait <= 1) {
        t.cancel();
        if (mounted) setState(() => _wait = 0);
        return;
      }
      setState(() => _wait -= 1);
    });
  }

  Future<void> _send() async {
    setState(() => _submitted = true);
    if (!_valid) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final wait = await widget.send(_value.text.trim());
      _code.clear();
      // Unfocus the field itself (not the page scope, which would keep remembering it):
      // then the code boxes' autofocus takes the focus.
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _codeSent = true);
      _countdown(wait);
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verify(String code) async {
    final l10n = WWLocalizations.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.verify(code);
      if (mounted) {
        setState(() {
          _editing = false;
          _codeSent = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
      _code.clear();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final verified = widget.verifiedValue != null && !_editing;
    return WWCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: WWType.section)),
              if (verified)
                WWBadge(
                  label: l10n.verified,
                  icon: Icons.check_circle,
                  color: WWColors.brandGreen,
                  background: WWColors.greenTint,
                ),
            ],
          ),
          const SizedBox(height: WWSpacing.xs),
          Text(widget.help, style: WWType.caption),
          const SizedBox(height: WWSpacing.md),
          if (verified) ...[
            Text(widget.verifiedValue!, style: WWType.cardTitle),
          ] else ...[
            if (widget.isPhone)
              WWPhoneField(
                controller: _value,
                hint: l10n.phoneHint,
                errorText: _submitted && !_valid ? l10n.invalidPhone : null,
                onChanged: (_) => setState(() {}),
              )
            else
              WWTextField(
                controller: _value,
                hint: l10n.emailLabel,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                errorText: _submitted && !_valid ? l10n.invalidEmail : null,
                onChanged: (_) => setState(() {}),
              ),
            const SizedBox(height: WWSpacing.md),
            if (_codeSent) ...[
              Text(l10n.codeSentTo(widget.targetLabel(_value.text.trim())), style: WWType.caption),
              const SizedBox(height: WWSpacing.sm),
              WWOtpField(
                key: Key('${widget.key}-code'),
                controller: _code,
                semanticLabel: l10n.otpFieldLabel,
                hasError: _error != null,
                onCompleted: _verify,
              ),
              const SizedBox(height: WWSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: _wait > 0
                    ? Text(l10n.resendIn(_wait), style: WWType.caption)
                    : WWLinkButton(label: l10n.resendCode, onPressed: _busy ? () {} : _send),
              ),
            ] else
              WWPrimaryButton(label: l10n.sendCode, loading: _busy, onPressed: _send),
          ],
          if (verified && widget.canChange)
            Align(
              alignment: Alignment.centerRight,
              child: WWLinkButton(label: l10n.change, onPressed: () => setState(() => _editing = true)),
            ),
          ErrorNote(_error),
        ],
      ),
    );
  }
}
