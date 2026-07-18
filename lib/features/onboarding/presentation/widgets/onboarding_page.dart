import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: AppColors.coralGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Icon(data.icon, size: 60, color: AppColors.ink),
          ).animate().scale(
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ).animate().fadeIn(delay: 250.ms),
        ],
      ),
    );
  }
}
