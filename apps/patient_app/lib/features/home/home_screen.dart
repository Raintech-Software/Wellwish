import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_l10n/ww_l10n.dart';
import 'package:ww_ui/ww_ui.dart';

import '../../feature_flags.dart';
import '../booking/booking_flow.dart';
import '../notifications/notifications_screen.dart';
import '../session/session_controller.dart';
import 'next_booking_card.dart';

/// P05 Home (mockup 3): the tiles, the next booking and the bell (the inbox P25, v2.32).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = WWLocalizations.of(context);
    final fullName = ref.watch(sessionProvider.select((s) => s.me?.fullName)) ?? '';
    final firstName = fullName.split(' ').first;
    final soon = l10n.comingSoon;

    final tiles = [
      WWFeatureTile(
        icon: Icons.medical_services_outlined,
        label: l10n.tileDoctors,
        badge: FeatureFlags.doctors ? null : soon,
        onTap: () => context.go('/doctors'),
      ),
      WWFeatureTile(
        icon: Icons.groups_2_outlined,
        color: WWColors.brandGreen,
        label: l10n.tileBookCompanion,
        badge: FeatureFlags.booking ? null : soon,
        onTap: () => startBooking(context, partnerType: 'COMPANION'),
      ),
      WWFeatureTile(
        icon: Icons.vaccines_outlined,
        color: WWColors.brandNavy,
        label: l10n.tileBookNurse,
        badge: FeatureFlags.booking ? null : soon,
        onTap: () => startBooking(context, partnerType: 'NURSE'),
      ),
      WWFeatureTile(
        icon: Icons.description_outlined,
        label: l10n.tileMedicalReports,
        badge: FeatureFlags.documents ? null : soon,
        onTap: () => context.go('/reports'),
      ),
      WWFeatureTile(
        icon: Icons.family_restroom,
        color: WWColors.familyPurple,
        label: l10n.tileFamily,
        badge: FeatureFlags.family ? null : soon,
        onTap: () => context.go('/family'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(nextBookingProvider.future),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(WWSpacing.screen),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${l10n.helloName(firstName)} 👋', style: WWType.screenTitle),
                        const SizedBox(height: 2),
                        Text(l10n.homeTagline, style: WWType.caption),
                      ],
                    ),
                  ),
                  const NotificationBell(),
                ],
              ),
              const SizedBox(height: WWSpacing.lg),
              WWHeroCard(title: l10n.heroTitle, subtitle: l10n.heroSubtitle),
              const SizedBox(height: WWSpacing.lg),
              const NextBookingCard(),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: WWSpacing.md,
                crossAxisSpacing: WWSpacing.md,
                childAspectRatio: 1.15,
                children: tiles,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
