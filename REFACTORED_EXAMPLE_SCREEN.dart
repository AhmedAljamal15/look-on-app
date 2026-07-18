import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/core/localization/locale_provider.dart';
import 'package:virtual_tryon_app/core/router/app_routes.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';
import 'package:virtual_tryon_app/core/widgets/app_logo.dart';
import 'package:virtual_tryon_app/core/widgets/primary_button.dart';
import 'package:virtual_tryon_app/core/widgets/responsive_widgets.dart';
import 'package:virtual_tryon_app/features/onboarding/data/language_choice_local_source.dart';
import 'package:virtual_tryon_app/features/preferences/data/preferences_local_source.dart';


/// EXAMPLE: Refactored Language Select Screen with Full Responsiveness
/// This shows how to apply responsive design patterns to your existing screens

class LanguageSelectScreenResponsive extends ConsumerStatefulWidget {
  const LanguageSelectScreenResponsive({super.key});

  @override
  ConsumerState<LanguageSelectScreenResponsive> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState
    extends ConsumerState<LanguageSelectScreenResponsive> {
  // Step 1 = language, Step 2 = gender + category
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

    // حفظ اللغة
    await ref.read(languageChoiceLocalSourceProvider).markChosen();
    ref.read(languageChosenProvider.notifier).state = true;

    // حفظ الجنس والـ category
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
              ? _LanguageStepResponsive(
                  key: const ValueKey('lang'),
                  onChoose: _confirmLanguage,
                )
              : _PreferencesStepResponsive(
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

// ─────────────────────────────────────────────
// RESPONSIVE: Language Selection Step
// ─────────────────────────────────────────────
class _LanguageStepResponsive extends StatelessWidget {
  final ValueChanged<Locale> onChoose;

  const _LanguageStepResponsive({super.key, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    // Responsive padding based on device type
    final horizontalPadding = context.responsiveDimension(
      mobile: 16,
      tablet: 32,
      desktop: 48,
    );

    final verticalSpacing = context.responsiveDimension(
      mobile: 24,
      tablet: 32,
      desktop: 48,
    );

    return ResponsivePadding(
      mobileHorizontal: 16,
      mobileVertical: 0,
      tabletHorizontal: 32,
      tabletVertical: 0,
      desktopHorizontal: 48,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Responsive spacer
            SizedBox(
              height: context.heightPercent(10), // 10% of screen height
            ),

            // Logo with responsive size
            const ResponsiveSizedBox(
              mobileWidth: 80,
              mobileHeight: 80,
              tabletWidth: 120,
              tabletHeight: 120,
              desktopWidth: 150,
              desktopHeight: 150,
              child: AppLogo(fontSize: 40),
            ).animate().fadeIn(duration: 400.ms),

            // Responsive spacing
            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),

            // Responsive heading
            const ResponsiveText(
              'Choose your language  ·  اختار لغتك',
              textAlign: TextAlign.center,
              mobileFontSize: 14,
              tabletFontSize: 16,
              desktopFontSize: 18,
              color: AppColors.textTertiary,
            ).animate().fadeIn(delay: 120.ms),

            // Responsive spacing
            SizedBox(
              height: context.responsiveGap(
                mobile: 32,
                tablet: 48,
                desktop: 64,
              ),
            ),

            // Language cards with responsive sizing
            _ResponsiveLanguageCard(
              label: 'العربية',
              subLabel: 'Arabic',
              icon: Icons.translate_rounded,
              onTap: () => onChoose(const Locale('ar')),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08, end: 0),

            SizedBox(
              height: context.responsiveGap(
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),

            _ResponsiveLanguageCard(
              label: 'English',
              subLabel: 'الإنجليزية',
              icon: Icons.language_rounded,
              onTap: () => onChoose(const Locale('en')),
            ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.08, end: 0),

            // Responsive bottom spacer
            SizedBox(
              height: context.heightPercent(10),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESPONSIVE: Preferences Selection Step
// ─────────────────────────────────────────────
class _PreferencesStepResponsive extends StatelessWidget {
  final String gender;
  final String category;
  final bool saving;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFinish;

  const _PreferencesStepResponsive({
    super.key,
    required this.gender,
    required this.category,
    required this.saving,
    required this.onGenderChanged,
    required this.onCategoryChanged,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      mobileHorizontal: 16,
      mobileVertical: 12,
      tabletHorizontal: 32,
      tabletVertical: 16,
      desktopHorizontal: 48,
      desktopVertical: 20,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: context.responsiveGap(
                mobile: 20,
                tablet: 32,
                desktop: 40,
              ),
            ),

            // Responsive heading
            const ResponsiveText(
              'كمّل إعدادك',
              mobileFontSize: 28,
              tabletFontSize: 32,
              desktopFontSize: 36,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ).animate().fadeIn(),

            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),

            // Responsive subtitle
            const ResponsiveText(
              'بياناتك دي بتساعد الـ AI يركّب الملابس صح عليك',
              mobileFontSize: 14,
              tabletFontSize: 16,
              desktopFontSize: 18,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ).animate().fadeIn(delay: 80.ms),

            SizedBox(
              height: context.responsiveGap(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),

            // ── Gender Selection ──
            const ResponsiveText(
              'أنا',
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
            ).animate().fadeIn(delay: 140.ms),

            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),

            // Responsive gender selection row
            ResponsiveRow(
              spacing: 0,
              mobileSpacing: 8,
              tabletSpacing: 12,
              children: [
                Expanded(
                  child: _ResponsiveSelectionCard(
                    icon: Icons.man_rounded,
                    label: 'رجل',
                    subLabel: 'Male',
                    isSelected: gender == 'male',
                    onTap: () => onGenderChanged('male'),
                  ),
                ),
                Expanded(
                  child: _ResponsiveSelectionCard(
                    icon: Icons.woman_rounded,
                    label: 'امرأة',
                    subLabel: 'Female',
                    isSelected: gender == 'female',
                    onTap: () => onGenderChanged('female'),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: context.responsiveGap(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),

            // ── Category Selection ──
            const ResponsiveText(
              'الملابس اللي اهتم بيها',
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
            ).animate().fadeIn(delay: 160.ms),

            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),

            // Responsive category grid
            ResponsiveGridView(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mobileColumns: 3,
              tabletColumns: 3,
              desktopColumns: 3,
              mobileChildHeight: 100,
              tabletChildHeight: 140,
              desktopChildHeight: 160,
              mainAxisSpacing: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
              crossAxisSpacing: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
              itemBuilder: (context, index) {
                const categories = ['tops', 'bottoms', 'one-pieces'];
                const icons = [
                  Icons.checkroom_rounded,
                  Icons.accessibility_new_rounded,
                  Icons.dry_cleaning_rounded,
                ];
                const labels = ['قمصان', 'بناطيل', 'فساتين'];
                const subLabels = ['Tops', 'Bottoms', 'Dresses'];

                return _ResponsiveSelectionCard(
                  icon: icons[index],
                  label: labels[index],
                  subLabel: subLabels[index],
                  isSelected: category == categories[index],
                  onTap: () => onCategoryChanged(categories[index]),
                );
              },
            ),

            SizedBox(
              height: context.responsiveGap(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),

            // Responsive finish button
            ResponsiveSizedBox(
              mobileHeight: 44,
              tabletHeight: 48,
              desktopHeight: 52,
              child: PrimaryButton(
                label: 'تمام!',
                isLoading: saving,
                onPressed: onFinish,
              ),
            ),

            SizedBox(
              height: context.responsiveGap(
                mobile: 20,
                tablet: 32,
                desktop: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RESPONSIVE: Reusable Cards
// ─────────────────────────────────────────────

class _ResponsiveLanguageCard extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final VoidCallback onTap;

  const _ResponsiveLanguageCard({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ResponsiveContainer(
        mobilePadding: 16,
        tabletPadding: 24,
        desktopPadding: 32,
        backgroundColor: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(
          context.responsiveDimension(
            mobile: 12,
            tablet: 16,
            desktop: 20,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Responsive icon
            ResponsiveSizedBox(
              mobileWidth: 40,
              mobileHeight: 40,
              tabletWidth: 50,
              tabletHeight: 50,
              desktopWidth: 60,
              desktopHeight: 60,
              child: Icon(
                icon,
                size: context.responsiveDimension(
                  mobile: 24,
                  tablet: 32,
                  desktop: 40,
                ),
                color: AppColors.violet,
              ),
            ),

            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),

            // Responsive text
            ResponsiveText(
              label,
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: context.responsiveGap(
                mobile: 4,
                tablet: 6,
                desktop: 8,
              ),
            ),

            ResponsiveText(
              subLabel,
              mobileFontSize: 12,
              tabletFontSize: 14,
              desktopFontSize: 16,
              color: AppColors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveSelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResponsiveSelectionCard({
    required this.icon,
    required this.label,
    required this.subLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.violet : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(
            context.responsiveDimension(
              mobile: 12,
              tablet: 16,
              desktop: 20,
            ),
          ),
          color: isSelected
              ? AppColors.violet.withOpacity(0.1)
              : Colors.transparent,
        ),
        padding: EdgeInsets.all(
          context.responsiveDimension(
            mobile: 8,
            tablet: 12,
            desktop: 16,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.responsiveDimension(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
              color: isSelected ? AppColors.violet : AppColors.textTertiary,
            ),
            SizedBox(
              height: context.responsiveGap(
                mobile: 4,
                tablet: 8,
                desktop: 10,
              ),
            ),
            ResponsiveText(
              label,
              mobileFontSize: 12,
              tabletFontSize: 14,
              desktopFontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.violet : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            ResponsiveText(
              subLabel,
              mobileFontSize: 10,
              tabletFontSize: 11,
              desktopFontSize: 12,
              color: isSelected ? AppColors.violet : AppColors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
