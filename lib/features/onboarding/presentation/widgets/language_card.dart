

// ─────────────────────────────────────────────
// Language Card
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/core/widgets/responsive_widgets.dart';

class LanguageCard extends StatelessWidget {
  final String label;
  final String subLabel;
  final IconData icon;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize =
        context.responsiveDimension(mobile: 44, tablet: 52, desktop: 60);

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
                mobile: 16, tablet: 24, desktop: 32),
            vertical: context.responsiveDimension(
                mobile: 16, tablet: 20, desktop: 24),
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
                        mobile: 20, tablet: 24, desktop: 28),
                  ),
                ),
              ),
              SizedBox(
                width: context.responsiveGap(
                    mobile: 16, tablet: 20, desktop: 24),
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
                          mobile: 2, tablet: 4, desktop: 6),
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
                    mobile: 16, tablet: 18, desktop: 20),
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}