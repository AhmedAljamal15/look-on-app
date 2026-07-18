import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../../../../core/localization/locale_provider.dart';

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
                            '{date}', _formatDate(context, stats.memberSince!)),
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
_EditableTile(
  icon: gender == 'male' ? Icons.man_rounded : Icons.woman_rounded,
  title: context.tr('gender_label'),
  subtitle: gender == 'male'
      ? context.tr('gender_male')
      : context.tr('gender_female'),
  onTap: () => _showGenderSheet(context, ref, gender),
).animate().fadeIn(delay: 480.ms),

const SizedBox(height: AppSpacing.xs),

// الـ category المفضلة
_EditableTile(
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
  onTap: () => _showCategorySheet(context, ref, defaultCategory),
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

            _LanguageTile(),

            // const SizedBox(height: AppSpacing.lg),

            // // Theme toggle
            // Container(
            //   padding: const EdgeInsets.all(AppSpacing.md),
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).brightness == Brightness.dark
            //         ? AppColors.inkElevated
            //         : AppColors.lightSurface,
            //     borderRadius: BorderRadius.circular(AppRadius.md),
            //     border: Border.all(color: AppColors.border),
            //   ),
            //   child: Row(
            //     children: [
            //       Container(
            //         width: 38,
            //         height: 38,
            //         decoration: BoxDecoration(
            //           color: AppColors.violet.withValues(alpha: 0.12),
            //           borderRadius: BorderRadius.circular(AppRadius.sm),
            //         ),
            //         child: Icon(
            //           themeMode == ThemeMode.dark
            //               ? Icons.dark_mode_rounded
            //               : Icons.light_mode_rounded,
            //           size: 19,
            //           color: AppColors.violetSoft,
            //         ),
            //       ),
            //       const SizedBox(width: AppSpacing.md),
            //       Expanded(
            //         child: Text(
            //           themeMode == ThemeMode.dark
            //               ? 'الوضع الداكن'
            //               : 'الوضع الفاتح',
            //           style: Theme.of(context).textTheme.titleMedium,
            //         ),
            //       ),
            //       Switch(
            //         value: themeMode == ThemeMode.light,
            //         onChanged: (_) =>
            //             ref.read(themeModeProvider.notifier).toggle(),
            //         activeColor: AppColors.violet,
            //         inactiveThumbColor: AppColors.violetSoft,
            //         inactiveTrackColor:
            //             AppColors.violet.withValues(alpha: 0.2),
            //       ),
            //     ],
            //   ),
            // ).animate().fadeIn(delay: 580.ms),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final monthKey = 'month_${date.month}';
    return '${context.tr(monthKey)} ${date.year}';
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.violet.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(
              Icons.language_rounded,
              size: 19,
              color: AppColors.violetSoft,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              context.tr('language'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(localeProvider.notifier).toggle(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _langOption(context, context.tr('language_arabic'), isArabic),
                  _langOption(
                      context, context.tr('language_english'), !isArabic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _langOption(BuildContext context, String label, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppColors.violet : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: active ? AppColors.textPrimary : AppColors.textTertiary,
            ),
      ),
    );
  }
}



void _showGenderSheet(BuildContext context, WidgetRef ref, String current) {
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
                child: _SheetOption(
                  icon: Icons.man_rounded,
                  label: context.tr('gender_male'),
                  isSelected: current == 'male',
                  onTap: () async {
                    await ref
                        .read(preferencesLocalSourceProvider)
                        .save(
                          gender: 'male',
                          defaultCategory:
                              ref.read(defaultCategoryProvider),
                        );
                    ref.read(userGenderProvider.notifier).state = 'male';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SheetOption(
                  icon: Icons.woman_rounded,
                  label: context.tr('gender_female'),
                  isSelected: current == 'female',
                  onTap: () async {
                    await ref
                        .read(preferencesLocalSourceProvider)
                        .save(
                          gender: 'female',
                          defaultCategory:
                              ref.read(defaultCategoryProvider),
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

void _showCategorySheet(
    BuildContext context, WidgetRef ref, String current) {
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
                child: _SheetOption(
                  icon: Icons.checkroom_rounded,
                  label: context.tr('category_tops'),
                  isSelected: current == 'tops',
                  onTap: () async {
                    await ref
                        .read(preferencesLocalSourceProvider)
                        .save(
                          gender: ref.read(userGenderProvider),
                          defaultCategory: 'tops',
                        );
                    ref.read(defaultCategoryProvider.notifier).state =
                        'tops';
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _SheetOption(
                  icon: Icons.accessibility_new_rounded,
                  label: context.tr('category_bottoms'),
                  isSelected: current == 'bottoms',
                  onTap: () async {
                    await ref
                        .read(preferencesLocalSourceProvider)
                        .save(
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
                child: _SheetOption(
                  icon: Icons.dry_cleaning_rounded,
                  label: context.tr('category_one_pieces'),
                  isSelected: current == 'one-pieces',
                  onTap: () async {
                    await ref
                        .read(preferencesLocalSourceProvider)
                        .save(
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


class _EditableTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _EditableTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.inkElevated,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 19, color: AppColors.primarySoft),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.edit_rounded,
                  size: 16, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.inkElevatedHigh,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.white : AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color:
                        isSelected ? Colors.white : AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}