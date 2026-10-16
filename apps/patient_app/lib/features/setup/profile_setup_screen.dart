import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../session/session_controller.dart';

/// P04 Profile setup: name, date of birth, gender, language. Creates the SELF member's
/// details on the server (PUT /v1/patient/me).
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  static const path = '/setup/profile';

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  DateTime? _dob;
  PatientMeInGenderEnum? _gender;
  PatientMeInLanguageEnum? _language;
  bool _saving = false;
  bool _submitted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final me = ref.read(sessionProvider).me;
    if (me != null) {
      _name.text = me.fullName;
      _dob = me.dob;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _language ??= switch (Localizations.localeOf(context).languageCode) {
      'hi' => PatientMeInLanguageEnum.hi,
      'or' => PatientMeInLanguageEnum.or,
      _ => PatientMeInLanguageEnum.en,
    };
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (_name.text.trim().length < 2 || _dob == null || _gender == null) return;
    final l10n = WWLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final me = await ref
          .read(patientApiProvider)
          .patientMeUpdate(
            patientMeIn: PatientMeIn(
              fullName: _name.text.trim(),
              dob: DateTime(_dob!.year, _dob!.month, _dob!.day),
              gender: _gender!,
              language: _language!,
            ),
          );
      ref.read(sessionProvider.notifier).updateMe(me.data!);
    } catch (e) {
      if (mounted) setState(() => _error = authErrorMessage(l10n, toApiException(e)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    // Full date with the year, e.g. "17 Jan 1996" (in the app's language).
    final dateFormat = DateFormat('d MMM y', Localizations.localeOf(context).toString());
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileSetupTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Text(l10n.profileSetupSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
            const SizedBox(height: WWSpacing.xl),
            WWFieldLabel(l10n.fullName),
            WWTextField(
              controller: _name,
              hint: l10n.fullNameHint,
              autofillHints: const [AutofillHints.name],
              errorText: _submitted && _name.text.trim().length < 2 ? l10n.nameRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.dateOfBirth),
            WWDateField(
              text: _dob == null ? null : dateFormat.format(_dob!),
              placeholder: l10n.selectDate,
              onTap: _pickDob,
              errorText: _submitted && _dob == null ? l10n.dobRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.gender),
            WWChoicePills<PatientMeInGenderEnum>(
              choices: [
                WWChoice(value: PatientMeInGenderEnum.FEMALE, label: l10n.genderFemale),
                WWChoice(value: PatientMeInGenderEnum.MALE, label: l10n.genderMale),
                WWChoice(value: PatientMeInGenderEnum.OTHER, label: l10n.genderOther),
              ],
              selected: _gender,
              onSelected: (g) => setState(() => _gender = g),
              errorText: _submitted && _gender == null ? l10n.genderRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.language),
            WWChoicePills<PatientMeInLanguageEnum>(
              choices: [
                WWChoice(value: PatientMeInLanguageEnum.en, label: l10n.languageEnglish),
                WWChoice(value: PatientMeInLanguageEnum.hi, label: l10n.languageHindi),
                WWChoice(value: PatientMeInLanguageEnum.or, label: l10n.languageOdia),
              ],
              selected: _language,
              onSelected: (lang) => setState(() => _language = lang),
            ),
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.lg),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.xxl),
            WWPrimaryButton(label: l10n.continueLabel, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
