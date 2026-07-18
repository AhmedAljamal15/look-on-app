import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class MeasurementField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? initialValue;
  final String unitLabel;
  final ValueChanged<String> onChanged;

  const MeasurementField({
    super.key,
    required this.label,
    required this.icon,
    required this.unitLabel,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.violet.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 18, color: AppColors.violetSoft),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: 70,
            child: TextFormField(
              initialValue: initialValue,
              onChanged: onChanged,
              textAlign: TextAlign.end,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.gold,
                  ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '—',
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            unitLabel,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}