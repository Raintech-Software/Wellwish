import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ww_core/ww_core.dart';

import '../../providers.dart';

/// Hospitals and doctors directory (P06-P09, ARCHITECTURE §6.7).

/// Specialities for the filter chips.
final specialitiesProvider = FutureProvider<List<SpecialityOut>>(
  (ref) async => (await ref.watch(publicApiProvider).publicSpecialities()).data!,
);

/// The phone's location for "nearby" (null when refused, off or unavailable: then every
/// hospital is listed by name). Asked once per app start; pull to refresh asks again.
final phonePositionProvider = FutureProvider<(double, double)?>(
  (ref) async => (await ref.watch(locationServiceProvider).current()).position,
);

typedef HospitalQuery = ({(double, double)? near, String q, String? specialityId});

final nearbyHospitalsProvider = FutureProvider.autoDispose.family<NearbyHospitalsOut, HospitalQuery>((
  ref,
  query,
) async {
  final near = query.near;
  return (await ref
          .watch(patientApiProvider)
          .patientHospitalsNearby(
            lat: near?.$1.toStringAsFixed(6),
            lng: near?.$2.toStringAsFixed(6),
            q: query.q,
            specialityId: query.specialityId,
          ))
      .data!;
});

final hospitalDetailProvider = FutureProvider.autoDispose.family<PatientHospitalDetailOut, String>(
  (ref, id) async => (await ref.watch(patientApiProvider).patientHospitalGet(hospitalId: id)).data!,
);

final doctorDetailProvider = FutureProvider.autoDispose.family<PatientDoctorOut, String>(
  (ref, id) async => (await ref.watch(patientApiProvider).patientDoctorGet(doctorId: id)).data!,
);

typedef DoctorQuery = ({String q, String? specialityId});

class DoctorsPage {
  const DoctorsPage({required this.items, required this.count, required this.page});

  final List<PatientDoctorOut> items;
  final int count;
  final int page;

  bool get hasMore => items.length < count;
}

/// P08: doctors by name, 20 at a time.
class DoctorsController extends AsyncNotifier<DoctorsPage> {
  DoctorsController(this.query);

  final DoctorQuery query;
  static const pageSize = 20;

  Future<DoctorsPage> _load(int page) async {
    final data =
        (await ref
                .read(patientApiProvider)
                .patientDoctorList(q: query.q, specialityId: query.specialityId, page: page, pageSize: pageSize))
            .data!;
    return DoctorsPage(items: data.items, count: data.count, page: page);
  }

  @override
  Future<DoctorsPage> build() => _load(1);

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) return;
    final next = await _load(current.page + 1);
    state = AsyncData(DoctorsPage(items: [...current.items, ...next.items], count: next.count, page: next.page));
  }
}

final doctorsProvider = AsyncNotifierProvider.autoDispose.family<DoctorsController, DoctorsPage, DoctorQuery>(
  DoctorsController.new,
);
