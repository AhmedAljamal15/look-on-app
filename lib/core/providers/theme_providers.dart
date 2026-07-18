// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../features/onboarding/data/onboarding_local_source.dart';
// import '../constants/app_constants.dart';

// class ThemeModeNotifier extends Notifier<ThemeMode> {
//   @override
//   ThemeMode build() {
//     final prefs = ref.watch(sharedPreferencesProvider);
//     final saved = prefs.getString(AppConstants.themeMode);
//     return switch (saved) {
//       'light' => ThemeMode.light,
//       'dark' => ThemeMode.dark,
//       _ => ThemeMode.dark, // default dark
//     };
//   }

//   Future<void> setTheme(ThemeMode mode) async {
//     final prefs = ref.read(sharedPreferencesProvider);
//     await prefs.setString(
//       AppConstants.themeMode,
//       switch (mode) {
//         ThemeMode.light => 'light',
//         ThemeMode.dark => 'dark',
//         _ => 'system',
//       },
//     );
//     state = mode;
//   }

//   void toggle() {
//     setTheme(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
//   }
// }

// final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
//   ThemeModeNotifier.new,
// );