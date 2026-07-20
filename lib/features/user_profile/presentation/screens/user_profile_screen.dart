import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/core/widgets/form_date.dart';
import 'package:virtual_tryon_app/features/user_profile/functions/show_category_sheet.dart';
import 'package:virtual_tryon_app/features/user_profile/functions/show_gender_sheet.dart';
import 'package:virtual_tryon_app/features/user_profile/presentation/widgets/editable_tile.dart';
import 'package:virtual_tryon_app/features/user_profile/presentation/widgets/language_tile.dart';
import 'package:virtual_tryon_app/features/user_profile/presentation/widgets/profile_link_tile.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../measurements/application/measurements_providers.dart';
import '../../../preferences/data/preferences_local_source.dart';
import '../../../profile_photo/application/profile_photo_providers.dart';
import '../../application/profile_stats_provider.dart';
import '../widgets/stat_card.dart';
import '../../../../core/localization/app_strings.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePhoto = ref.watch(activeProfilePhotoProvider).value;
    final stats = ref.watch(profileStatsProvider);
    final measurements = ref.watch(measurementsProvider);
    final gender = ref.watch(userGenderProvider);
    final defaultCategory = ref.watch(defaultCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      gradient: AppColors.violetGoldGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.ink,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: SizedBox(
                          width: 84,
                          height: 84,
                          child: profilePhoto != null
                              ? CachedNetworkImage(
                                  imageUrl: profilePhoto.imageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppColors.inkElevated,
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    size: 36,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ).animate().scale(
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    context.tr('account'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn(delay: 150.ms),
                  if (stats.memberSince != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        context.tr('member_since').replaceAll(
                            '{date}', formatDate(context, stats.memberSince!)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.checkroom_rounded,
                    value: '${stats.totalTryOns}',
                    label: context.tr('total_attempts'),
                    gradient: AppColors.primaryGradient,
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1, end: 0),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: StatCard(
                    icon: Icons.calendar_month_rounded,
                    value: '${stats.thisMonthTryOns}',
                    label: context.tr('this_month'),
                    gradient: AppColors.goldGradient,
                  ).animate().fadeIn(delay: 320.ms).slideY(begin: 0.1, end: 0),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(context.tr('settings'),
                    style: Theme.of(context).textTheme.titleMedium)
                .animate()
                .fadeIn(delay: 380.ms),
            const SizedBox(height: AppSpacing.sm),

            ProfileLinkTile(
              icon: Icons.photo_camera_outlined,
              title: context.tr('profile_photo_title'),
              subtitle: profilePhoto != null
                  ? context.tr('updated')
                  : context.tr('not_set_yet'),
              onTap: () => context.push(AppRoutes.captureProfile),
            ).animate().fadeIn(delay: 420.ms),

            const SizedBox(height: AppSpacing.xs),

            ProfileLinkTile(
              icon: Icons.straighten_rounded,
              title: context.tr('my_measurements_title'),
              subtitle: measurements != null && !measurements.isEmpty
                  ? context.tr('saved')
                  : context.tr('not_set_yet'),
              onTap: () => context.push(AppRoutes.measurements),
            ).animate().fadeIn(delay: 460.ms),

            const SizedBox(height: AppSpacing.xs),

// الجنس
            EditableTile(
              icon: gender == 'male' ? Icons.man_rounded : Icons.woman_rounded,
              title: context.tr('gender_label'),
              subtitle: gender == 'male'
                  ? context.tr('gender_male')
                  : context.tr('gender_female'),
              onTap: () => showGenderSheet(context, ref, gender),
            ).animate().fadeIn(delay: 480.ms),

            const SizedBox(height: AppSpacing.xs),

// الـ category المفضلة
            EditableTile(
              icon: defaultCategory == 'tops'
                  ? Icons.checkroom_rounded
                  : defaultCategory == 'bottoms'
                      ? Icons.accessibility_new_rounded
                      : Icons.dry_cleaning_rounded,
              title: context.tr('preferred_garment'),
              subtitle: defaultCategory == 'tops'
                  ? context.tr('category_tops_full')
                  : defaultCategory == 'bottoms'
                      ? context.tr('category_bottoms_full')
                      : context.tr('category_one_pieces_full'),
              onTap: () => showCategorySheet(context, ref, defaultCategory),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: AppSpacing.xs),

            ProfileLinkTile(
              icon: Icons.history_rounded,
              title: context.tr('all_attempts'),
              subtitle: context
                  .tr('attempts_count')
                  .replaceAll('{n}', '${stats.totalTryOns}'),
              onTap: () => context.push(AppRoutes.history),
            ).animate().fadeIn(delay: 500.ms),

            const SizedBox(height: AppSpacing.xs),

            ProfileLinkTile(
              icon: Icons.settings_outlined,
              title: context.tr('settings'),
              subtitle: null,
              onTap: () => context.push(AppRoutes.settings),
            ).animate().fadeIn(delay: 540.ms),

            const SizedBox(height: AppSpacing.xs),

            const LanguageTile(),
          ],
        ),
      ),
    );
  }

 
}