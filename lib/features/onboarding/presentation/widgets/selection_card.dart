
// ─────────────────────────────────────────────
// كارت اختيار عام (جنس أو category)
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/extensions/responsive_extensions.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/core/widgets/responsive_widgets.dart';

class SelectionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
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
          vertical:
              context.responsiveDimension(mobile: 12, tablet: 16, desktop: 20),
          horizontal:
              context.responsiveDimension(mobile: 8, tablet: 10, desktop: 12),
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
                  mobile: 24, tablet: 28, desktop: 32),
              color: isSelected ? Colors.white : AppColors.textTertiary,
            ),
            SizedBox(
              height:
                  context.responsiveGap(mobile: 6, tablet: 8, desktop: 10),
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
              height:
                  context.responsiveGap(mobile: 2, tablet: 3, desktop: 4),
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