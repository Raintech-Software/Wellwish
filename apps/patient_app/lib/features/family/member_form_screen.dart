import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import 'family_controller.dart';

/// P28 Add / edit a family member (ARCHITECTURE §6.18): details, health notes, emergency
/// contact and the consent tick. Editing yourself (`SELF`) hides the relation, your own phone
/// (that's the login number) and the consent.
class MemberFormScreen extends ConsumerStatefulWidget {
  const MemberFormScreen({super.key, this.member});

  static const addPath = '/member/new';
  static String editPathFor(String id) => '/member/$id/edit';

  /// The member being edited; null = add a new one.
  final MemberOut? member;

  @override
  ConsumerState<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends ConsumerState<MemberFormScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _conditions = TextEditingController();
  final _allergies = TextEditingController();
  final _sensory = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  MemberInRelationEnum? _relation;
  DateTime? _dob;
  MemberInGenderEnum? _gender;
  MemberInLanguageEnum _language = MemberInLanguageEnum.empty;
  MemberInMobilityEnum _mobility = MemberInMobilityEnum.empty;
  String _photoKey = '';
  String? _photoUrl;
  Uint8List? _photoPreview;
  bool _consent = false;
  bool _photoBusy = false;
  bool _saving = false;
  bool _submitted = false;
  String? _error;

  bool get _isSelf => widget.member?.isSelf ?? false;
  bool get _isEdit => widget.member != null;

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    if (m != null) {
      _relation = MemberInRelationEnum.values.firstWhere((r) => r.value == m.relation);
      _name.text = m.fullName;
      _dob = m.dob;
      _gender = MemberInGenderEnum.values.where((g) => g.value == m.gender).firstOrNull;
      _phone.text = m.phone.replaceFirst('+91', '');
      _language = MemberInLanguageEnum.values.firstWhere((l) => l.value == m.language, orElse: () => _language);
      _conditions.text = m.conditions;
      _allergies.text = m.allergies;
      _mobility = MemberInMobilityEnum.values.firstWhere((v) => v.value == m.mobility, orElse: () => _mobility);
      _sensory.text = m.sensoryNotes;
      _emergencyName.text = m.emergencyName;
      _emergencyPhone.text = m.emergencyPhone.replaceFirst('+91', '');
      _photoKey = m.photoKey;
      _photoUrl = m.photoUrl;
      _consent = m.consentAt != null;
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _conditions, _allergies, _sensory, _emergencyName, _emergencyPhone]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _phoneOk(String text) => text.trim().isEmpty || isValidIndianMobile(text.trim());

  bool get _emergencyOk =>
      _emergencyName.text.trim().isEmpty == _emergencyPhone.text.trim().isEmpty && _phoneOk(_emergencyPhone.text);

