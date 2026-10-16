import 'dart:async';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';
import 'package:ww_l10n/ww_l10n.dart';

import '../../providers.dart';
import 'jobs_providers.dart';
import 'visit_outbox.dart';

/// What a step tap did.
enum StepOutcome { sent, queued }

/// Jobs that are over: no location is shared for them.
const _ended = {'COMPLETED', 'PATIENT_NO_SHOW', 'CANCELLED', 'EXPIRED'};

class VisitState {
  const VisitState({
    this.pending = const {},
    this.sharingBookingId,
    this.locationProblem = false,
    this.stepsRefused = false,
  });

  /// Steps tapped offline, waiting to be sent (booking id → steps in order).
  final Map<String, List<String>> pending;

  /// The job whose location is being shared (from "On the way" until "Completed").
  final String? sharingBookingId;

  /// The location couldn't be read (permission denied or GPS off).
  final bool locationProblem;

  /// A step kept offline was refused by the server when sent (e.g. WellWish marked it
  /// meanwhile): the partner is told to check the steps.
  final bool stepsRefused;

  VisitState copyWith({
    Map<String, List<String>>? pending,
    String? sharingBookingId,
    bool clearSharing = false,
    bool? locationProblem,
    bool? stepsRefused,
  }) => VisitState(
    pending: pending ?? this.pending,
    sharingBookingId: clearSharing ? null : (sharingBookingId ?? this.sharingBookingId),
    locationProblem: locationProblem ?? this.locationProblem,
    stepsRefused: stepsRefused ?? this.stepsRefused,
  );
}

/// The visit on the partner's phone (ARCHITECTURE §6.11, R12):
/// - each step tap is sent with the phone's location; with no network it's kept and sent when
///   the phone is back online, in order (not the OTP step or a care note with vitals: they need
///   the server). A tap while earlier steps still wait goes behind them;
/// - from "On the way" until the job is over the location is shared every 10 s (a foreground
///   service with its notification), over the live socket, or kept for a batch when offline.
///   Sharing stops when the job ends (also when WellWish ended it), at logout, and never
///   switches to another job by itself.
class VisitController extends Notifier<VisitState> {
  StreamSubscription<TrackPoint>? _points;

  /// The latest point shared for a job, while sharing it (not fake, accurate enough).
  ({String bookingId, TrackPoint point})? _last;
  bool _flushing = false;
  Timer? _retry;

  /// The logged-in partner: the outbox is theirs ([signedIn], [sessionEnded]).
  String? _partnerId;

  /// The notification texts for the location service: every screen that can start sharing
  /// sets them in the partner's language (Home, the job screen and its panel).
  String notificationTitle = _english.fgsTitle;
  String notificationText = _english.fgsText;
  static final _english = lookupWWLocalizations(const Locale('en'));

  static const retryEvery = Duration(seconds: 30);

  /// Points less accurate than this aren't reused for a step (the server drops them too).
  static const maxReusedAccuracy = 50.0;

  @override
  VisitState build() {
    ref.onDispose(() {
      _points?.cancel();
      _retry?.cancel();
    });
    return const VisitState();
  }

  PartnerApi get _api => ref.read(partnerApiProvider);
  VisitOutbox _outbox(String partnerId) => ref.read(visitOutboxProvider(partnerId));

  /// A partner logged in (or the app started logged in): their own kept steps are shown and
  /// sent again. Another partner's never are.
  void signedIn(String partnerId) {
    if (_partnerId == partnerId) return;
    if (_partnerId != null) unawaited(sessionEnded());
    _partnerId = partnerId;
    unawaited(_restore(partnerId));
  }

  /// Logged out or the session ended: sharing stops and nothing is sent or retried any more.
  /// What's kept stays on the phone for this partner's next login.
  Future<void> sessionEnded() async {
    _retry?.cancel();
    _retry = null;
    _partnerId = null;
    state = const VisitState();
    await stopSharing(flush: false);
  }

