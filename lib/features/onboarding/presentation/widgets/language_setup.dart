// ─────────────────────────────────────────────
// الخطوة 1: اختيار اللغة
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/features/onboarding/presentation/widgets/language_card.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/responsive_widgets.dart';

class LanguageStep extends StatelessWidget {
  final ValueChanged<Locale> onChoose;

  const LanguageStep({super.key, required this.onChoose});

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
          const ResponsiveSizedBox(
            mobileWidth: 80,
            mobileHeight: 80,
            tabletWidth: 120,
            tabletHeight: 120,
            desktopWidth: 150,
            desktopHeight: 150,
            child: AppLogo(fontSize: 40),
          ).animate().fadeIn(duration: 400.ms),
          SizedBox(
            height: context.responsiveGap(mobile: 8, tablet: 12, desktop: 16),
          ),
          const ResponsiveText(
            'Choose your language  ·  اختار لغتك',
            textAlign: TextAlign.center,
            mobileFontSize: 14,
            tabletFontSize: 16,
            desktopFontSize: 18,
            color: AppColors.textTertiary,
          ).animate().fadeIn(delay: 120.ms),
          SizedBox(
            height:
                context.responsiveGap(mobile: 32, tablet: 48, desktop: 64),
          ),
          LanguageCard(
            label: 'العربية',
            subLabel: 'Arabic',
            icon: Icons.translate_rounded,
            onTap: () => onChoose(const Locale('ar')),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08, end: 0),
          SizedBox(
            height:
                context.responsiveGap(mobile: 12, tablet: 16, desktop: 20),
          ),
          LanguageCard(
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