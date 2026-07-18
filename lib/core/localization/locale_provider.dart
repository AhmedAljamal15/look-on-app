import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/data/onboarding_local_source.dart';
import 'app_strings.dart';

const String _localeKey = 'app_locale_key';

/// Holds the current app [Locale] and persists the choice so it survives
/// app restarts. Also keeps [AppLocalizations.currentLocaleCode] in sync so
/// non-widget code (services, thrown exceptions) resolves the right
/// language even without a BuildContext.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString(_localeKey);
    final locale = switch (saved) {
      'en' => const Locale('en'),
      _ => const Locale('ar'),
    };
    AppLocalizations.currentLocaleCode = locale.languageCode;
    return locale;
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_localeKey, locale.languageCode);
    AppLocalizations.currentLocaleCode = locale.languageCode;
    state = locale;
  }

  Future<void> toggle() async {
    await setLocale(state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar'));
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale>(
  LocaleController.new,
);