  /// After the app was closed: the steps still waiting are shown (and sent) again.
  Future<void> _restore(String partnerId) async {
    final steps = await _outbox(partnerId).steps();
    if (!ref.mounted || _partnerId != partnerId || steps.isEmpty) return;
    final pending = <String, List<String>>{};
    for (final s in steps) {
      (pending[s['bookingId'] as String] ??= []).add(s['step'] as String);
    }
    state = state.copyWith(pending: pending);
    _scheduleRetry();
  }

  /// Where the partner is, for an SOS: the point just shared for this job, or a fresh fix (a
  /// short wait: an SOS mustn't hang). Deep check 9.3.
  Future<({double lat, double lng, double? accuracy, bool mock})?> sosPlace(String bookingId) =>
      _place(bookingId, wait: const Duration(seconds: 8));

  Future<({double lat, double lng, double? accuracy, bool mock})?> _place(
    String bookingId, {
    Duration wait = const Duration(seconds: 15),
  }) async {
    final last = _last;
    // While sharing this job, its latest shared point is the place (a fresh fix takes 10-15 s
    // indoors and a second location request alongside the live one isn't wanted) if it's less
    // than 5 minutes old; otherwise a fresh one.
    if (last != null &&
        last.bookingId == bookingId &&
        DateTime.now().toUtc().difference(last.point.at) < const Duration(minutes: 5)) {
      return (lat: last.point.lat, lng: last.point.lng, accuracy: last.point.accuracy, mock: last.point.mock);
    }
    final result = await ref
        .read(stepLocationProvider)
        .current()
        .timeout(wait, onTimeout: () => (position: null, problem: LocationProblem.unavailable, mock: false));
    final position = result.position;
    if (position == null) return null;
    return (lat: position.$1, lng: position.$2, accuracy: null, mock: result.mock);
  }

  bool _waiting(String bookingId) => state.pending[bookingId]?.isNotEmpty ?? false;

  /// R12: the next step. Throws the server's refusal (wrong OTP, out of order...) as is.
  Future<StepOutcome> doStep(
    PartnerJobOut job,
    String step, {
    String otp = '',
    String note = '',
    VitalsIn? vitals,
  }) async {
    final needsServer = job.visit?.otpStep == step || vitals != null;
    // steps kept offline go first: the server takes them only in order
    if (_waiting(job.id)) await online();
    if (!ref.mounted) return StepOutcome.queued;
    final behind = _waiting(job.id);
    if (behind && needsServer) {
      throw const ApiException(code: ApiException.networkError, message: '');
    }
    final place = await _place(job.id);
    final body = <String, dynamic>{
      'bookingId': job.id,
      'step': step,
      if (place != null) 'lat': place.lat.toStringAsFixed(6),
      if (place != null) 'lng': place.lng.toStringAsFixed(6),
      if (place?.accuracy != null) 'accuracy': place!.accuracy,
      if (place?.mock ?? false) 'mock': true,
      'clientTs': DateTime.now().toUtc().toIso8601String(),
      if (note.isNotEmpty) 'note': note,
    };
    if (behind) return _queue(job.id, step, body);
    try {
      await _send(body, otp: otp, vitals: vitals);
    } catch (e) {
      final error = toApiException(e);
      // a wrong visit code may start a wait: the job reloads, so the panel shows it
      if ((error.code == 'WRONG_OTP' || error.code == 'OTP_WAIT') && ref.mounted) {
        ref.invalidate(jobProvider(job.id));
      }
      if (!error.isConnectivity || needsServer) rethrow;
      return _queue(job.id, step, body);
    }
    if (!ref.mounted) return StepOutcome.sent;
    state = state.copyWith(stepsRefused: false);
    _afterStep(job.id, step);
    jobsChanged(ref.invalidate);
    return StepOutcome.sent;
  }

  Future<StepOutcome> _queue(String bookingId, String step, Map<String, dynamic> body) async {
    final partnerId = _partnerId;
    if (partnerId == null) throw const ApiException(code: ApiException.networkError, message: '');
    await _outbox(partnerId).addStep(body);
    if (!ref.mounted || _partnerId != partnerId) return StepOutcome.queued;
    final pending = {...state.pending};
    pending[bookingId] = [...?pending[bookingId], step];
    state = state.copyWith(pending: pending, stepsRefused: false);
    _afterStep(bookingId, step);
    _scheduleRetry();
    return StepOutcome.queued;
  }

