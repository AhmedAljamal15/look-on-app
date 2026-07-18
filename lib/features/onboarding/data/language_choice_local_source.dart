import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_local_source.dart';

const _kLanguageChosenKey = 'language_chosen';

/// Tracks whether the user has gone through the one-time language-picker
/// screen shown right after onboarding, before landing on Home.
class LanguageChoiceLocalSource {
  final SharedPreferences _prefs;
  LanguageChoiceLocalSource(this._prefs);

  bool get hasChosen => _prefs.getBool(_kLanguageChosenKey) ?? false;

  Future<void> markChosen() async {
    await _prefs.setBool(_kLanguageChosenKey, true);
  }
}

final languageChoiceLocalSourceProvider =
    Provider<LanguageChoiceLocalSource>((ref) {
  return LanguageChoiceLocalSource(ref.watch(sharedPreferencesProvider));
});

final languageChosenProvider = StateProvider<bool>((ref) {
  return ref.watch(languageChoiceLocalSourceProvider).hasChosen;
});
