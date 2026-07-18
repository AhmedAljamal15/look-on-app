import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

/// Tracks whether the user has seen the onboarding carousel. Stored locally
/// (not in Firestore) since it's a device-level UX flag, not user data.
class OnboardingLocalSource {
  final SharedPreferences _prefs;
  OnboardingLocalSource(this._prefs);

  bool get isComplete =>
      _prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;

  Future<void> markComplete() async {
    await _prefs.setBool(AppConstants.onboardingCompleteKey, true);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() after awaiting '
    'SharedPreferences.getInstance()',
  );
});

final onboardingLocalSourceProvider = Provider<OnboardingLocalSource>((ref) {
  return OnboardingLocalSource(ref.watch(sharedPreferencesProvider));
});

final onboardingCompleteProvider = StateProvider<bool>((ref) {
  return ref.watch(onboardingLocalSourceProvider).isComplete;
});
