import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_local_source.dart';

const _kWelcomeAcceptedKey = 'welcome_terms_accepted';

/// Tracks whether the user has accepted the welcome message + terms once.
/// Separate from onboardingCompleteProvider (the carousel) — this is the
/// one-time legal/terms acknowledgment shown as an overlay on Home.
class WelcomeLocalSource {
  final SharedPreferences _prefs;
  WelcomeLocalSource(this._prefs);

  bool get hasAccepted => _prefs.getBool(_kWelcomeAcceptedKey) ?? false;

  Future<void> markAccepted() async {
    await _prefs.setBool(_kWelcomeAcceptedKey, true);
  }
}

final welcomeLocalSourceProvider = Provider<WelcomeLocalSource>((ref) {
  return WelcomeLocalSource(ref.watch(sharedPreferencesProvider));
});

final welcomeAcceptedProvider = StateProvider<bool>((ref) {
  return ref.watch(welcomeLocalSourceProvider).hasAccepted;
});