import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:virtual_tryon_app/features/result/presentation/widgets/circle_icon_button.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../history/application/history_providers.dart';
import '../../../try_on/domain/try_on_result.dart';
import '../../../../core/localization/app_strings.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final TryOnResult result;

  const ResultScreen({super.key, required this.result});

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.result.isFavorite;
  }

  void _toggleFavorite() {
    final newValue = !_isFavorite;
    setState(() => _isFavorite = newValue);
    ref
        .read(historyActionsProvider.notifier)
        .toggleFavorite(widget.result.id, newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.result.resultImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: AppColors.violet),
              ),
              errorWidget: (context, url, error) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.broken_image_outlined,
                        color: AppColors.error, size: 48),
                    const SizedBox(height: 12),
                    Text(context.tr('image_load_error'),
                        style: const TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text(
                      url,
                      style: const TextStyle(
                          color: AppColors.textTertiary, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            // الأزرار فوق
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleIconButton(
                        icon: Icons.close_rounded,
                        onTap: () => context.go(AppRoutes.home),
                      ),
                      Row(
                        children: [
                          // زرار المفضلة — أنيميشن نبضة عند الضغط
                          CircleIconButton(
                            icon: _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            iconColor: _isFavorite
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            onTap: _toggleFavorite,
                          )
                              .animate(target: _isFavorite ? 1 : 0)
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.15, 1.15),
                                duration: 150.ms,
                                curve: Curves.easeOut,
                              )
                              .then()
                              .scale(
                                begin: const Offset(1.15, 1.15),
                                end: const Offset(1, 1),
                                duration: 150.ms,
                              ),
                          const SizedBox(width: AppSpacing.sm),
                          CircleIconButton(
                            icon: Icons.share_outlined,
                            onTap: () => SharePlus.instance.share(
                              ShareParams(
                                text: context.tr('share_message').replaceAll(
                                    '{url}', widget.result.resultImageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // الأزرار تحت
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                decoration: const BoxDecoration(
                  gradient: AppColors.inkFade,
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push(AppRoutes.captureGarment),
                          icon: const Icon(Icons.camera_alt_rounded),
                          label: Text(context.tr('another_shirt')),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.go(AppRoutes.home),
                          child: Text(context.tr('done')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
