import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/features/onboarding/data/welcome_local_source.dart';
import 'package:virtual_tryon_app/features/onboarding/presentation/widgets/welcome_dialog.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../history/application/history_providers.dart';
import '../../../profile_photo/application/profile_photo_providers.dart';
import '../widgets/profile_photo_card.dart';
import '../widgets/recent_history_strip.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/sparkle_field.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomeIfNeeded());
  }

  void _showWelcomeIfNeeded() {
    if (_dialogShown) return;
    final welcomeAccepted = ref.read(welcomeAcceptedProvider);
    if (!welcomeAccepted && mounted) {
      _dialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (_) => const WelcomeDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profilePhotoAsync = ref.watch(activeProfilePhotoProvider);
    final historyAsync = ref.watch(historyProvider);
    final hasProfilePhoto = profilePhotoAsync.value != null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ---------- الخلفية ----------
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.appBackgroundGradient,
            ),
          ),

          Positioned(
            top: -100,
            right: -80,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryGlow,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // نقط البريق — خلف كل المحتوى، ملء الشاشة كلها
          const Positioned.fill(
            child: IgnorePointer(
              child: SparkleField(count: 14),
            ),
          ),

          // ---------- المحتوى ----------
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.violet,
              backgroundColor: AppColors.inkElevated,
              onRefresh: () async {
                ref.invalidate(activeProfilePhotoProvider);
                ref.invalidate(historyProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(child: AppLogo()),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.profile),
                          child: Container(
                            width: 36,
                            height: 36,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              gradient: AppColors.violetGoldGradient,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.inkElevated,
                                shape: BoxShape.circle,
                              ),
                              child: hasProfilePhoto &&
                                      profilePhotoAsync.value != null
                                  ? ClipOval(
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              profilePhotoAsync.value!.imageUrl,
                                          width: 32,
                                          height: 32,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          fadeInDuration:
                                              const Duration(milliseconds: 200),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: AppColors.inkElevated,
                                            child: const Icon(
                                              Icons.person_outline_rounded,
                                              size: 18,
                                              color: AppColors.textTertiary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.person_outline_rounded,
                                      size: 18,
                                      color: AppColors.textTertiary,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppConstants.appTagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ProfilePhotoCard(
                    hasPhoto: hasProfilePhoto,
                    photoUrl: profilePhotoAsync.value?.imageUrl,
                    isLoading: profilePhotoAsync.isLoading,
                  ).animate().fadeIn().slideY(begin: 0.05, end: 0),
                  const SizedBox(height: AppSpacing.lg),
                  GestureDetector(
                    onTap: hasProfilePhoto
                        ? () => context.push(AppRoutes.captureGarment)
                        : () => context.push(AppRoutes.captureProfile),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: AppColors.coralGradient,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.ink.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.ink,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // النص بتاع "صوّر قميص دلوقتي" بتأثير Shimmer
                                ShimmerText(
                                  text: context.tr('capture_now_title'),
                                  baseColor: AppColors.espresso,
                                  shimmerColor: Colors.white,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: AppColors.espresso,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.tr('capture_now_subtitle'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.ink
                                            .withValues(alpha: 0.75),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.ink.withValues(alpha: 0.6),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('recent_attempts'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutes.history),
                        child: Text(context.tr('view_all')),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  RecentHistoryStrip(
                    items: historyAsync.value ?? [],
                    isLoading: historyAsync.isLoading,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
