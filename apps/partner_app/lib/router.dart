import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ww_auth/ww_auth.dart';

import 'features/auth/login_routes.dart';
import 'features/home/approved_shell.dart';
import 'features/home/selfie_screen.dart';
import 'features/home/totals_screen.dart';
import 'features/jobs/care_note_screen.dart';
import 'features/jobs/collect_balance_screen.dart';
import 'features/jobs/job_screen.dart';
import 'features/jobs/offer_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/registration/contact_screen.dart';
import 'features/registration/documents_screen.dart';
import 'features/registration/hub_screen.dart';
import 'features/registration/profile_form_screen.dart';
import 'features/registration/role_screen.dart';
import 'features/registration/status_screen.dart';
import 'features/session/consent_screen.dart';
import 'features/session/session_controller.dart';
import 'features/splash/splash_screen.dart';
import 'features/temporary/temporary_home.dart';
import 'features/update/force_update_screen.dart';

/// Which screens each partner status may open, and where it lands (§6.3 login rule: any
/// status can log in; only APPROVED sees the work screens; a TEMPORARY partner sees only their
/// one job, §6.19).
({String home, Set<String> allowed}) screensFor(String? partnerStatus) {
  switch (partnerStatus) {
    case null:
    case 'TEMP_ENDED': // §6.19: after a temporary job, the start like anyone not registered
    case 'DELETED': // §6.20: deleted, but the number is still a patient's: register again
      return (home: RoleScreen.path, allowed: {RoleScreen.path});
    case 'REGISTERING':
    case 'REGISTERED':
      return (
        home: HubScreen.path,
        allowed: {
          HubScreen.path,
          RoleScreen.path,
          ContactScreen.path,
          ProfileFormScreen.path,
          DocumentsScreen.path,
          NotificationsScreen.path,
        },
      );
    case 'CHANGES_REQUESTED':
      return (
        home: StatusScreen.path,
        allowed: {
          StatusScreen.path,
          DocumentsScreen.path,
          ContactScreen.path,
          ProfileFormScreen.path,
          NotificationsScreen.path,
        },
      );
    case 'APPROVED':
      return (
        home: ApprovedShell.path,
        allowed: {
          ApprovedShell.path,
          DocumentsScreen.path,
          ContactScreen.path,
          NotificationsScreen.path,
          SelfieScreen.path,
          OfferScreen.path,
          JobScreen.path,
          CareNoteScreen.path,
          CollectBalanceScreen.path,
          TotalsScreen.path,
        },
      );
    case 'TEMPORARY':
      return (
        home: TemporaryHome.path,
        allowed: {
          TemporaryHome.path,
          SelfieScreen.path,
          JobScreen.path,
          CareNoteScreen.path,
          CollectBalanceScreen.path,
          NotificationsScreen.path,
        },
      );
    case 'SUSPENDED':
      return (home: StatusScreen.path, allowed: {StatusScreen.path, DocumentsScreen.path, NotificationsScreen.path});
    default: // SUBMITTED, UNDER_REVIEW, REJECTED, DEACTIVATED
      return (home: StatusScreen.path, allowed: {StatusScreen.path, NotificationsScreen.path});
  }
}

String _screensKey(String? partnerStatus) {
  final screens = screensFor(partnerStatus);
  return '${screens.home}|${(screens.allowed.toList()..sort()).join(',')}';
}

/// "/offer/abc" → "/offer/:id" (screens with an id are allowed by their route pattern).
String _pattern(String location) {
  for (final p in const [OfferScreen.path, JobScreen.path, CareNoteScreen.path, CollectBalanceScreen.path]) {
    if (RegExp('^${p.replaceAll(':id', '[^/]+')}\$').hasMatch(location)) return p;
  }
  return location;
}

/// The screens of a visit in progress: the consent screen never replaces them (§6.20).
const _jobFlow = {JobScreen.path, CareNoteScreen.path, CollectBalanceScreen.path};

/// Splash → Login → OTP → registration / status / approved home. Null = stay.
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
      final me = session.me;
      // §6.20: the Partner Terms and Privacy Policy come first, at every status, but never in
      // the middle of a visit (the job screen and its SOS stay; asked once the job is left)
      if ((me?.consentsNeeded?.isNotEmpty ?? false) && !_jobFlow.contains(_pattern(location))) {
        return location == PartnerConsentScreen.path ? null : PartnerConsentScreen.path;
      }
      final screens = screensFor(me?.partnerStatus);
      if (!screens.allowed.contains(_pattern(location))) return screens.home;
      // §6.19: a temporary partner opens only their own booking
      if (isTemporary(me?.partnerStatus) && location.startsWith('/job/')) {
        final segments = Uri.parse(location).pathSegments;
        if (segments.length < 2 || segments[1] != me?.temporaryBookingId) return screens.home;
      }
      return null;
  }
}

/// All screens are registered here.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  // Re-route only when the screens a partner may open change: REGISTERING → REGISTERED keeps
  // the same screens, and a refresh would rebuild the page that is saving.
  ref.listen(
    sessionProvider.select(
      (s) => (s.status, _screensKey(s.me?.partnerStatus), s.me?.consentsNeeded?.isNotEmpty ?? false),
    ),
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
      GoRoute(path: PartnerConsentScreen.path, builder: (context, state) => const PartnerConsentScreen()),
      GoRoute(path: RoleScreen.path, builder: (context, state) => const RoleScreen()),
      GoRoute(path: HubScreen.path, builder: (context, state) => const HubScreen()),
      GoRoute(path: ContactScreen.path, builder: (context, state) => const ContactScreen()),
      GoRoute(path: ProfileFormScreen.path, builder: (context, state) => const ProfileFormScreen()),
      GoRoute(path: DocumentsScreen.path, builder: (context, state) => const DocumentsScreen()),
      GoRoute(path: StatusScreen.path, builder: (context, state) => const StatusScreen()),
      GoRoute(path: ApprovedShell.path, builder: (context, state) => const ApprovedShell()),
      GoRoute(path: NotificationsScreen.path, builder: (context, state) => const NotificationsScreen()),
      // Phase 7: daily selfie, offers and jobs.
      GoRoute(path: SelfieScreen.path, builder: (context, state) => const SelfieScreen()),
      GoRoute(
        path: OfferScreen.path,
        builder: (context, state) => OfferScreen(assignmentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: JobScreen.path,
        builder: (context, state) => JobScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: CareNoteScreen.path,
        builder: (context, state) => CareNoteScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: CollectBalanceScreen.path,
        builder: (context, state) => CollectBalanceScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(path: TotalsScreen.path, builder: (context, state) => const TotalsScreen()),
      // Phase 8B: a temporary partner's one job (§6.19).
      GoRoute(path: TemporaryHome.path, builder: (context, state) => const TemporaryHome()),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
