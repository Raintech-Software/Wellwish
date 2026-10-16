import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';
import '../registration/device_tools.dart' show uploadHttpProvider;

/// The partner's offers and jobs (ARCHITECTURE §6.10, §8.1 R08-R11). Live messages from the
/// server (`offer.new`, `offer.withdrawn`, `booking.updated`) call [jobsChanged].

/// R08 Home: availability, open offers, today's jobs, quick totals.
final partnerHomeProvider = FutureProvider.autoDispose<PartnerHomeOut>(
  (ref) async => (await ref.watch(partnerApiProvider).partnerHome()).data!,
);

/// R09 one offer.
final offerProvider = FutureProvider.autoDispose.family<OfferSummaryOut, String>(
  (ref, id) async => (await ref.watch(partnerApiProvider).partnerOfferGet(assignmentId: id)).data!,
);

/// R10 New: the open offers.
final openOffersProvider = FutureProvider.autoDispose<List<OfferSummaryOut>>(
  (ref) async => (await ref.watch(partnerApiProvider).partnerOffersList()).data!,
);

/// R10 Upcoming / Completed (first 50).
final jobsProvider = FutureProvider.autoDispose.family<List<PartnerJobRowOut>, String>(
  (ref, bucket) async =>
      (await ref.watch(partnerApiProvider).partnerJobsList(bucket: bucket, pageSize: 50)).data!.items,
);

/// R11 one job (only after accepting).
final jobProvider = FutureProvider.autoDispose.family<PartnerJobOut, String>(
  (ref, id) async => (await ref.watch(partnerApiProvider).partnerJobGet(bookingId: id)).data!,
);

/// Something changed on the server (an offer arrived or was withdrawn, a job changed). Pass
/// `ref.invalidate` (a widget's or a provider's).
void jobsChanged(void Function(ProviderOrFamily provider) invalidate) {
  invalidate(partnerHomeProvider);
  invalidate(openOffersProvider);
  invalidate(jobsProvider);
  invalidate(offerProvider);
  invalidate(jobProvider);
}

/// Job documents open from the app's private cache (never Downloads).
final documentOpenerProvider = Provider<DocumentOpener>((ref) => DevicePdfOpener(ref.watch(uploadHttpProvider)));