  Future<void> _send(Map<String, dynamic> body, {String otp = '', VitalsIn? vitals, PartnerApi? api}) =>
      (api ?? _api).partnerJobStep(
        bookingId: body['bookingId'] as String,
        stepIn: StepIn(
          step: StepInStepEnum.values.firstWhere((e) => e.value == body['step']),
          lat: body['lat'] as String?,
          lng: body['lng'] as String?,
          accuracy: body['accuracy'] as num?,
          clientTs: DateTime.parse(body['clientTs'] as String),
          mock: body['mock'] == true,
          otp: otp,
          note: (body['note'] as String?) ?? '',
          vitals: vitals,
        ),
      );

  void _afterStep(String bookingId, String step) {
    if (step == 'ON_THE_WAY') startSharing(bookingId);
    if (step == 'COMPLETED') unawaited(stopSharing());
  }

  /// "Patient not available", call attempts: online only (they need the server).
  Future<void> logCall(String bookingId, CallInToEnum to) async {
    try {
      await _api.partnerJobCall(
        bookingId: bookingId,
        callIn: CallIn(to: to),
      );
    } catch (_) {
      // the call still happens; the server just won't see this attempt
    }
  }

  Future<void> patientNotAvailable(String bookingId) async {
    final place = await _place(bookingId);
    await _api.partnerJobNoShow(
      bookingId: bookingId,
      placeIn: PlaceIn(
        lat: place?.lat.toStringAsFixed(6),
        lng: place?.lng.toStringAsFixed(6),
        clientTs: DateTime.now().toUtc(),
        mock: place?.mock ?? false,
      ),
    );
    await stopSharing();
    if (ref.mounted) jobsChanged(ref.invalidate);
  }

  // --- Live location ---

  /// From "On the way": share the location every 10 s (no-op if already sharing this job;
  /// after a location error it starts again).
  void startSharing(String bookingId) {
    if (_partnerId == null) return; // logged out meanwhile: never restart the location service
    if (state.sharingBookingId == bookingId && _points != null) return;
    unawaited(_points?.cancel());
    _last = null;
    state = state.copyWith(sharingBookingId: bookingId, locationProblem: false);
    _points = ref
        .read(locationTrackerProvider)
        .start(notificationTitle: notificationTitle, notificationText: notificationText)
        .listen(
          (p) => unawaited(_onPoint(bookingId, p)),
          onError: (_) {
            // permission or GPS off: "Try again" (or the next screen visit) starts it again
            unawaited(_points?.cancel());
            _points = null;
            if (ref.mounted) state = state.copyWith(locationProblem: true);
          },
        );
  }

  /// Stops sharing. [flush]: send what was kept offline (not after logout).
  Future<void> stopSharing({bool flush = true}) async {
    final tracker = ref.read(locationTrackerProvider);
    final points = _points;
    _points = null;
    _last = null;
    state = state.copyWith(clearSharing: true, locationProblem: false);
    unawaited(points?.cancel());
    await tracker.stop(); // the service and its notification go
    if (flush && ref.mounted) unawaited(online()); // send what's left
  }

  Future<void> _onPoint(String bookingId, TrackPoint p) async {
    final partnerId = _partnerId;
    if (!ref.mounted || partnerId == null) return;
    if (!p.mock && p.accuracy <= maxReusedAccuracy) _last = (bookingId: bookingId, point: p);
    if (state.locationProblem) state = state.copyWith(locationProblem: false);
    final live =
        ref.read(socketReadyProvider) &&
        ref.read(partnerSocketProvider).send('location.update', {'bookingId': bookingId, ...p.toJson()});
    if (!live) await _outbox(partnerId).addPoint(bookingId, p);
  }

  bool _endQueued(String bookingId) => state.pending[bookingId]?.contains('COMPLETED') ?? false;

  /// Today's jobs reloaded (Home): stop sharing a job that is over; after the app was closed
  /// mid-job, share again. Never switches from one job to another by itself.
  void resumeIfNeeded(Iterable<PartnerJobRowOut> jobs) {
    final sharing = state.sharingBookingId;
    if (sharing != null) {
      for (final job in jobs) {
        if (job.id == sharing && _ended.contains(job.status)) unawaited(stopSharing());
      }
      return;
    }
    for (final job in jobs) {
      if (job.status == 'IN_PROGRESS' && !_endQueued(job.id)) {
        startSharing(job.id);
        return;
      }
    }
  }

