import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../try_on/domain/try_on_result.dart';
import '../../../../core/localization/app_strings.dart';

class RecentHistoryStrip extends StatelessWidget {
  final List<TryOnResult> items;
  final bool isLoading;

  const RecentHistoryStrip({
    super.key,
    required this.items,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 120,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: AppColors.inkElevated,
            highlightColor: AppColors.inkElevatedHigh,
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.inkElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.inkElevated,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          context.tr('recent_history_empty'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.result, extra: item),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: CachedNetworkImage(
                imageUrl: item.resultImageUrl,
                width: 100,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 100,
                  color: AppColors.inkElevated,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
