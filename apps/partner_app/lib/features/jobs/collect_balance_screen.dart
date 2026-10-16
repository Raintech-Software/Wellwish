import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../registration/partner_errors.dart';
import 'job_format.dart';
import 'jobs_providers.dart';

/// R14 Collect balance (§6.11): the amount (pre-filled with the balance) and cash / UPI. It's
/// only a record: WellWish doesn't handle this money. Can be corrected for 24 hours.
class CollectBalanceScreen extends ConsumerStatefulWidget {
  const CollectBalanceScreen({super.key, required this.bookingId});

  static const path = '/job/:id/balance';
  static String pathFor(String id) => '/job/$id/balance';

  final String bookingId;

  @override
  ConsumerState<CollectBalanceScreen> createState() => _CollectBalanceScreenState();
}

class _CollectBalanceScreenState extends ConsumerState<CollectBalanceScreen> {
  final _amount = TextEditingController();
  final _note = TextEditingController();
  BalanceInModeEnum _mode = BalanceInModeEnum.CASH;
  bool _filled = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    final l10n = WWLocalizations.of(context);
    final paise = rupeesToPaise(_amount.text);
    if (paise == null || paise > 100000 * 100) {
      setState(() => _error = l10n.invalidValue);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final container = ProviderScope.containerOf(context, listen: false);
    try {
      await container
          .read(partnerApiProvider)
          .partnerJobBalance(
            bookingId: widget.bookingId,
            balanceIn: BalanceIn(amountPaise: paise, mode: _mode, note: _note.text.trim()),
          );
      jobsChanged(container.invalidate); // also when the screen was closed meanwhile
      if (!mounted) return;
      showSnack(context, l10n.balanceRecorded(inr(paise), _mode == BalanceInModeEnum.UPI ? l10n.payUpi : l10n.payCash));
      context.pop();
    } catch (e) {
      if (mounted) {
        final error = toApiException(e);
        final due = (error.details['duePaise'] as num?)?.toInt();
        setState(() {
          _busy = false;
          _error = switch (error.code) {
            'BALANCE_NOT_DUE' => l10n.balanceNotDue,
            'BALANCE_TOO_HIGH' when due != null => l10n.balanceTooHigh(inr(due)),
            _ => partnerErrorMessage(l10n, e),
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final job = ref.watch(jobProvider(widget.bookingId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.collectTitle)),
      body: job.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(jobProvider(widget.bookingId)),
        ),
        data: (j) {
          if (!_filled) {
            _filled = true;
            final recorded = j.visit?.balanceCollectedPaise;
            _amount.text = paiseToRupeesText(recorded ?? j.balancePaise);
            if (j.visit?.balanceMode == 'UPI') _mode = BalanceInModeEnum.UPI;
          }
          return ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Text(l10n.collectBody, style: WWType.body),
              const SizedBox(height: WWSpacing.md),
              TextField(
                key: const Key('balance-amount'),
                controller: _amount,
                // rupees with paise, e.g. 450.50 (PHASES 9.11)
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}([.,]\d{0,2})?'))],
                decoration: InputDecoration(labelText: l10n.amountRupees, prefixText: '₹ '),
              ),
              const SizedBox(height: WWSpacing.md),
              WWChoicePills<BalanceInModeEnum>(
                choices: [
                  WWChoice(key: const Key('mode-cash'), value: BalanceInModeEnum.CASH, label: l10n.payCash),
                  WWChoice(key: const Key('mode-upi'), value: BalanceInModeEnum.UPI, label: l10n.payUpi),
                ],
                selected: _mode,
                onSelected: (m) => setState(() => _mode = m),
              ),
              const SizedBox(height: WWSpacing.md),
              WWTextField(controller: _note, label: l10n.balanceNoteHint, maxLength: 200),
              if (_error != null) WWMessageBox(message: _error!, isError: true),
              const SizedBox(height: WWSpacing.md),
              WWPrimaryButton(
                key: const Key('save-balance'),
                label: l10n.recordBalance,
                color: WWColors.brandGreen,
                loading: _busy,
                onPressed: _busy ? null : _save,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// "450.5" → 45050 paise; whole rupees and up to 2 decimals ("450." and a decimal comma, "450,5",
/// too), never through a float (money is integer paise, CLAUDE.md). Null when it isn't an amount.
int? rupeesToPaise(String text) {
  final match = RegExp(r'^(\d{1,6})(?:[.,](\d{0,2}))?$').firstMatch(text.trim());
  if (match == null) return null;
  final paise = (match[2] ?? '').padRight(2, '0');
  return int.parse(match[1]!) * 100 + int.parse(paise);
}

/// 45050 → "450.50", 40000 → "400".
String paiseToRupeesText(int paise) {
  final rest = paise % 100;
  return rest == 0 ? '${paise ~/ 100}' : '${paise ~/ 100}.${rest.toString().padLeft(2, '0')}';
}
