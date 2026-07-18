import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color baseColor) {
    // Tajawal — بيدعم العربي والإنجليزي بشكل ممتاز
    // مناسب جداً لتطبيقات الـ lifestyle والفاشون
    final t = GoogleFonts.tajawalTextTheme();

    return TextTheme(
      displayLarge: t.displayLarge?.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: baseColor,
      ),
      displayMedium: t.displayMedium?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.2,
        color: baseColor,
      ),
      headlineLarge: t.headlineLarge?.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        height: 1.25,
        color: baseColor,
      ),
      headlineMedium: t.headlineMedium?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: baseColor,
      ),
      headlineSmall: t.headlineSmall?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: baseColor,
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      bodyLarge: t.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: baseColor,
      ),
      bodyMedium: t.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: baseColor,
      ),
      bodySmall: t.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: t.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: baseColor,
      ),
      labelMedium: t.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
        color: AppColors.textSecondary,
      ),
      labelSmall: t.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: AppColors.textTertiary,
      ),
    );
  }
}