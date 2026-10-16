import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';
import 'package:ww_core/ww_core.dart';

import 'features/addresses/address_form_screen.dart';
import 'features/booking/address_step_screen.dart';
import 'features/booking/booking_flow.dart';
import 'features/booking/booking_screen.dart';
import 'features/booking/documents_step_screen.dart';
import 'features/booking/hospital_picker_screen.dart';
import 'features/booking/my_bookings_screen.dart';
import 'features/booking/reschedule_screen.dart';
import 'features/booking/review_screen.dart';
import 'features/booking/services_screen.dart';
import 'features/booking/visit_details_screen.dart';
import 'features/directory/doctor_screen.dart';
import 'features/directory/doctors_screen.dart';
import 'features/directory/hospital_screen.dart';
import 'features/auth/login_routes.dart';
import 'features/documents/documents_screen.dart';
import 'features/family/family_screen.dart';
import 'features/family/member_form_screen.dart';
import 'features/family/member_profile_screen.dart';
import 'features/home/home_screen.dart';
import 'features/home/home_shell.dart';
import 'features/payments/pay_flow.dart';
import 'features/payments/payment_result_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/session/session_controller.dart';
import 'features/settings/settings_screen.dart';
import 'features/setup/consent_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/setup/location_screen.dart';
import 'features/setup/profile_setup_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/update/force_update_screen.dart';
import 'features/visit/live_tracking_screen.dart';

/// Where the session state says the user must be (W-P1: Splash → Login → OTP → profile setup →
/// consent → location permission → Home). Null = stay.
String? redirectFor(SessionState session, String location) {
  const signedOutRoutes = {LoginRoute.path, OtpRoute.path};
  switch (session.status) {
    case SessionStatus.starting:
    case SessionStatus.startupFailed:
      return location == SplashScreen.path ? null : SplashScreen.path;
    case SessionStatus.updateRequired:
      return ForceUpdateScreen.path;
    case SessionStatus.loggedOut:
      return signedOutRoutes.contains(location) ? null : LoginRoute.path;
    case SessionStatus.loggedIn:
      final String? required = session.needsProfile
          ? ProfileSetupScreen.path
          : session.needsConsent
          ? ConsentScreen.path
          : session.askLocation
          ? LocationScreen.path
          : null;
      if (required != null) return location == required ? null : required;
      const notWhenSignedIn = {
        SplashScreen.path,
        ForceUpdateScreen.path,
        ...signedOutRoutes,
        ProfileSetupScreen.path,
        ConsentScreen.path,
        LocationScreen.path,
      };
      return notWhenSignedIn.contains(location) ? HomeScreen.path : null;
  }
}

String? _needsService(Ref ref) => ref.read(bookingDraftProvider).service == null ? HomeScreen.path : null;

/// Review needs every step done; otherwise back to the first missing one.
String? _reviewRedirect(Ref ref) {
  final d = ref.read(bookingDraftProvider);
  if (d.service == null) return HomeScreen.path;
  if (d.memberId == null || d.pickupAt == null) return VisitDetailsScreen.path;
  if (d.address == null) return AddressStepScreen.path;
  return null;
}

