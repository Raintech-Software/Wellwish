import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../common/booking_format.dart';
import '../common/patient_ui.dart';
import 'booking_flow.dart';
import 'visit_details_screen.dart';

/// P10 Book a Companion (mockup 6) and P11 Book a Nurse: the services with their price.
class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key, required this.partnerType});

  static const path = '/book/:type';
  static String pathFor(String type) => '/book/$type';

  final String partnerType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final draft = ref.watch(bookingDraftProvider);
    final services = ref.watch(servicesProvider(partnerType));
    final isNurse = partnerType == 'NURSE';
    final place = draft.doctor?.name ?? draft.hospital?.name;
    return Scaffold(
      appBar: AppBar(title: Text(isNurse ? l10n.tileBookNurse : l10n.tileBookCompanion)),
      body: services.when(
        loading: () => const WWLoading(),
        error: (e, _) => WWErrorState(
          message: patientErrorMessage(l10n, e),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(servicesProvider(partnerType)),
        ),
        data: (all) {
          // From a hospital or doctor page: the services that go to a hospital.
          final shown = draft.fromDirectory ? all.where((s) => s.visitType == 'HOSPITAL_VISIT').toList() : all;
          return ListView(
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Text(l10n.chooseService, style: WWType.section),
              if (place != null) ...[
                const SizedBox(height: WWSpacing.sm),
                WWMessageBox(message: l10n.bookingAt(place), icon: Icons.local_hospital_outlined),
              ],
              const SizedBox(height: WWSpacing.md),
              if (shown.isEmpty) WWEmptyState(icon: Icons.medical_services_outlined, title: l10n.noServices),
              for (final s in shown) ...[
                ServiceCard(
                  service: s,
                  onTap: () {
                    ref.read(bookingDraftProvider.notifier).chooseService(s);
                    pushStep(context, VisitDetailsScreen.path);
                  },
                ),
                const SizedBox(height: WWSpacing.sm),
              ],
            ],
          );
        },
      ),
    );
  }
}

IconData serviceIcon(String partnerType, String visitType) => switch ((partnerType, visitType)) {
  ('NURSE', _) => Icons.vaccines_outlined,
  (_, 'HOME_VISIT') => Icons.elderly_outlined,
  (_, 'ERRAND') => Icons.assignment_outlined,
  _ => Icons.local_hospital_outlined,
};

/// One service: icon, name, what it is, total price, time and whether a prescription is needed.
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.onTap});

  final ServiceOut service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = WWLocalizations.of(context);
    final description = serviceDescription(context, service);
    final color = service.partnerType == 'NURSE' ? WWColors.brandNavy : WWColors.brandGreen;
    return WWCard(
      key: Key('service-${service.id}'),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(serviceIcon(service.partnerType, service.visitType), color: color),
          ),
          const SizedBox(width: WWSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(serviceName(context, service), style: WWType.cardTitle),
                if (description.isNotEmpty) Text(description, style: WWType.caption),
                const SizedBox(height: WWSpacing.xs),
                Wrap(
                  spacing: WWSpacing.sm,
                  runSpacing: WWSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l10n.totalPrice(inr(service.pricePaise)),
                      style: WWType.body.copyWith(fontWeight: FontWeight.w600, color: WWColors.primary),
                    ),
                    Text(durationLabel(l10n, service.durationMin), style: WWType.caption),
                    if (service.docsRequired)
                      Text(
                        l10n.prescriptionNeeded,
                        style: WWType.caption.copyWith(color: WWColors.warning, fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: WWColors.textSecondary),
        ],
      ),
    );
  }
}
