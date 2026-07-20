import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:virtual_tryon_app/core/constants/app_constants.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/no_internet_banner.dart';
import 'features/onboarding/data/onboarding_local_source.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_KEY'] ?? '',
  );

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: DevicePreview(
        enabled: false,
        builder: (context) => const FitSnapApp(),
      ),
    ),
  );
}

class FitSnapApp extends ConsumerWidget {
  const FitSnapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: DevicePreview.locale(context) ?? locale,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        return DevicePreview.appBuilder(
          context,
          Builder(
            builder: (context) {
              final mq = MediaQuery.of(context);

              return DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.appBackgroundGradient,
                ),
                child: MediaQuery(
                  data: mq.copyWith(
                    textScaler: mq.textScaler.clamp(
                      minScaleFactor: 0.9,
                      maxScaleFactor: 1.2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      child ?? const SizedBox.shrink(),
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: NoInternetBanner(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
