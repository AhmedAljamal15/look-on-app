
// ─────────────────────────────────────────────
// الخطوة 2: اختيار الجنس والـ category
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';
import 'package:virtual_tryon_app/core/widgets/primary_button.dart';
import 'package:virtual_tryon_app/core/widgets/responsive_widgets.dart';
import 'package:virtual_tryon_app/features/onboarding/presentation/widgets/selection_card.dart';

import '../../../../core/theme/app_colors.dart';

class PreferencesStep extends StatelessWidget {
  final String gender;
  final String category;
  final bool saving;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFinish;

  const PreferencesStep({
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
                  mobile: 20, tablet: 32, desktop: 40),
            ),
            ResponsiveText(
              context.tr('complete_your_setup'),
              mobileFontSize: 28,
              tabletFontSize: 32,
              desktopFontSize: 36,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ).animate().fadeIn(),
            SizedBox(
              height:
                  context.responsiveGap(mobile: 8, tablet: 12, desktop: 16),
            ),
            ResponsiveText(
              context.tr('preferences_hint'),
              mobileFontSize: 14,
              tabletFontSize: 16,
              desktopFontSize: 18,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ).animate().fadeIn(delay: 80.ms),
            SizedBox(
              height: context.responsiveGap(
                  mobile: 24, tablet: 32, desktop: 40),
            ),

            // ── اختيار الجنس ──
            ResponsiveText(
              context.tr('i_am_label'),
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
            ).animate().fadeIn(delay: 140.ms),
            SizedBox(
              height:
                  context.responsiveGap(mobile: 8, tablet: 12, desktop: 16),
            ),
            Row(
              children: [
                Expanded(
                  child: SelectionCard(
                    icon: Icons.man_rounded,
                    label: context.tr('gender_male'),
                    subLabel: 'Male',
                    isSelected: gender == 'male',
                    onTap: () => onGenderChanged('male'),
                  ),
                ),
                SizedBox(
                  width: context.responsiveGap(
                      mobile: 8, tablet: 12, desktop: 16),
                ),
                Expanded(
                  child: SelectionCard(
                    icon: Icons.woman_rounded,
                    label: context.tr('gender_female'),
                    subLabel: 'Female',
                    isSelected: gender == 'female',
                    onTap: () => onGenderChanged('female'),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 180.ms).slideY(begin: 0.05, end: 0),
            SizedBox(
              height: context.responsiveGap(
                  mobile: 24, tablet: 32, desktop: 40),
            ),

            // ── اختيار الـ category المفضلة ──
            ResponsiveText(
              context.tr('usually_wear_label'),
              mobileFontSize: 16,
              tabletFontSize: 18,
              desktopFontSize: 20,
              fontWeight: FontWeight.bold,
            ).animate().fadeIn(delay: 240.ms),
            SizedBox(
              height:
                  context.responsiveGap(mobile: 8, tablet: 12, desktop: 16),
            ),
            ResponsiveGridView(
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mobileColumns: 3,
              tabletColumns: 3,
              desktopColumns: 3,
              mainAxisSpacing: context.responsiveGap(
                  mobile: 8, tablet: 12, desktop: 16),
              crossAxisSpacing: context.responsiveGap(
                  mobile: 8, tablet: 12, desktop: 16),
              itemBuilder: (context, index) {
                const categories = ['tops', 'bottoms', 'one-pieces'];
                const icons = [
                  Icons.checkroom_rounded,
                  Icons.accessibility_new_rounded,
                  Icons.dry_cleaning_rounded,
                ];
                final labels = [
                  context.tr('category_tops'),
                  context.tr('category_bottoms'),
                  context.tr('category_one_pieces_short'),
                ];
                final subLabels = [
                  context.tr('category_tops_sub'),
                  context.tr('category_bottoms_sub'),
                  context.tr('category_one_pieces_sub'),
                ];

                return SelectionCard(
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
                  mobile: 24, tablet: 32, desktop: 40),
            ),

            ResponsiveSizedBox(
              mobileHeight: 44,
              tabletHeight: 48,
              desktopHeight: 52,
              child: PrimaryButton(
                label: context.tr('lets_go_short'),
                isLoading: saving,
                onPressed: onFinish,
              ),
            ).animate().fadeIn(delay: 400.ms),

            SizedBox(
              height: context.responsiveGap(
                  mobile: 12, tablet: 16, desktop: 20),
            ),
          ],
        ),
      ),
    );
  }
}