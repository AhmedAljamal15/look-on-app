import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/measurements.dart';

const _kMeasurementsKey = 'user_measurements';

class MeasurementsRepository {
  final SharedPreferences _prefs;

  MeasurementsRepository(this._prefs);

  Measurements? load() {
    final json = _prefs.getString(_kMeasurementsKey);
    if (json == null) return null;
    try {
      return Measurements.fromMap(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(Measurements m) async {
    await _prefs.setString(_kMeasurementsKey, jsonEncode(m.toMap()));
  }

  Future<void> clear() async {
    await _prefs.remove(_kMeasurementsKey);
  }
}