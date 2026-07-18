import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SizeChipSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const SizeChipSelector({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: _sizes.map((size) {
        final isSelected = size == selected;
        return GestureDetector(
          onTap: () => onSelect(size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 52,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : AppColors.inkElevated,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.border,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.violet.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              size,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
}