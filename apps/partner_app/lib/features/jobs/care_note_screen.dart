import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../registration/partner_errors.dart';
import '../session/session_controller.dart';
import 'jobs_providers.dart';
import 'visit_controller.dart';

/// R13 Care note (§6.11): at "Care done" the nurse writes a short note; BP, pulse, temperature,
/// SpO₂ and sugar are optional. It goes to the patient's documents as a care note.
class CareNoteScreen extends ConsumerStatefulWidget {
  const CareNoteScreen({super.key, required this.bookingId});

  static const path = '/job/:id/care-note';
  static String pathFor(String id) => '/job/$id/care-note';

  final String bookingId;

  @override
  ConsumerState<CareNoteScreen> createState() => _CareNoteScreenState();
}

class _CareNoteScreenState extends ConsumerState<CareNoteScreen> {
  final _form = GlobalKey<FormState>();
  final _note = TextEditingController();
  final _bp = TextEditingController();
  final _pulse = TextEditingController();
  final _temp = TextEditingController();
  final _spo2 = TextEditingController();
  final _sugar = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_note, _bp, _pulse, _temp, _spo2, _sugar]) {
      c.dispose();
    }
    super.dispose();
  }

  String? Function(String?) _range(num min, num max, {bool decimal = false}) => (v) {
    final text = (v ?? '').trim();
    if (text.isEmpty) return null;
    final n = decimal ? double.tryParse(text) : int.tryParse(text);
    return n == null || n < min || n > max ? WWLocalizations.of(context).invalidValue : null;
  };

  Future<void> _save(PartnerJobOut job) async {
    if (_busy || !(_form.currentState?.validate() ?? false)) return;
    final l10n = WWLocalizations.of(context);
    // nurses must write a note (at least 3 characters, like the server): checked here too, so
    // a step kept offline isn't refused later
    final nurse = ref.read(sessionProvider).me?.role == 'NURSE';
    if (nurse && _note.text.trim().length < 3) {
      setState(() => _error = l10n.careNoteRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final vitals = VitalsIn(
      bp: _bp.text.trim(),
      pulse: int.tryParse(_pulse.text.trim()),
      temperatureF: double.tryParse(_temp.text.trim()),
      spo2: int.tryParse(_spo2.text.trim()),
      sugar: int.tryParse(_sugar.text.trim()),
    );
    final any =
        (vitals.bp ?? '').isNotEmpty ||
        [vitals.pulse, vitals.temperatureF, vitals.spo2, vitals.sugar].any((v) => v != null);
    try {
      final outcome = await ref
          .read(visitControllerProvider.notifier)
          .doStep(job, 'CARE_DONE', note: _note.text.trim(), vitals: any ? vitals : null);
      if (!mounted) return;
      if (outcome == StepOutcome.queued) showSnack(context, l10n.stepQueued);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final error = toApiException(e);
      setState(() {
        _busy = false;
        // offline with vitals: they need the network (without vitals the note is kept)
        _error = error.code == 'CARE_NOTE_REQUIRED' ? l10n.careNoteRequired : partnerErrorMessage(l10n, e);
      });
    }
  }

  Widget _field(
    String key,
    TextEditingController c,
    String label,
    String? Function(String?) check, {
    TextInputType type = TextInputType.number,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: WWSpacing.sm),
    child: TextFormField(
      key: Key(key),
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      validator: check,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final job = ref.watch(jobProvider(widget.bookingId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.careNoteTitle)),
      body: job.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: partnerErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(jobProvider(widget.bookingId)),
        ),
        data: (j) => Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              WWTextField(
                key: const Key('care-note'),
                controller: _note,
                label: l10n.careNoteHint,
                maxLines: 5,
                maxLength: 1000,
              ),
              const SizedBox(height: WWSpacing.md),
              Text(l10n.vitalsTitle, style: WWType.section),
              const SizedBox(height: WWSpacing.sm),
              _field(
                'vital-bp',
                _bp,
                l10n.bpLabel,
                (v) => (v ?? '').trim().isEmpty || RegExp(r'^\d{2,3}/\d{2,3}$').hasMatch(v!.trim())
                    ? null
                    : l10n.invalidValue,
                type: TextInputType.text,
              ),
              _field('vital-pulse', _pulse, l10n.pulseLabel, _range(20, 250)),
              _field(
                'vital-temp',
                _temp,
                l10n.temperatureLabel,
                _range(90, 110, decimal: true),
                type: const TextInputType.numberWithOptions(decimal: true),
              ),
              _field('vital-spo2', _spo2, l10n.spo2Label, _range(50, 100)),
              _field('vital-sugar', _sugar, l10n.sugarLabel, _range(20, 700)),
              if (_error != null) ...[
                const SizedBox(height: WWSpacing.sm),
                WWMessageBox(message: _error!, isError: true),
              ],
              const SizedBox(height: WWSpacing.md),
              WWPrimaryButton(
                key: const Key('save-care-note'),
                label: l10n.saveCareNote,
                loading: _busy,
                onPressed: _busy ? null : () => _save(j),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
