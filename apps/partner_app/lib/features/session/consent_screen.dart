import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../registration/partner_errors.dart';
import 'account_actions.dart';
import 'language_button.dart';
import 'session_controller.dart';

/// Before anything else (ARCHITECTURE §6.20, DPDP Act): the Partner Terms and the Privacy
/// Policy, each readable in the browser. New partners accept before registering; partners who
/// registered earlier, and everyone after a change WellWish asks about again, at their next
/// app open. Each acceptance is stored with its version, time and IP.
class PartnerConsentScreen extends ConsumerStatefulWidget {
  const PartnerConsentScreen({super.key});

  static const path = '/consent';

  @override
  ConsumerState<PartnerConsentScreen> createState() => _PartnerConsentScreenState();
}

class _PartnerConsentScreenState extends ConsumerState<PartnerConsentScreen> {
  /// Ticked lines, by type and version: a newer version is never ticked for them.
  final _accepted = <String>{};
  bool _saving = false;
  String? _error;

  Future<void> _accept(List<ConsentNeededOut> needed) async {
    final l10n = WWLocalizations.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(sessionProvider.notifier).acceptConsents(needed);
    } catch (e) {
      if (toApiException(e).code == 'CONSENT_VERSION_CHANGED') {
        // WellWish published a new version meanwhile: show it, ask again
        await ref.read(sessionProvider.notifier).reloadMe().catchError((Object _) {});
        if (mounted) {
          setState(() {
            _accepted.clear();
            _error = l10n.consentChanged;
          });
        }
      } else if (mounted) {
        setState(() => _error = partnerErrorMessage(l10n, e));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final needed = ref.watch(sessionProvider.select((s) => s.me?.consentsNeeded)) ?? const [];
    final texts = {
      ConsentNeededOutTypeEnum.PARTNER_TERMS: (
        l10n.consentPartnerTerms,
        l10n.consentPartnerTermsDetail,
        PublicPage.partnerTerms,
        l10n.legalPartnerTerms,
      ),
      ConsentNeededOutTypeEnum.PRIVACY: (
        l10n.consentPrivacy,
        l10n.consentPrivacyDetail,
        PublicPage.privacy,
        l10n.legalPrivacy,
      ),
    };
    final shown = needed.where((c) => texts.containsKey(c.type)).toList();
    String id(ConsentNeededOut c) => '${c.type.value}:${c.version}';
    final allChecked = shown.every((c) => _accepted.contains(id(c)));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.consentTitle),
        automaticallyImplyLeading: false,
        actions: const [LanguageButton()],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Text(l10n.consentSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
            const SizedBox(height: WWSpacing.lg),
            for (final consent in shown) ...[
              WWCheckTile(
                key: Key('consent-${consent.type.value}'),
                value: _accepted.contains(id(consent)),
                title: texts[consent.type]!.$1,
                detail: texts[consent.type]!.$2,
                onChanged: (v) => setState(() => v ? _accepted.add(id(consent)) : _accepted.remove(id(consent))),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: WWLinkButton(
                  key: Key('consent-read-${consent.type.value}'),
                  label: l10n.legalRead(texts[consent.type]!.$4),
                  onPressed: () => openLegalPage(context, ref, texts[consent.type]!.$3),
                ),
              ),
              const SizedBox(height: WWSpacing.sm),
            ],
            if (_error != null) ...[
              WWMessageBox(message: _error!, isError: true),
              const SizedBox(height: WWSpacing.md),
            ],
            const SizedBox(height: WWSpacing.lg),
            WWPrimaryButton(
              key: const Key('consent-agree'),
              label: l10n.agreeAndContinue,
              loading: _saving,
              onPressed: allChecked && shown.isNotEmpty ? () => _accept(shown) : null,
            ),
            // not for them (wrong number or app, or no to the terms): the way out is here too
            const SizedBox(height: WWSpacing.xxl),
            const AccountLinks(),
            const SizedBox(height: WWSpacing.lg),
            WWSecondaryButton(
              label: l10n.logout,
              icon: const Icon(Icons.logout, color: WWColors.danger),
              onPressed: () => ref.read(sessionProvider.notifier).logout(),
            ),
          ],
        ),
      ),
    );
  }
}
