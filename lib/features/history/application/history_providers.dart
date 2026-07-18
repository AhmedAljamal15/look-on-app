import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../try_on/domain/try_on_result.dart';
import 'package:fpdart/fpdart.dart' as fp;
import '../data/history_repository.dart';

final historyRepositoryProvider =
    Provider<HistoryRepository>((ref) => HistoryRepository());

/// Streams the signed-in user's try-on history, newest first. Not
/// autoDispose — Home and History screens both read it and we don't want
/// to re-fetch every time the user bounces between them.
final historyProvider = StreamProvider<List<TryOnResult>>((ref) {
  final uidAsync = ref.watch(authStateProvider);
  return uidAsync.when(
    data: (uid) {
      if (uid == null) return const Stream.empty();
      final repo = ref.watch(historyRepositoryProvider);
      return repo.watchHistory(uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

/// المفضلة: بنفلتر من نفس الـ history stream الموجود أصلاً — بدون أي
/// query إضافي على Firestore، وبالتالي بدون الحاجة لعمل composite index.
final favoritesProvider = Provider<List<TryOnResult>>((ref) {
  final history = ref.watch(historyProvider).value ?? [];
  return history.where((item) => item.isFavorite).toList();
});

class HistoryActionsNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> deleteItem(String resultId) async {
    final uid = ref.read(authStateProvider).value;
    if (uid == null) return;

    state = const AsyncLoading();
    final repo = ref.read(historyRepositoryProvider);
    final result = await repo.deleteHistoryItem(uid: uid, resultId: resultId);
    state = result.match(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (_) => const AsyncData(fp.unit),
    );
  }

  Future<void> toggleFavorite(String resultId, bool currentValue) async {
    final uid = ref.read(authStateProvider).value;
    if (uid == null) return;

    final repo = ref.read(historyRepositoryProvider);
    // ما بنحطش loading state هنا عشان الـ UI يستجيب فوراً (optimistic feel)
    await repo.toggleFavorite(
      uid: uid,
      resultId: resultId,
      isFavorite: !currentValue,
    );
  }
}

final historyActionsProvider =
    AutoDisposeAsyncNotifierProvider<HistoryActionsNotifier, void>(
  HistoryActionsNotifier.new,
);