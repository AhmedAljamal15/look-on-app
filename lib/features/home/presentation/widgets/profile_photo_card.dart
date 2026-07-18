import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/localization/app_strings.dart';

/// Shows the user's saved profile photo status at the top of Home.
/// When no photo exists yet, this becomes the entry point that nudges
/// the user to take one before they can try anything on.
class ProfilePhotoCard extends StatelessWidget {
  final bool hasPhoto;
  final String? photoUrl;
  final bool isLoading;

  const ProfilePhotoCard({
    super.key,
    required this.hasPhoto,
    this.photoUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.inkElevated,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: SizedBox(
              width: 52,
              height: 52,
              child: isLoading
                  ? Container(color: AppColors.divider)
                  : (hasPhoto && photoUrl != null)
                      ? CachedNetworkImage(
                          imageUrl: photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: AppColors.divider),
                        )
                      : Container(
                          color: AppColors.divider,
                          child: const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.textTertiary,
                          ),
                        ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPhoto ? context.tr('photo_ready') : context.tr('need_photo_first'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  hasPhoto
                      ? context.tr('photo_usage_ready')
                      : context.tr('photo_usage_once'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            hasPhoto
                ? Icons.check_circle_rounded
                : Icons.arrow_forward_ios_rounded,
            color: hasPhoto ? AppColors.success : AppColors.textTertiary,
            size: hasPhoto ? 22 : 16,
          ),
        ],
      ),
    );
  }
}