  /// A job screen loaded the job: same rules as [resumeIfNeeded] for this one job. `null`: the
  /// job is no longer this partner's (unassigned or cancelled).
  void jobLoaded(String bookingId, PartnerJobOut? job) {
    final sharing = state.sharingBookingId;
    if (sharing == bookingId) {
      if (job == null || _ended.contains(job.status)) unawaited(stopSharing());
      return;
    }
    if (sharing == null && job?.status == 'IN_PROGRESS' && !_endQueued(bookingId)) startSharing(bookingId);
  }

  /// The server refused a live point because the job isn't in progress any more.
  void pointRefused(String bookingId, String reason) {
    if (reason == 'NOT_IN_PROGRESS' && state.sharingBookingId == bookingId && !_waiting(bookingId)) {
      unawaited(stopSharing());
      jobsChanged(ref.invalidate);
    }
  }

  // --- Back online ---

  void _scheduleRetry() {
    if (!ref.mounted || _partnerId == null || state.pending.isEmpty || (_retry?.isActive ?? false)) return;
    _retry = Timer(retryEvery, () {
      _retry = null;
      unawaited(online());
    });
  }

  /// Network trouble, a server hiccup or an expired login: keep it and try again later. A
  /// refusal (the server said no): drop it.
  bool _later(Object e) {
    final error = toApiException(e);
    final status = error.statusCode;
    return error.isConnectivity || status == null || status >= 500 || const {401, 408, 429}.contains(status);
  }

  /// Sends the points and steps kept offline (the socket said hello again, the app came back
  /// to the front, or every 30 s while some wait). Points go first (they come before the step
  /// that ends the job), then the steps in order; a step the server refuses is dropped and the
  /// partner is told. Only the logged-in partner's, and it stops if they log out meanwhile.
  Future<void> online() async {
    final partnerId = _partnerId;
    if (_flushing || !ref.mounted || partnerId == null) return;
    _flushing = true;
    final outbox = _outbox(partnerId);
    final api = _api;
    bool ended() => !ref.mounted || _partnerId != partnerId;
    try {
      for (final entry in (await outbox.points()).entries) {
        if (ended()) return;
        try {
          await api.partnerTrackBatch(
            bookingId: entry.key,
            trackBatchIn: TrackBatchIn(
              points: [
                for (final p in entry.value)
                  TrackPointIn(
                    lat: p.lat.toStringAsFixed(6),
                    lng: p.lng.toStringAsFixed(6),
                    accuracy: p.accuracy,
                    mock: p.mock,
                    at: p.at,
                  ),
              ],
            ),
          );
        } catch (e) {
          if (_later(e)) return;
        }
        await outbox.removePoints(entry.key, entry.value); // not the ones kept meanwhile
      }
      var changed = false;
      var refused = false;
      for (final step in await outbox.steps()) {
        if (ended()) return;
        try {
          await _send(step, api: api);
        } catch (e) {
          if (_later(e)) return;
          refused = true;
          // §6.19: "On the way" kept offline without today's selfie wasn't taken: the visit
          // hasn't started, so nothing is shared (the selfie is asked again on the job screen)
          if (toApiException(e).code == 'SELFIE_REQUIRED' && state.sharingBookingId == step['bookingId']) {
            await stopSharing();
          }
        }
        await outbox.removeStep(step);
        if (ended()) return;
        final pending = {...state.pending};
        final list = [...?pending[step['bookingId']]]..remove(step['step']);
        list.isEmpty ? pending.remove(step['bookingId']) : pending[step['bookingId'] as String] = list;
        state = state.copyWith(pending: pending, stepsRefused: refused || state.stepsRefused);
        changed = true;
      }
      if (changed && ref.mounted) jobsChanged(ref.invalidate);
    } finally {
      _flushing = false;
      _scheduleRetry();
    }
  }
}

final visitControllerProvider = NotifierProvider<VisitController, VisitState>(VisitController.new);
