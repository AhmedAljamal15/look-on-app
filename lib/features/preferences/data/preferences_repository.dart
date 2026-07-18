import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/onboarding/data/onboarding_local_source.dart';
import '../domain/user_preferences.dart';

const _kPreferencesKey = 'user_preferences';
const _kPreferencesSetKey = 'preferences_setup_done';

class PreferencesRepository {
  final SharedPreferences _prefs;
  PreferencesRepository(this._prefs);

  bool get isSetupDone => _prefs.getBool(_kPreferencesSetKey) ?? false;

  UserPreferences load() {
    final json = _prefs.getString(_kPreferencesKey);
    if (json == null) return const UserPreferences();
    try {
      return UserPreferences.fromMap(
          jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return const UserPreferences();
    }
  }

  Future<void> save(UserPreferences prefs) async {
    await _prefs.setString(_kPreferencesKey, jsonEncode(prefs.toMap()));
    await _prefs.setBool(_kPreferencesSetKey, true);
  }
}

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository(ref.watch(sharedPreferencesProvider));
});

class PreferencesNotifier extends Notifier<UserPreferences> {
  @override
  UserPreferences build() {
    return ref.watch(preferencesRepositoryProvider).load();
  }

  Future<void> save(UserPreferences prefs) async {
    await ref.read(preferencesRepositoryProvider).save(prefs);
    state = prefs;
  }

  Future<void> setLanguage(AppLanguage lang) async {
    await save(state.copyWith(language: lang));
  }

  Future<void> setGender(UserGender gender) async {
    await save(state.copyWith(gender: gender));
  }
}

final preferencesProvider =
    NotifierProvider<PreferencesNotifier, UserPreferences>(
  PreferencesNotifier.new,
);

final preferencesSetupDoneProvider = Provider<bool>((ref) {
  return ref.watch(preferencesRepositoryProvider).isSetupDone;
});