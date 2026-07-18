import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/onboarding/data/onboarding_local_source.dart';

const _kGenderKey = 'user_gender';
const _kDefaultCategoryKey = 'user_default_category';
const _kPreferencesSetKey = 'initial_preferences_done';

class PreferencesLocalSource {
  final SharedPreferences _prefs;
  PreferencesLocalSource(this._prefs);

  bool get isDone => _prefs.getBool(_kPreferencesSetKey) ?? false;
  String get gender => _prefs.getString(_kGenderKey) ?? 'male';
  String get defaultCategory =>
      _prefs.getString(_kDefaultCategoryKey) ?? 'tops';

  Future<void> save({
    required String gender,
    required String defaultCategory,
  }) async {
    await _prefs.setString(_kGenderKey, gender);
    await _prefs.setString(_kDefaultCategoryKey, defaultCategory);
    await _prefs.setBool(_kPreferencesSetKey, true);
  }
}

final preferencesLocalSourceProvider =
    Provider<PreferencesLocalSource>((ref) {
  return PreferencesLocalSource(ref.watch(sharedPreferencesProvider));
});

final preferencesDoneProvider = StateProvider<bool>((ref) {
  return ref.watch(preferencesLocalSourceProvider).isDone;
});

final userGenderProvider = StateProvider<String>((ref) {
  return ref.watch(preferencesLocalSourceProvider).gender;
});

final defaultCategoryProvider = StateProvider<String>((ref) {
  return ref.watch(preferencesLocalSourceProvider).defaultCategory;
});