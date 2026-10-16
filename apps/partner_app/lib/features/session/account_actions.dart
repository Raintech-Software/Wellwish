import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../registration/partner_errors.dart';
import 'session_controller.dart';

/// Opens a legal page (ARCHITECTURE §6.20) in the browser, in the app's language. What it needs
/// is read before waiting: the screen may be gone when the app-config arrives.
Future<void> openLegalPage(BuildContext context, WidgetRef ref, PublicPage page) async {
  final l10n = WWLocalizations.of(context);
  final language = Localizations.localeOf(context).languageCode;
  final container = ProviderScope.containerOf(context, listen: false);
  final open = container.read(openPublicPageProvider);
  final messenger = ScaffoldMessenger.maybeOf(context);
  void say(String message) => messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  try {
    final urls = await container.read(legalUrlsProvider.future);
    if (!await open(urls.linkOf(page), language)) say(l10n.somethingWentWrong); // no browser
  } catch (e) {
    container.invalidate(legalUrlsProvider); // the app-config again next time
    say(partnerErrorMessage(l10n, e));
  }
}

void _snack(BuildContext context, String message) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(message)));

/// "Delete my account" (§6.20), at every status: asks first (with the admin's waiting time),
/// then the server logs this partner out everywhere. Refused while a job is theirs.
Future<void> deletePartnerAccount(BuildContext context, WidgetRef ref) async {
  final l10n = WWLocalizations.of(context);
  final status = ref.read(sessionProvider).me?.partnerStatus;
  // never chose a role (or deleted before, still a patient): nothing to wait for, deleted now
  final atOnce = status == null || status == 'DELETED';
  var days = 7;
  try {
    days = (await ref.read(publicApiProvider).publicAppConfig()).data!.accountDeletionDays;
  } catch (_) {
    // offline: the default is shown, the request below fails with the offline message
  }
  if (!context.mounted) return;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteAccountTitle),
      content: SingleChildScrollView(
        child: Text(atOnce ? l10n.deleteLoginBody : l10n.partnerDeleteAccountBody(days)),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
        TextButton(
          key: const Key('confirm-delete-account'),
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: WWColors.danger),
          child: Text(l10n.deleteAccountConfirm),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  try {
    await ref.read(sessionProvider.notifier).deleteAccount();
  } catch (e) {
    if (context.mounted) _snack(context, partnerErrorMessage(l10n, e));
  }
}

/// The partner's legal pages and "Delete my account", for the Profile tab and the
/// registration and status screens (§6.20).
class AccountLinks extends ConsumerWidget {
  const AccountLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    return WWCard(
      padding: const EdgeInsets.symmetric(vertical: WWSpacing.xs),
      child: Column(
        children: [
          WWListTile(
            key: const Key('legal-partner-terms'),
            icon: Icons.description_outlined,
            title: l10n.legalPartnerTerms,
            onTap: () => openLegalPage(context, ref, PublicPage.partnerTerms),
          ),
          WWListTile(
            key: const Key('legal-privacy'),
            icon: Icons.privacy_tip_outlined,
            title: l10n.legalPrivacy,
            onTap: () => openLegalPage(context, ref, PublicPage.privacy),
          ),
          WWListTile(
            key: const Key('delete-account'),
            icon: Icons.delete_forever_outlined,
            title: l10n.deleteAccount,
            subtitle: l10n.partnerDeleteAccountHelp,
            iconColor: WWColors.danger,
            titleColor: WWColors.danger,
            showChevron: false,
            onTap: () => deletePartnerAccount(context, ref),
          ),
        ],
      ),
    );
  }
}
