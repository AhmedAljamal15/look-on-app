import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';

class UnitToggle extends StatelessWidget {
  final bool isCm;
  final ValueChanged<bool> onChanged;

  const UnitToggle({super.key, required this.isCm, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleOption(context, context.tr('unit_cm'), isCm, () => onChanged(true)),
          _toggleOption(context, context.tr('unit_in'), !isCm, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _toggleOption(
    BuildContext context,
    String label,
    bool active,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.violet : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    active ? AppColors.textPrimary : AppColors.textTertiary,
              ),
        ),
      ),
    );
  }
}