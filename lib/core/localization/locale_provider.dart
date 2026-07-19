import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/data/onboarding_local_source.dart';
import '../../features/onboarding/data/language_choice_local_source.dart';
import 'app_strings.dart';

const String _localeKey = 'app_locale_key';

/// Holds the current app [Locale] and persists the choice so it survives
/// app restarts. Also keeps [AppLocalizations.currentLocaleCode] in sync so
/// non-widget code (services, thrown exceptions) resolves the right
/// language even without a BuildContext.
///
/// On the very first launch (no saved locale yet), the app automatically
/// detects the device's system language: Arabic if the system language
/// is Arabic (any dialect/country variant), English for anything else.
/// This detected choice is immediately persisted and marked as "chosen"
/// so the language-select screen is skipped on the first-launch flow,
/// while still leaving the manual toggle in the profile screen fully
/// functional for later changes.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final saved = prefs.getString(_localeKey);

    if (saved != null) {
      // اللغة اتحددت قبل كده (يدوياً أو تلقائياً) — استخدمها زي ما هي.
      final locale = saved == 'en' ? const Locale('en') : const Locale('ar');
      AppLocalizations.currentLocaleCode = locale.languageCode;
      return locale;
    }

    // أول مرة يفتح فيها التطبيق: نكشف لغة النظام تلقائياً.
    final systemLanguageCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final detectedLocale =
        systemLanguageCode == 'ar' ? const Locale('ar') : const Locale('en');

    // نحفظ الاختيار المكتشف فوراً ونعلّمه كـ "مختار" عشان الراوتر
    // يتخطى شاشة اختيار اللغة اليدوية تلقائياً.
    prefs.setString(_localeKey, detectedLocale.languageCode);
    ref.read(languageChoiceLocalSourceProvider).markChosen();

    AppLocalizations.currentLocaleCode = detectedLocale.languageCode;
    return detectedLocale;
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