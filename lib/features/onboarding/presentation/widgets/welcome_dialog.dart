import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/welcome_local_source.dart';
import '../../../../core/localization/app_strings.dart';

/// A one-time welcome overlay shown on top of Home: explains what the app
/// does and requires explicit terms/privacy acceptance (needed since the
/// user will be uploading personal photos) before the "موافق" button
/// activates. On accept, briefly shows a celebratory "enjoy the app"
/// animation before dismissing.
class WelcomeDialog extends ConsumerStatefulWidget {
  const WelcomeDialog({super.key});

  @override
  ConsumerState<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends ConsumerState<WelcomeDialog> {
  bool _agreed = false;
  bool _showCelebration = false;

  Future<void> _accept() async {
    await ref.read(welcomeLocalSourceProvider).markAccepted();
    ref.read(welcomeAcceptedProvider.notifier).state = true;

    setState(() => _showCelebration = true);

    // Let the celebration animation play, then close the overlay and return
    // the user to the Home route.
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();
    if (context.mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      // Block back-button dismissal until terms are accepted — this is a
      // required acknowledgment, not a dismissible tip.
      canPop: _agreed,
      child: Material(
        color: (isDark ? AppColors.ink : AppColors.lightBg)
            .withValues(alpha: 0.92),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _showCelebration
                ? const _CelebrationView(key: ValueKey('celebration'))
                : _WelcomeCard(
                    key: const ValueKey('welcome'),
                    agreed: _agreed,
                    onAgreedChanged: (v) => setState(() => _agreed = v),
                    onAccept: _agreed ? _accept : null,
                  ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback? onAccept;

  const _WelcomeCard({
    super.key,
    required this.agreed,
    required this.onAgreedChanged,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.inkElevated : AppColors.lightSurface;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.violet.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.18),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Gradient icon badge
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                gradient: AppColors.violetGoldGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ).animate().scale(
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            context.tr('welcome_to').replaceAll('{appName}', AppConstants.appName),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ).animate().fadeIn(delay: 120.ms),

          const SizedBox(height: AppSpacing.xs),

          Text(
            context.tr('welcome_body'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ).animate().fadeIn(delay: 180.ms),

          const SizedBox(height: AppSpacing.lg),

          // Quick feature bullets
          ..._features(context).asMap().entries.map((entry) {
            final i = entry.key;
            final (icon, text) = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.violet.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, size: 15, color: AppColors.violetSoft),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(text, style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (220 + i * 60).ms).slideX(
                  begin: 0.05,
                  end: 0,
                );
          }),

          const SizedBox(height: AppSpacing.md),
          Divider(color: theme.dividerTheme.color),
          const SizedBox(height: AppSpacing.sm),

          // Terms checkbox
          InkWell(
            onTap: () => onAgreedChanged(!agreed),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                      gradient: agreed ? AppColors.violetGoldGradient : null,
                      color: agreed
                          ? null
                          : (isDark
                              ? AppColors.inkElevatedHigh
                              : AppColors.lightBg),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: agreed ? Colors.transparent : AppColors.border,
                        width: 1.4,
                      ),
                    ),
                    child: agreed
                        ? const Icon(Icons.check_rounded,
                            size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      context.tr('consent_text'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: 480.ms),

          const SizedBox(height: AppSpacing.md),

          // Accept button — gated by checkbox
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: agreed ? 1 : 0.45,
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: agreed ? AppColors.violetGoldGradient : null,
                  color: agreed ? null : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: agreed
                      ? [
                          BoxShadow(
                            color: AppColors.violet.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAccept,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          context.tr('agree'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: 540.ms),
        ],
      ),
    );
  }

  static List<(IconData, String)> _features(BuildContext context) => [
        (Icons.camera_alt_rounded, context.tr('welcome_bullet_1')),
        (Icons.auto_awesome_rounded, context.tr('welcome_bullet_2')),
        (Icons.history_rounded, context.tr('welcome_bullet_3')),
      ];
}

class _CelebrationView extends StatelessWidget {
  const _CelebrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            gradient: AppColors.violetGoldGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.celebration_rounded,
            color: Colors.white,
            size: 44,
          ),
        )
            .animate()
            .scale(duration: 500.ms, curve: Curves.easeOutBack)
            .then()
            .shake(duration: 400.ms, hz: 3, rotation: 0.04),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.tr('lets_go'),
          style: theme.textTheme.headlineSmall,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppSpacing.xs),
        Text(
          context.tr('enjoy_app'),
          style: theme.textTheme.bodyMedium,
        ).animate().fadeIn(delay: 320.ms),
      ],
    );
  }
}
