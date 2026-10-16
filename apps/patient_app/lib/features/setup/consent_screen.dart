import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../providers.dart';
import '../common/patient_ui.dart';
import '../session/session_controller.dart';

/// Consent (ARCHITECTURE §12, DPDP Act): terms, privacy, health data. Each accepted consent
/// is stored with its version, time and IP. Shown again when a version changes.
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  static const path = '/setup/consent';

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
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
      await ref
          .read(patientApiProvider)
          .patientConsentsAccept(
            consentsIn: ConsentsIn(
              items: [
                for (final c in needed)
                  ConsentItemIn(type: ConsentItemInTypeEnum.values.byName(c.type.value), version: c.version),
              ],
            ),
          );
      // the location step only at sign-up (health data is asked then), not when WellWish asks
      // again after changing its terms (§6.20)
      final firstTime = needed.any((c) => c.type == ConsentNeededOutTypeEnum.HEALTH_DATA);
      await ref.read(sessionProvider.notifier).consentsAccepted(askLocation: firstTime);
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
        setState(() => _error = authErrorMessage(l10n, toApiException(e)));
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
      ConsentNeededOutTypeEnum.TERMS: (l10n.consentTerms, l10n.consentTermsDetail),
      ConsentNeededOutTypeEnum.PRIVACY: (l10n.consentPrivacy, l10n.consentPrivacyDetail),
      ConsentNeededOutTypeEnum.HEALTH_DATA: (l10n.consentHealthData, l10n.consentHealthDataDetail),
    };
    // §6.20: each line can be read; health data is explained in the Privacy Policy
    final pages = {
      ConsentNeededOutTypeEnum.TERMS: (PublicPage.terms, l10n.legalTerms),
      ConsentNeededOutTypeEnum.PRIVACY: (PublicPage.privacy, l10n.legalPrivacy),
      ConsentNeededOutTypeEnum.HEALTH_DATA: (PublicPage.privacy, l10n.legalPrivacy),
    };
    String id(ConsentNeededOut c) => '${c.type.value}:${c.version}';
    final allChecked = needed.every((c) => _accepted.contains(id(c)));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.consentTitle), automaticallyImplyLeading: false),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(WWSpacing.screen),
          children: [
            Text(l10n.consentSubtitle, style: WWType.caption.copyWith(fontSize: 13)),
            const SizedBox(height: WWSpacing.lg),
            for (final consent in needed) ...[
              WWCheckTile(
                value: _accepted.contains(id(consent)),
                title: texts[consent.type]!.$1,
                detail: texts[consent.type]!.$2,
                onChanged: (v) => setState(() => v ? _accepted.add(id(consent)) : _accepted.remove(id(consent))),
              ),
              if (pages[consent.type] case (final page, final name))
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: WWLinkButton(
                    key: Key('consent-read-${consent.type.value}'),
                    label: l10n.legalRead(name),
                    onPressed: () => openLegalPage(context, ref, page),
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
              label: l10n.agreeAndContinue,
              loading: _saving,
              onPressed: allChecked && needed.isNotEmpty ? () => _accept(needed) : null,
            ),
          ],
        ),
      ),
    );
  }
}
