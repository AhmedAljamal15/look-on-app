import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/onboarding/data/onboarding_local_source.dart';
import '../../features/onboarding/data/language_choice_local_source.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/language_select_screen.dart';
import '../../features/profile_photo/presentation/screens/capture_profile_screen.dart';
import '../../features/result/presentation/screens/result_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/try_on/domain/try_on_result.dart';
import '../../features/try_on/presentation/screens/capture_garment_screen.dart';
import '../../features/try_on/presentation/screens/generating_screen.dart';
import '../../features/measurements/presentation/screens/measurements_screen.dart';
import '../../features/user_profile/presentation/screens/user_profile_screen.dart';
import '../providers/core_providers.dart';
import '../widgets/splash_screen.dart';
import 'app_routes.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(onboardingCompleteProvider, (_, __) => notifyListeners());
    ref.listen(languageChosenProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final onboardingComplete = ref.read(onboardingCompleteProvider);
      final languageChosen = ref.read(languageChosenProvider);

      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isOnboarding = state.matchedLocation == AppRoutes.onboarding;
      final isLanguageSelect =
          state.matchedLocation == AppRoutes.languageSelect;

      // Splash controls its own navigation after the video ends.
      if (isSplash) return null;

      // Still resolving anonymous sign-in -> stay on splash.
      if (authState.isLoading) {
        return AppRoutes.splash;
      }

      final signedIn = authState.value != null;
      if (!signedIn) {
        return AppRoutes.splash;
      }

      if (!onboardingComplete && !isOnboarding) {
        return AppRoutes.onboarding;
      }

      // Once onboarding is done, make the user pick a language once,
      // before they ever see Home.
      if (onboardingComplete && !languageChosen && !isLanguageSelect) {
        return AppRoutes.languageSelect;
      }

      if (onboardingComplete && languageChosen && isOnboarding) {
        return AppRoutes.home;
      }

      if (languageChosen && isLanguageSelect) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.languageSelect,
        builder: (context, state) => const LanguageSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.captureProfile,
        builder: (context, state) => const CaptureProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.captureGarment,
        builder: (context, state) => const CaptureGarmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.generating,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final file = extra['file'] as File;
          final category = extra['category'] as String? ?? 'tops';
          return GeneratingScreen(
            garmentImageFile: file,
            garmentCategory: category,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final result = state.extra as TryOnResult;
          return ResultScreen(result: result);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.measurements,
        builder: (context, state) => const MeasurementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const UserProfileScreen(),
      ),
    ],
  );
});