/// All screens are registered here.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  // Re-route only when what decides the screen changes: a new profile name or language must
  // not rebuild the open page (an edit form would lose what it was given).
  ref.listen(
    sessionProvider.select((s) => (s.status, s.needsProfile, s.needsConsent, s.askLocation, s.me?.id)),
    (_, _) => refresh.value++,
  );
  final router = GoRouter(
    initialLocation: SplashScreen.path,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(ref.read(sessionProvider), state.matchedLocation),
    routes: [
      GoRoute(path: SplashScreen.path, builder: (context, state) => const SplashScreen()),
      GoRoute(path: ForceUpdateScreen.path, builder: (context, state) => const ForceUpdateScreen()),
      GoRoute(path: LoginRoute.path, builder: (context, state) => const LoginRoute()),
      GoRoute(
        path: OtpRoute.path,
        redirect: (context, state) => state.extra is OtpArgs ? null : LoginRoute.path,
        builder: (context, state) => OtpRoute(args: state.extra! as OtpArgs),
      ),
      GoRoute(path: ProfileSetupScreen.path, builder: (context, state) => const ProfileSetupScreen()),
      GoRoute(path: ConsentScreen.path, builder: (context, state) => const ConsentScreen()),
      GoRoute(path: LocationScreen.path, builder: (context, state) => const LocationScreen()),
      // Full-screen pages above the tabs (Phase 4: family, addresses, settings).
      GoRoute(path: MemberFormScreen.addPath, builder: (context, state) => const MemberFormScreen()),
      GoRoute(path: NotificationsScreen.path, builder: (context, state) => const NotificationsScreen()),
      GoRoute(
        path: MemberProfileScreen.path,
        builder: (context, state) => MemberProfileScreen(memberId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/member/:id/edit',
        redirect: (context, state) =>
            state.extra is MemberOut ? null : MemberProfileScreen.pathFor(state.pathParameters['id']!),
        builder: (context, state) => MemberFormScreen(member: state.extra! as MemberOut),
      ),
      GoRoute(
        path: '/member/:id/address/new',
        redirect: (context, state) =>
            state.extra is MemberOut ? null : MemberProfileScreen.pathFor(state.pathParameters['id']!),
        builder: (context, state) => AddressFormScreen(member: state.extra! as MemberOut),
      ),
      GoRoute(
        path: '/address/:id/edit',
        redirect: (context, state) => state.extra is AddressEditArgs ? null : FamilyScreen.path,
        builder: (context, state) {
          final args = state.extra! as AddressEditArgs;
          return AddressFormScreen(member: args.member, address: args.address);
        },
      ),
      GoRoute(
        path: '/member/:id/documents',
        builder: (context, state) => DocumentsScreen(memberId: state.pathParameters['id']),
      ),
      GoRoute(path: SettingsScreen.path, builder: (context, state) => const SettingsScreen()),
      // Phase 5: directory and booking.
      GoRoute(
        path: HospitalScreen.path,
        builder: (context, state) => HospitalScreen(hospitalId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: DoctorScreen.path,
        builder: (context, state) => DoctorScreen(doctorId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: ServicesScreen.path,
        redirect: (context, state) =>
            const {'COMPANION', 'NURSE'}.contains(state.pathParameters['type']) ? null : HomeScreen.path,
        builder: (context, state) => ServicesScreen(partnerType: state.pathParameters['type']!),
      ),
      // The steps need a chosen service (an app restarted mid-booking goes back Home).
      GoRoute(
        path: VisitDetailsScreen.path,
        redirect: (context, state) => _needsService(ref),
        builder: (context, state) => const VisitDetailsScreen(),
      ),
      GoRoute(
        path: HospitalPickerScreen.path,
        redirect: (context, state) => _needsService(ref),
        builder: (context, state) => const HospitalPickerScreen(),
      ),
      GoRoute(
        path: AddressStepScreen.path,
        redirect: (context, state) => _needsService(ref),
        builder: (context, state) => const AddressStepScreen(),
      ),
      GoRoute(
        path: DocumentsStepScreen.path,
        redirect: (context, state) => _needsService(ref),
        builder: (context, state) => const DocumentsStepScreen(),
      ),
      GoRoute(
        path: ReviewScreen.path,
        redirect: (context, state) => _reviewRedirect(ref),
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: BookingScreen.path,
        builder: (context, state) => BookingScreen(bookingId: state.pathParameters['id']!),
      ),
      // Phase 6: paying, my bookings, changing the time.
      GoRoute(
        path: PaymentResultScreen.path,
        redirect: (context, state) =>
            state.extra is PayResult ? null : BookingScreen.pathFor(state.pathParameters['id']!),
        builder: (context, state) =>
            PaymentResultScreen(bookingId: state.pathParameters['id']!, result: state.extra! as PayResult),
      ),
      // Phase 8: the visit.
      GoRoute(
        path: LiveTrackingScreen.path,
        builder: (context, state) => LiveTrackingScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RescheduleScreen.path,
        builder: (context, state) => RescheduleScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(path: MyBookingsScreen.path, builder: (context, state) => const MyBookingsScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: HomeScreen.path, builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: DoctorsTab.path, builder: (context, state) => const DoctorsTab())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: DocumentsScreen.path,
                builder: (context, state) => DocumentsTab(state: state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: FamilyScreen.path, builder: (context, state) => const FamilyScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: ProfileScreen.path, builder: (context, state) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
