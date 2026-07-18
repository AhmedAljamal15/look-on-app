import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:virtual_tryon_app/features/settings/presentation/widgets/settings_tile.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../profile_photo/application/profile_photo_providers.dart';
import '../../../../core/localization/app_strings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasProfilePhoto = ref.watch(activeProfilePhotoProvider).value != null;

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(title: Text(context.tr('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          SettingsTile(
            icon: Icons.person_outline_rounded,
            title: hasProfilePhoto ? context.tr('change_profile_photo') : context.tr('add_profile_photo'),
            onTap: () => context.push(AppRoutes.captureProfile),
          ),
          const SizedBox(height: AppSpacing.sm),
          SettingsTile(
            icon: Icons.history_rounded,
            title: context.tr('history_title'),
            onTap: () => context.push(AppRoutes.history),
          ),
          const SizedBox(height: AppSpacing.xl),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '';
              return Center(
                child: Text(
                  '${AppConstants.appName} ${version.isNotEmpty ? "v$version" : ""}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


