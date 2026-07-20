
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/features/preferences/data/preferences_local_source.dart';
import 'package:virtual_tryon_app/features/user_profile/presentation/widgets/sheet_option.dart';

void showCategorySheet(BuildContext context, WidgetRef ref, String current) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.tr('preferred_garment'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SheetOption(
                  icon: Icons.checkroom_rounded,
                  label: context.tr('category_tops'),
                  isSelected: current == 'tops',
                  onTap: () async {
                    await ref.read(preferencesLocalSourceProvider).save(
                          gender: ref.read(userGenderProvider),
                          defaultCategory: 'tops',
                        );
                    ref.read(defaultCategoryProvider.notifier).state = 'tops';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SheetOption(
                  icon: Icons.accessibility_new_rounded,
                  label: context.tr('category_bottoms'),
                  isSelected: current == 'bottoms',
                  onTap: () async {
                    await ref.read(preferencesLocalSourceProvider).save(
                          gender: ref.read(userGenderProvider),
                          defaultCategory: 'bottoms',
                        );
                    ref.read(defaultCategoryProvider.notifier).state =
                        'bottoms';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SheetOption(
                  icon: Icons.dry_cleaning_rounded,
                  label: context.tr('category_one_pieces'),
                  isSelected: current == 'one-pieces',
                  onTap: () async {
                    await ref.read(preferencesLocalSourceProvider).save(
                          gender: ref.read(userGenderProvider),
                          defaultCategory: 'one-pieces',
                        );
                    ref.read(defaultCategoryProvider.notifier).state =
                        'one-pieces';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    ),
  );
}