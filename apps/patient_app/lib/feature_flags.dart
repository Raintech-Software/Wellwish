/// Unfinished parts of the app stay hidden or marked "Coming soon" until their phase
/// (PHASES.md: every phase must leave the apps runnable, no half-broken screens).
abstract final class FeatureFlags {
  /// Doctor directory (Phase 5).
  static const doctors = true;

  /// Book a companion / nurse (Phase 5; payment in Phase 6).
  static const booking = true;

  /// Medical documents (Phase 4).
  static const documents = true;

  /// Family members (Phase 4).
  static const family = true;
}
