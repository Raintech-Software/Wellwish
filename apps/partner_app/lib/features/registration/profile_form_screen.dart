import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import 'device_tools.dart';
import 'partner_errors.dart';
import 'registration_controller.dart';
import 'widgets.dart';

/// Stored values (English, as the admin sees them) → labels in the app's language.
Map<String, String> languageLabels(WWLocalizations l10n) => {
  'Odia': l10n.languageOdia,
  'Hindi': l10n.languageHindi,
  'English': l10n.languageEnglish,
  'Bengali': l10n.languageBengali,
  'Telugu': l10n.languageTelugu,
};

Map<String, String> skillLabels(WWLocalizations l10n, String role) => {
  'Elderly care': l10n.skillElderlyCare,
  'Wheelchair help': l10n.skillWheelchair,
  if (role == 'COMPANION') 'Hospital paperwork': l10n.skillPaperwork,
  'Two-wheeler': l10n.skillTwoWheeler,
  'Car driving': l10n.skillCar,
  if (role == 'NURSE') ...{
    'Injections': l10n.skillInjections,
    'Wound dressing': l10n.skillDressing,
    'IV drip': l10n.skillIvDrip,
    'Post-surgery care': l10n.skillPostSurgery,
  },
};

/// R05 Register — profile (§6.3 step 5): photo, name, DOB, gender, home address + pin,
/// languages, skills, emergency contact.
class ProfileFormScreen extends ConsumerStatefulWidget {
  const ProfileFormScreen({super.key});

  static const path = '/register/profile';