  bool get _valid =>
      (_isSelf || _relation != null) &&
      _name.text.trim().length >= 2 &&
      _dob != null &&
      _gender != null &&
      _phoneOk(_phone.text) &&
      _emergencyOk &&
      (_isSelf || _consent);

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 60, 1, 1),
      firstDate: DateTime(now.year - 120),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickPhoto(PickSource source) async {
    final l10n = WWLocalizations.of(context);
    final file = await ref.read(filePickerProvider).pick(source);
    if (file == null || !mounted) return;
    if (file.bytes.length > 5 * 1024 * 1024) {
      setState(() => _error = l10n.photoTooLarge);
      return;
    }
    setState(() {
      _photoBusy = true;
      _error = null;
    });
    try {
      final key = await ref.read(membersProvider.notifier).uploadPhoto(file);
      if (mounted) {
        setState(() {
          _photoKey = key;
          _photoPreview = file.bytes;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  Future<void> _save() async {
    final l10n = WWLocalizations.of(context);
    setState(() => _submitted = true);
    if (!_valid) {
      showSnack(context, l10n.fixMarkedFields);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = MemberIn(
      relation: _isSelf ? MemberInRelationEnum.SELF : _relation!,
      fullName: _name.text.trim(),
      dob: DateTime(_dob!.year, _dob!.month, _dob!.day),
      gender: _gender!,
      photoKey: _photoKey,
      phone: _isSelf ? '' : _phone.text.trim(),
      language: _language,
      conditions: _conditions.text.trim(),
      allergies: _allergies.text.trim(),
      mobility: _mobility,
      sensoryNotes: _sensory.text.trim(),
      emergencyName: _emergencyName.text.trim(),
      emergencyPhone: _emergencyPhone.text.trim(),
      consent: _isSelf || _consent,
    );
    try {
      final controller = ref.read(membersProvider.notifier);
      final saved = _isEdit ? await controller.save(widget.member!.id, body) : await controller.add(body);
      // The booking flow's "+ Add member" picks the new member straight away.
      if (mounted && context.canPop()) context.pop(saved);
    } catch (e) {
      if (mounted) setState(() => _error = patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final ImageProvider? photo = _photoPreview != null
        ? MemoryImage(_photoPreview!)
        : (_photoUrl != null ? NetworkImage(fileUrl(config, _photoUrl!)) : null);
    final relations = [
      (MemberInRelationEnum.MOTHER, l10n.relationMother),
      (MemberInRelationEnum.FATHER, l10n.relationFather),
      (MemberInRelationEnum.GRANDMOTHER, l10n.relationGrandmother),
      (MemberInRelationEnum.GRANDFATHER, l10n.relationGrandfather),
      (MemberInRelationEnum.SPOUSE, l10n.relationSpouse),
      (MemberInRelationEnum.CHILD, l10n.relationChild),
      (MemberInRelationEnum.SIBLING, l10n.relationSibling),
      (MemberInRelationEnum.OTHER, l10n.relationOther),
    ];
    final languages = [
      for (final l in MemberInLanguageEnum.values)
        if (l != MemberInLanguageEnum.empty) (l, memberLanguageLabel(l10n, l.value)),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? l10n.editDetailsTitle : l10n.addMemberTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Center(
              child: WWAvatar(name: _name.text, size: 96, image: photo),
            ),
            const SizedBox(height: WWSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: WWSecondaryButton(
                    label: l10n.takePhoto,
                    icon: const Icon(Icons.photo_camera_outlined, color: WWColors.primary),
                    onPressed: _photoBusy ? null : () => _pickPhoto(PickSource.camera),
                  ),
                ),
                const SizedBox(width: WWSpacing.sm),
                Expanded(
                  child: WWSecondaryButton(
                    label: l10n.chooseFromGallery,
                    icon: const Icon(Icons.photo_library_outlined, color: WWColors.primary),
                    onPressed: _photoBusy ? null : () => _pickPhoto(PickSource.gallery),
                  ),
                ),
              ],
            ),
            if (_photoBusy) ...[const SizedBox(height: WWSpacing.sm), const LinearProgressIndicator()],
            if (!_isSelf) ...[
              const SizedBox(height: WWSpacing.xl),
              WWFieldLabel(l10n.relation),
              WWChoicePills<MemberInRelationEnum>(
                key: const Key('relation'),
                choices: [for (final (value, label) in relations) WWChoice(value: value, label: label)],
                selected: _relation,
                onSelected: (r) => setState(() => _relation = r),
                errorText: _submitted && _relation == null ? l10n.relationRequired : null,
              ),
            ],
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.fullName),
            WWTextField(
              key: const Key('member-name'),
              controller: _name,
              hint: _isSelf ? l10n.fullNameHint : l10n.memberNameHint,
              maxLength: 80,
              errorText: _submitted && _name.text.trim().length < 2 ? l10n.nameRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.dateOfBirth),
            WWDateField(
              key: const Key('member-dob'),
              text: _dob == null ? null : formatDate(context, _dob!),
              placeholder: l10n.selectDate,
              onTap: _pickDob,
              errorText: _submitted && _dob == null ? l10n.dobRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.gender),
            WWChoicePills<MemberInGenderEnum>(
              choices: [
                WWChoice(value: MemberInGenderEnum.FEMALE, label: l10n.genderFemale),
                WWChoice(value: MemberInGenderEnum.MALE, label: l10n.genderMale),
                WWChoice(value: MemberInGenderEnum.OTHER, label: l10n.genderOther),
              ],
              selected: _gender,
              onSelected: (g) => setState(() => _gender = g),
              errorText: _submitted && _gender == null ? l10n.genderRequired : null,
            ),
            if (!_isSelf) ...[
              const SizedBox(height: WWSpacing.lg),
              WWFieldLabel(l10n.theirPhone),
              WWPhoneField(
                key: const Key('member-phone'),
                controller: _phone,
                hint: l10n.phoneHint,
                errorText: _submitted && !_phoneOk(_phone.text) ? l10n.invalidPhone : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: WWSpacing.xs),
              Text(l10n.theirPhoneHelp, style: WWType.caption),
            ],
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.languageTheySpeak),
            WWChoicePills<MemberInLanguageEnum>(
              choices: [for (final (value, label) in languages) WWChoice(value: value, label: label)],
              selected: _language == MemberInLanguageEnum.empty ? null : _language,
              onSelected: (l) => setState(() => _language = l == _language ? MemberInLanguageEnum.empty : l),
            ),
            const SizedBox(height: WWSpacing.xl),
            Text(l10n.healthNotes, style: WWType.section),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.healthNotesHelp, style: WWType.caption),
            const SizedBox(height: WWSpacing.md),
            WWFieldLabel(l10n.conditions),
            WWTextField(controller: _conditions, hint: l10n.conditionsHint, maxLines: 3, maxLength: 500),
            const SizedBox(height: WWSpacing.sm),
            WWFieldLabel(l10n.allergies),
            WWTextField(controller: _allergies, maxLines: 2, maxLength: 300),
            const SizedBox(height: WWSpacing.sm),
            WWFieldLabel(l10n.mobility),
            WWChoicePills<MemberInMobilityEnum>(
              choices: [
                WWChoice(value: MemberInMobilityEnum.WALKS_ALONE, label: l10n.mobilityWalksAlone),
                WWChoice(value: MemberInMobilityEnum.NEEDS_SUPPORT, label: l10n.mobilityNeedsSupport),
                WWChoice(value: MemberInMobilityEnum.WHEELCHAIR, label: l10n.mobilityWheelchair),
              ],
              selected: _mobility == MemberInMobilityEnum.empty ? null : _mobility,
              onSelected: (m) => setState(() => _mobility = m == _mobility ? MemberInMobilityEnum.empty : m),
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.sensoryNotes),
            WWTextField(controller: _sensory, hint: l10n.sensoryHint, maxLines: 2, maxLength: 300),
            const SizedBox(height: WWSpacing.lg),
            Text(l10n.emergencyContact, style: WWType.section),
            const SizedBox(height: WWSpacing.xs),
            Text(l10n.emergencyContactHelp, style: WWType.caption),
            const SizedBox(height: WWSpacing.md),
            WWTextField(
              controller: _emergencyName,
              hint: l10n.emergencyName,
              maxLength: 80,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.md),
            WWPhoneField(
              controller: _emergencyPhone,
              hint: l10n.emergencyPhone,
              errorText: _submitted && !_emergencyOk ? l10n.emergencyIncomplete : null,
              onChanged: (_) => setState(() {}),
            ),
            if (!_isSelf) ...[
              const SizedBox(height: WWSpacing.xl),
              WWCheckTile(
                key: const Key('member-consent'),
                value: _consent,
                onChanged: (v) => setState(() => _consent = v),
                title: l10n.consentMember,
              ),
              if (_submitted && !_consent)
                Padding(
                  padding: const EdgeInsets.only(top: WWSpacing.xs),
                  child: Text(l10n.consentRequired, style: WWType.caption.copyWith(color: WWColors.danger)),
                ),
            ],
            if (_error != null) ...[
              const SizedBox(height: WWSpacing.lg),
              WWMessageBox(message: _error!, isError: true),
            ],
            const SizedBox(height: WWSpacing.xl),
            WWPrimaryButton(key: const Key('member-save'), label: l10n.save, loading: _saving, onPressed: _save),
            const SizedBox(height: WWSpacing.lg),
          ],
        ),
      ),
    );
  }
}
