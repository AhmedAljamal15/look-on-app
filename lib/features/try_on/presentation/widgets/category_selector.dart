
import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/features/try_on/presentation/screens/capture_garment_screen.dart';
import 'package:virtual_tryon_app/features/try_on/presentation/widgets/category_chip.dart';

class CategorySelector extends StatelessWidget {
  final GarmentCategory selected;
  final ValueChanged<GarmentCategory> onSelect;

  const CategorySelector({super.key, 
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CategoryChip(
            icon: Icons.checkroom_rounded,
            label: context.tr('category_tops'),
            subLabel: context.tr('category_tops_sub'),
            isSelected: selected == GarmentCategory.tops,
            onTap: () => onSelect(GarmentCategory.tops),
          ),
          CategoryChip(
            icon: Icons.accessibility_new_rounded,
            label: context.tr('category_bottoms'),
            subLabel: context.tr('category_bottoms_sub'),
            isSelected: selected == GarmentCategory.bottoms,
            onTap: () => onSelect(GarmentCategory.bottoms),
          ),
          CategoryChip(
            icon: Icons.dry_cleaning_rounded,
            label: context.tr('category_one_pieces'),
            subLabel: context.tr('category_one_pieces_sub'),
            isSelected: selected == GarmentCategory.onePieces,
            onTap: () => onSelect(GarmentCategory.onePieces),
          ),
        ],
      ),
    );
  }
}