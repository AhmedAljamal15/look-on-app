import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/profile_photo_repository.dart';
import '../domain/profile_photo.dart';

final profilePhotoRepositoryProvider = Provider<ProfilePhotoRepository>((ref) {
  return ProfilePhotoRepository(
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Streams the user's active profile photo (or null if none yet). The UI
/// (Home screen, capture screen) watches this to decide whether to show
/// "take your photo first" or the normal try-on flow.
///
/// Deliberately NOT autoDispose: this value is read via `ref.read` from
/// [TryOnGenerationNotifier] on the generating screen, which may not have
/// an active `watch`er keeping it alive at that moment. Keeping it global
/// also avoids re-fetching every time the user navigates back to Home.
final activeProfilePhotoProvider = StreamProvider<ProfilePhoto?>((ref) {
  final uidAsync = ref.watch(authStateProvider);
  return uidAsync.when(
    data: (uid) {
      if (uid == null) return const Stream.empty();
      final repo = ref.watch(profilePhotoRepositoryProvider);
      return repo.watchActiveProfilePhoto(uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

/// Handles the "capture/save profile photo" action and its async lifecycle
/// (loading / error / success) so the capture screen stays declarative.
class ProfilePhotoCaptureNotifier
    extends AutoDisposeAsyncNotifier<ProfilePhoto?> {
  @override
  Future<ProfilePhoto?> build() async => null;

  Future<void> savePhoto(File file) async {
    state = const AsyncLoading();

    final uidAsync = ref.read(authStateProvider);
    final uid = uidAsync.value;
    if (uid == null) {
      state = AsyncError('no_session_error', StackTrace.current);
      return;
    }

    final repo = ref.read(profilePhotoRepositoryProvider);
    final result = await repo.saveProfilePhoto(uid: uid, file: file);

    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (photo) => AsyncData(photo),
    );
  }
}

final profilePhotoCaptureProvider = AutoDisposeAsyncNotifierProvider<
    ProfilePhotoCaptureNotifier, ProfilePhoto?>(
  ProfilePhotoCaptureNotifier.new,
);
