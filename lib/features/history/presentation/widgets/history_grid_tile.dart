import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../try_on/domain/try_on_result.dart';
import '../../../../core/localization/app_strings.dart';

class HistoryGridTile extends StatelessWidget {
  final TryOnResult result;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const HistoryGridTile({
    super.key,
    required this.result,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('delete_attempt_title')),
        content: Text(context.tr('delete_attempt_body')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(
              context.tr('delete'),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _confirmDelete(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: result.resultImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: AppColors.inkElevated,
                highlightColor: AppColors.inkElevatedHigh,
                child: Container(color: AppColors.inkElevated),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.inkElevated,
                child: const Icon(Icons.broken_image_outlined,
                    color: AppColors.textTertiary),
              ),
            ),

            // زرار الحذف (فوق يمين)
            Positioned(
              top: 6,
              right: 6,
              child: GestureDetector(
                onTap: () => _confirmDelete(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // زرار المفضلة (فوق شمال)
            Positioned(
              top: 6,
              left: 6,
              child: GestureDetector(
                onTap: onToggleFavorite,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.ink.withValues(alpha: 0.55),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    result.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: result.isFavorite
                        ? AppColors.primary
                        : AppColors.textPrimary,
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