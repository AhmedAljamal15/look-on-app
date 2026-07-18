import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../profile_photo/application/profile_photo_providers.dart';
import '../data/try_on_repository.dart';
import '../domain/try_on_result.dart';
import '../../preferences/data/preferences_local_source.dart';
import '../data/daily_limit_repository.dart';

final tryOnRepositoryProvider = Provider<TryOnRepository>((ref) {
  return TryOnRepository(
    storageService: ref.watch(storageServiceProvider),
    aiService: ref.watch(tryOnAiServiceProvider),
  );
});

/// Drives the "generating" screen: kicks off upload + AI call as soon as
/// a garment photo is captured, and exposes loading/error/data so the UI
/// can show a progress animation, an error state with retry, or navigate
/// to the result screen on success.
class TryOnGenerationNotifier extends AutoDisposeAsyncNotifier<TryOnResult?> {
  @override
  Future<TryOnResult?> build() async => null;

  Future<void> generate(File garmentImageFile, {String category = 'tops'}) async {
  final dailyRepo = ref.read(dailyLimitRepositoryProvider);
  if (!dailyRepo.hasRemainingAttempts) {
    state = AsyncError('daily_limit_reached', StackTrace.current);
    return;
  }

  state = const AsyncLoading();

  final uid = ref.read(authStateProvider).value;
  final activeProfilePhoto = ref.read(activeProfilePhotoProvider).value;
  final gender = ref.read(userGenderProvider);

  if (uid == null) {
    state = AsyncError('no_session_error', StackTrace.current);
    return;
  }
  if (activeProfilePhoto == null) {
    state = AsyncError('need_profile_photo_first', StackTrace.current);
    return;
  }

  final repo = ref.read(tryOnRepositoryProvider);
  final result = await repo.generateTryOn(
    uid: uid,
    personImageUrl: activeProfilePhoto.imageUrl,
    garmentImageFile: garmentImageFile,
    category: category,
    gender: gender,
  );

  state = result.match(
    (failure) => AsyncError(failure.message, StackTrace.current),
    (tryOnResult) {
      dailyRepo.recordAttempt();
      ref.read(dailyRemainingProvider.notifier).state = dailyRepo.remainingToday;
      return AsyncData(tryOnResult);
    },
  );
}

  void reset() => state = const AsyncData(null);
}

final tryOnGenerationProvider =
    AutoDisposeAsyncNotifierProvider<TryOnGenerationNotifier, TryOnResult?>(
  TryOnGenerationNotifier.new,
);
