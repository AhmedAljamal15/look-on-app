import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/features/onboarding/presentation/widgets/language_setup.dart';
import 'package:virtual_tryon_app/features/onboarding/presentation/widgets/preferences_step.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/language_choice_local_source.dart';
import '../../../preferences/data/preferences_local_source.dart';

class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  int _step = 1;
  String _gender = 'male';
  String _category = 'tops';
  bool _saving = false;

  Future<void> _confirmLanguage(Locale locale) async {
    await ref.read(localeProvider.notifier).setLocale(locale);
    setState(() {
      _step = 2;
    });
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    await ref.read(languageChoiceLocalSourceProvider).markChosen();
    ref.read(languageChosenProvider.notifier).state = true;

    await ref.read(preferencesLocalSourceProvider).save(
          gender: _gender,
          defaultCategory: _category,
        );
    ref.read(preferencesDoneProvider.notifier).state = true;
    ref.read(userGenderProvider.notifier).state = _gender;
    ref.read(defaultCategoryProvider.notifier).state = _category;

    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: _step == 1
              ? LanguageStep(
                  key: const ValueKey('lang'),
                  onChoose: _confirmLanguage,
                )
              : PreferencesStep(
                  key: const ValueKey('prefs'),
                  gender: _gender,
                  category: _category,
                  saving: _saving,
                  onGenderChanged: (g) => setState(() => _gender = g),
                  onCategoryChanged: (c) => setState(() => _category = c),
                  onFinish: _finish,
                ),
        ),
      ),
    );
  }
}