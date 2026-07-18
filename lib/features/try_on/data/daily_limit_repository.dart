import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../onboarding/data/onboarding_local_source.dart';

const _kDailyCountKey = 'daily_tryon_count';
const _kDailyDateKey = 'daily_tryon_date';
const int kDailyLimit = 5;

/// Tracks how many try-on generations the user has made today, resetting
/// automatically at midnight. Protects against runaway AI API costs.
class DailyLimitRepository {
  final SharedPreferences _prefs;
  DailyLimitRepository(this._prefs);

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  int get remainingToday {
    final savedDate = _prefs.getString(_kDailyDateKey);
    if (savedDate != _todayKey) {
      return kDailyLimit;
    }
    final used = _prefs.getInt(_kDailyCountKey) ?? 0;
    return (kDailyLimit - used).clamp(0, kDailyLimit);
  }

  bool get hasRemainingAttempts => remainingToday > 0;

  Future<void> recordAttempt() async {
    final savedDate = _prefs.getString(_kDailyDateKey);
    if (savedDate != _todayKey) {
      await _prefs.setString(_kDailyDateKey, _todayKey);
      await _prefs.setInt(_kDailyCountKey, 1);
    } else {
      final used = _prefs.getInt(_kDailyCountKey) ?? 0;
      await _prefs.setInt(_kDailyCountKey, used + 1);
    }
  }
}

final dailyLimitRepositoryProvider = Provider<DailyLimitRepository>((ref) {
  return DailyLimitRepository(ref.watch(sharedPreferencesProvider));
});

final dailyRemainingProvider = StateProvider<int>((ref) {
  return ref.watch(dailyLimitRepositoryProvider).remainingToday;
});