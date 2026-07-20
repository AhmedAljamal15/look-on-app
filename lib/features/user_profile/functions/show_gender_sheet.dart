import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:virtual_tryon_app/core/localization/app_strings.dart';
import 'package:virtual_tryon_app/core/theme/app_spacing.dart';
import 'package:virtual_tryon_app/features/preferences/data/preferences_local_source.dart';
import 'package:virtual_tryon_app/features/user_profile/presentation/widgets/sheet_option.dart';

void showGenderSheet(BuildContext context, WidgetRef ref, String current) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.tr('select_gender_title'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: SheetOption(
                  icon: Icons.man_rounded,
                  label: context.tr('gender_male'),
                  isSelected: current == 'male',
                  onTap: () async {
                    await ref.read(preferencesLocalSourceProvider).save(
                          gender: 'male',
                          defaultCategory: ref.read(defaultCategoryProvider),
                        );
                    ref.read(userGenderProvider.notifier).state = 'male';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SheetOption(
                  icon: Icons.woman_rounded,
                  label: context.tr('gender_female'),
                  isSelected: current == 'female',
                  onTap: () async {
                    await ref.read(preferencesLocalSourceProvider).save(
                          gender: 'female',
                          defaultCategory: ref.read(defaultCategoryProvider),
                        );
                    ref.read(userGenderProvider.notifier).state = 'female';
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