  @override
  ConsumerState<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends ConsumerState<ProfileFormScreen> {
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();
  DateTime? _dob;
  ProfileInGenderEnum? _gender;
  String _photoKey = '';
  String? _photoUrl;
  Uint8List? _photoPreview;
  String? _lat;
  String? _lng;
  Set<String> _languages = {};
  Set<String> _skills = {};
  bool _photoBusy = false;
  bool _locating = false;
  bool _saving = false;
  bool _submitted = false;
  String? _error;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    final p = ref.read(registrationProvider).value?.profile;
    if (p != null) {
      _name.text = p.fullName;
      _address.text = p.address;
      _emergencyName.text = p.emergencyName;
      _emergencyPhone.text = p.emergencyPhone.replaceFirst('+91', '');
      _dob = p.dob;
      _gender = ProfileInGenderEnum.values.where((g) => g.value == p.gender).firstOrNull;
      _photoKey = p.photoKey;
      _photoUrl = p.photoUrl;
      _lat = p.lat;
      _lng = p.lng;
      _languages = {...p.languages};
      _skills = {...p.skills};
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _emergencyName.dispose();
    _emergencyPhone.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(PickSource source) async {
    final l10n = WWLocalizations.of(context);
    final file = await ref.read(filePickerProvider).pick(source);
    if (file == null) return;
    setState(() {
      _photoBusy = true;
      _error = null;
    });
    try {
      final key = await ref.read(registrationProvider.notifier).uploadPhoto(file);
      setState(() {
        _photoKey = key;
        _photoPreview = file.bytes;
      });
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _photoBusy = false);
    }
  }

  Future<void> _locate() async {
    final l10n = WWLocalizations.of(context);
    setState(() {
      _locating = true;
      _locationError = null;
    });
    final result = await ref.read(locationServiceProvider).current();
    if (!mounted) return;
    setState(() {
      _locating = false;
      final position = result.position;
      if (position == null) {
        _locationError = switch (result.problem) {
          LocationProblem.denied => l10n.locationDenied,
          LocationProblem.off => l10n.locationOff,
          _ => l10n.somethingWentWrong,
        };
      } else {
        _lat = position.$1.toStringAsFixed(6);
        _lng = position.$2.toStringAsFixed(6);
      }
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 30, 1, 1),
      firstDate: DateTime(now.year - 80),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  bool get _valid =>
      _photoKey.isNotEmpty &&
      _name.text.trim().length >= 2 &&
      _dob != null &&
      _gender != null &&
      _address.text.trim().length >= 5 &&
      _lat != null &&
      _languages.isNotEmpty &&
      _emergencyName.text.trim().length >= 2 &&
      isValidIndianMobile(_emergencyPhone.text.trim());

  Future<void> _save() async {
    final l10n = WWLocalizations.of(context);
    setState(() => _submitted = true);
    if (!_valid) {
      // the field errors may be off screen: say so where it's always seen
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.fixMarkedFields)));
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(registrationProvider.notifier)
          .saveProfile(
            ProfileIn(
              fullName: _name.text.trim(),
              dob: DateTime(_dob!.year, _dob!.month, _dob!.day),
              gender: _gender!,
              photoKey: _photoKey,
              address: _address.text.trim(),
              lat: _lat!,
              lng: _lng!,
              languages: _languages.toList(),
              skills: _skills.toList(),
              emergencyName: _emergencyName.text.trim(),
              emergencyPhone: _emergencyPhone.text.trim(),
            ),
          );
      if (mounted && context.canPop()) context.pop();
    } catch (e) {
      if (mounted) setState(() => _error = partnerErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final config = ref.watch(appConfigProvider);
    final role = ref.watch(registrationProvider).value?.profile.role ?? 'COMPANION';
    final languages = languageLabels(l10n);
    final skills = skillLabels(l10n, role);
    ImageProvider? photo;
    if (_photoPreview != null) {
      photo = MemoryImage(_photoPreview!);
    } else if (_photoUrl != null) {
      photo = NetworkImage(fileUrl(config, _photoUrl!));
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.stepProfile)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundColor: WWColors.tint,
                backgroundImage: photo,
                child: _photoBusy
                    ? const CircularProgressIndicator()
                    : photo == null
                    ? const Icon(Icons.person, size: 52, color: WWColors.primary)
                    : null,
              ),
            ),
            const SizedBox(height: WWSpacing.sm),
            Text(l10n.photoHelp, style: WWType.caption, textAlign: TextAlign.center),
            const SizedBox(height: WWSpacing.sm),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: WWSpacing.sm,
              children: [
                WWSecondaryButton(
                  label: l10n.takePhoto,
                  icon: const Icon(Icons.photo_camera_outlined),
                  onPressed: _photoBusy ? null : () => _pickPhoto(PickSource.frontCamera),
                ),
                WWSecondaryButton(
                  label: l10n.chooseFromGallery,
                  icon: const Icon(Icons.photo_library_outlined),
                  onPressed: _photoBusy ? null : () => _pickPhoto(PickSource.gallery),
                ),
              ],
            ),
            if (_submitted && _photoKey.isEmpty)
              Text(
                l10n.photoRequired,
                style: WWType.caption.copyWith(color: WWColors.danger),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.fullName),
            WWTextField(
              controller: _name,
              hint: l10n.fullNameHint,
              errorText: _submitted && _name.text.trim().length < 2 ? l10n.nameRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.dateOfBirth),
            WWDateField(
              text: _dob == null ? null : formatDate(context, _dob!),
              placeholder: l10n.selectDate,
              onTap: _pickDob,
              errorText: _submitted && _dob == null ? l10n.dobRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.gender),
            WWChoicePills<ProfileInGenderEnum>(
              choices: [
                WWChoice(value: ProfileInGenderEnum.FEMALE, label: l10n.genderFemale),
                WWChoice(value: ProfileInGenderEnum.MALE, label: l10n.genderMale),
                WWChoice(value: ProfileInGenderEnum.OTHER, label: l10n.genderOther),
              ],
              selected: _gender,
              onSelected: (g) => setState(() => _gender = g),
              errorText: _submitted && _gender == null ? l10n.genderRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.homeAddress),
            WWTextField(
              controller: _address,
              hint: l10n.homeAddressHint,
              errorText: _submitted && _address.text.trim().length < 5 ? l10n.addressRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.homeLocation),
            Text(l10n.homeLocationHelp, style: WWType.caption),
            const SizedBox(height: WWSpacing.sm),
            WWSecondaryButton(
              label: _lat == null ? l10n.useCurrentLocation : '${l10n.locationSaved} · $_lat, $_lng',
              icon: _locating
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(
                      _lat == null ? Icons.my_location : Icons.check_circle,
                      color: _lat == null ? null : WWColors.brandGreen,
                    ),
              onPressed: _locating ? null : _locate,
            ),
            if (_locationError != null || (_submitted && _lat == null))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _locationError ?? l10n.locationRequired,
                  style: WWType.caption.copyWith(color: WWColors.danger),
                ),
              ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.languagesYouSpeak),
            WWMultiChoicePills<String>(
              choices: [for (final e in languages.entries) WWChoice(value: e.key, label: e.value)],
              selected: _languages,
              onChanged: (v) => setState(() => _languages = v),
              errorText: _submitted && _languages.isEmpty ? l10n.languagesRequired : null,
            ),
            const SizedBox(height: WWSpacing.lg),
            WWFieldLabel(l10n.skillsLabel),
            WWMultiChoicePills<String>(
              choices: [for (final e in skills.entries) WWChoice(value: e.key, label: e.value)],
              selected: _skills,
              onChanged: (v) => setState(() => _skills = v),
            ),
            const SizedBox(height: WWSpacing.lg),
            Text(l10n.emergencyContact, style: WWType.section),
            const SizedBox(height: WWSpacing.sm),
            WWTextField(
              controller: _emergencyName,
              label: l10n.emergencyName,
              errorText: _submitted && _emergencyName.text.trim().length < 2 ? l10n.emergencyRequired : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: WWSpacing.md),
            WWPhoneField(
              controller: _emergencyPhone,
              hint: l10n.emergencyPhone,
              errorText: _submitted && !isValidIndianMobile(_emergencyPhone.text.trim()) ? l10n.invalidPhone : null,
              onChanged: (_) => setState(() {}),
            ),
            ErrorNote(_error),
            const SizedBox(height: WWSpacing.xl),
            WWPrimaryButton(label: l10n.save, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
