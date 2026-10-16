import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import '../session/session_controller.dart';

/// P27 Settings: app language, notifications (the phone's settings) and "Delete my account"
/// (ARCHITECTURE §12: data removed after 7 days, payment records kept).
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static const path = '/settings';

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _savingLanguage = false;
  bool _deleting = false;

  /// The admin's "wait before deleting an account" setting (shown in the confirm text).
  int _deletionDays = 7;

  @override
  void initState() {
    super.initState();
    ref.read(publicApiProvider).publicAppConfig().then((config) {
      if (mounted) setState(() => _deletionDays = config.data!.accountDeletionDays);
    }, onError: (Object _) {}); // offline: the default is shown
  }

  Future<void> _setLanguage(PatientMeInLanguageEnum language) async {
    final current = ref.read(sessionProvider).me;
    if (current == null || current.language == language.value) return;
    final l10n = WWLocalizations.of(context);
    final container = ProviderScope.containerOf(context, listen: false);
    setState(() => _savingLanguage = true);
    try {
      final api = container.read(patientApiProvider);
      // The profile as the server has it now (it may have been edited on the family screen),
      // so changing the language never puts back an old name or date of birth.
      final me = (await api.patientMeGet()).data!;
      if (me.dob == null) return;
      final updated = await api.patientMeUpdate(
        patientMeIn: PatientMeIn(
          fullName: me.fullName,
          dob: me.dob!,
          gender: PatientMeInGenderEnum.values.firstWhere((g) => g.value == me.gender),
          language: language,
        ),
      );
      container.read(sessionProvider.notifier).updateMe(updated.data!);
    } catch (e) {
      if (mounted) showSnack(context, patientErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _savingLanguage = false);
    }
  }

  Future<void> _deleteAccount() async {
    final l10n = WWLocalizations.of(context);
    final ok = await confirmDanger(
      context,
      title: l10n.deleteAccountTitle,
      body: l10n.deleteAccountBody(_deletionDays),
      action: l10n.deleteAccountConfirm,
    );
    if (!ok || !mounted) return;
    setState(() => _deleting = true);
    try {
      await ref.read(sessionProvider.notifier).deleteAccount();
    } catch (e) {
      if (mounted) {
        setState(() => _deleting = false);
        showSnack(context, patientErrorMessage(l10n, e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final language = ref.watch(sessionProvider.select((s) => s.me?.language));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(WWSpacing.screen),
        children: [
          WWCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.language, style: WWType.cardTitle),
                const SizedBox(height: WWSpacing.md),
                WWChoicePills<PatientMeInLanguageEnum>(
                  key: const Key('settings-language'),
                  choices: [
                    WWChoice(value: PatientMeInLanguageEnum.en, label: l10n.languageEnglish),
                    WWChoice(value: PatientMeInLanguageEnum.hi, label: l10n.languageHindi),
                    WWChoice(value: PatientMeInLanguageEnum.or, label: l10n.languageOdia),
                  ],
                  selected: PatientMeInLanguageEnum.values.where((l) => l.value == language).firstOrNull,
                  onSelected: _savingLanguage ? (_) {} : _setLanguage,
                ),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.lg),
          WWCard(
            padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
            child: Column(
              children: [
                WWListTile(
                  icon: Icons.notifications_none,
                  title: l10n.notificationsLabel,
                  // Push notifications come with the Firebase key (KEYS-AND-ACCOUNTS #5); then
                  // this opens the phone's notification settings for the app.
                  subtitle: l10n.notificationsLater,
                  showChevron: false,
                ),
                WWListTile(
                  key: const Key('settings-delete-account'),
                  icon: Icons.delete_forever_outlined,
                  title: l10n.deleteAccount,
                  subtitle: l10n.deleteAccountHelp,
                  iconColor: WWColors.danger,
                  titleColor: WWColors.danger,
                  showChevron: false,
                  onTap: _deleting ? null : _deleteAccount,
                ),
              ],
            ),
          ),
          const SizedBox(height: WWSpacing.lg),
          WWCard(
            padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(WWSpacing.lg, WWSpacing.md, WWSpacing.lg, 0),
                  child: Text(l10n.legalTitle, style: WWType.cardTitle),
                ),
                for (final (page, title, icon) in [
                  (PublicPage.terms, l10n.legalTerms, Icons.description_outlined),
                  (PublicPage.privacy, l10n.legalPrivacy, Icons.privacy_tip_outlined),
                  (PublicPage.refunds, l10n.legalRefunds, Icons.currency_rupee),
                ])
                  WWListTile(
                    key: Key('settings-legal-${page.name}'),
                    icon: icon,
                    title: title,
                    onTap: () => openLegalPage(context, ref, page),
                  ),
              ],
            ),
          ),
          if (_deleting) ...[const SizedBox(height: WWSpacing.lg), const WWLoading()],
        ],
      ),
    );
  }
}
