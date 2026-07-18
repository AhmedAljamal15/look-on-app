import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/extensions/responsive_extensions.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_widgets.dart';
import '../../data/language_choice_local_source.dart';
import '../../../preferences/data/preferences_local_source.dart';

class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
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

    // حفظ الجنس والـ category — دول بيانات حقيقية بتأثر على الـ AI
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
              ? _LanguageStep(
                  key: const ValueKey('lang'),
                  onChoose: _confirmLanguage,
                )
              : _PreferencesStep(
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
// الخطوة 1: اختيار اللغة
// ─────────────────────────────────────────────
class _LanguageStep extends StatelessWidget {
  final ValueChanged<Locale> onChoose;

  const _LanguageStep({super.key, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      mobileHorizontal: 16,
      mobileVertical: 0,
      tabletHorizontal: 32,
      tabletVertical: 0,
      desktopHorizontal: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ResponsiveSizedBox(
            mobileWidth: 80,
            mobileHeight: 80,
            tabletWidth: 120,
            tabletHeight: 120,
            desktopWidth: 150,
            desktopHeight: 150,
            child: const AppLogo(fontSize: 40),
          ).animate().fadeIn(duration: 400.ms),
          SizedBox(
            height: context.responsiveGap(
              mobile: 8,
              tablet: 12,
              desktop: 16,
            ),
          ),
          ResponsiveText(
            'Choose your language  ·  اختار لغتك',
            textAlign: TextAlign.center,
            mobileFontSize: 14,
            tabletFontSize: 16,
            desktopFontSize: 18,
            color: AppColors.textTertiary,
          ).animate().fadeIn(delay: 120.ms),
          SizedBox(
            height: context.responsiveGap(
              mobile: 32,
              tablet: 48,
              desktop: 64,
            ),
          ),
          _LanguageCard(
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
          _LanguageCard(
            label: 'English',
            subLabel: 'الإنجليزية',
            icon: Icons.language_rounded,
            onTap: () => onChoose(const Locale('en')),
          ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.08, end: 0),
          const Spacer(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// الخطوة 2: اختيار الجنس والـ category
// ─────────────────────────────────────────────
class _PreferencesStep extends StatelessWidget {
  final String gender;
  final String category;
  final bool saving;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFinish;

  const _PreferencesStep({
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
            ResponsiveText(
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
            ResponsiveText(
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

            // ── اختيار الجنس ──
            ResponsiveText(
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
            Row(
              children: [
                Expanded(
                  child: _SelectionCard(
                    icon: Icons.man_rounded,
                    label: 'رجل',
                    subLabel: 'Male',
                    isSelected: gender == 'male',
                    onTap: () => onGenderChanged('male'),
                  ),
                ),
                SizedBox(
                  width: context.responsiveGap(
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                Expanded(
                  child: _SelectionCard(
                    icon: Icons.woman_rounded,
                    label: 'امرأة',
                    subLabel: 'Female',
                    isSelected: gender == 'female',
                    onTap: () => onGenderChanged('female'),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 180.ms).slideY(begin: 0.05, end: 0),
            SizedBox(
              height: context.responsiveGap(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),

            // ── اختيار الـ category المفضلة ──
            ResponsiveText(
              'بصوّر عادةً',
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
            ).animate().fadeIn(delay: 240.ms),
            SizedBox(
              height: context.responsiveGap(
                mobile: 8,
                tablet: 12,
                desktop: 16,
              ),
            ),
            ResponsiveGridView(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mobileColumns: 3,
              tabletColumns: 3,
              desktopColumns: 3,
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
                const labels = ['علوي', 'سفلي', 'كاملة'];
                const subLabels = [
                  'قمصان / تيشرتات',
                  'بناطيل / تنانير',
                  'فساتين'
                ];

                return _SelectionCard(
                  icon: icons[index],
                  label: labels[index],
                  subLabel: subLabels[index],
                  isSelected: category == categories[index],
                  onTap: () => onCategoryChanged(categories[index]),
                );
              },
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),

            SizedBox(
              height: context.responsiveGap(
                mobile: 24,
                tablet: 32,
                desktop: 40,
              ),
            ),

            ResponsiveSizedBox(
              mobileHeight: 44,
              tabletHeight: 48,
              desktopHeight: 52,
              child: PrimaryButton(
                label: 'يلا نبدأ',
                isLoading: saving,
                onPressed: onFinish,
              ),
            ).animate().fadeIn(delay: 400.ms),

            SizedBox(
              height: context.responsiveGap(
                mobile: 12,
                tablet: 16,
                desktop: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// كارت اختيار عام (جنس أو category)
// ─────────────────────────────────────────────
class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
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
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          vertical: context.responsiveDimension(
            mobile: 12,
            tablet: 16,
            desktop: 20,
          ),
          horizontal: context.responsiveDimension(
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.inkElevated,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.responsiveDimension(
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              color: isSelected ? Colors.white : AppColors.textTertiary,
            ),
            SizedBox(
              height: context.responsiveGap(
                mobile: 6,
                tablet: 8,
                desktop: 10,
              ),
            ),
            ResponsiveText(
              label,
              mobileFontSize: 13,
              tabletFontSize: 14,
              desktopFontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: context.responsiveGap(
                mobile: 2,
                tablet: 3,
                desktop: 4,
              ),
            ),
            ResponsiveText(
              subLabel,
              mobileFontSize: 10,
              tabletFontSize: 11,
              desktopFontSize: 12,
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.textTertiary,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Language Card - Responsive Version
// ─────────────────────────────────────────────
class _LanguageCard extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = context.responsiveDimension(
      mobile: 44,
      tablet: 52,
      desktop: 60,
    );

    return Material(
      color: AppColors.inkElevated,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveDimension(
              mobile: 16,
              tablet: 24,
              desktop: 32,
            ),
            vertical: context.responsiveDimension(
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              ResponsiveSizedBox(
                mobileWidth: iconSize,
                mobileHeight: iconSize,
                tabletWidth: iconSize,
                tabletHeight: iconSize,
                desktopWidth: iconSize,
                desktopHeight: iconSize,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: context.responsiveDimension(
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: context.responsiveGap(
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      label,
                      mobileFontSize: 16,
                      tabletFontSize: 18,
                      desktopFontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: context.responsiveGap(
                        mobile: 2,
                        tablet: 4,
                        desktop: 6,
                      ),
                    ),
                    ResponsiveText(
                      subLabel,
                      mobileFontSize: 12,
                      tabletFontSize: 13,
                      desktopFontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: context.responsiveDimension(
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                ),
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
