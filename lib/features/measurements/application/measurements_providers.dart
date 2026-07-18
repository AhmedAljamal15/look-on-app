import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/onboarding/data/onboarding_local_source.dart';
import '../data/measurements_repository.dart';
import '../domain/measurements.dart';

final measurementsRepositoryProvider =
    Provider<MeasurementsRepository>((ref) {
  return MeasurementsRepository(ref.watch(sharedPreferencesProvider));
});

class MeasurementsNotifier extends Notifier<Measurements?> {
  @override
  Measurements? build() {
    return ref.watch(measurementsRepositoryProvider).load();
  }

  Future<void> save(Measurements m) async {
    await ref.read(measurementsRepositoryProvider).save(m);
    state = m;
  }

  Future<void> clear() async {
    await ref.read(measurementsRepositoryProvider).clear();
    state = null;
  }
}

final measurementsProvider =
    NotifierProvider<MeasurementsNotifier, Measurements?>(
  MeasurementsNotifier.new,
);