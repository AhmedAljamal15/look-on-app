import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/app_strings.dart';
import '../providers/connectivity_provider.dart';
import '../theme/app_colors.dart';

/// A slim banner that slides down from the top of the screen whenever
/// the device loses internet connectivity, and slides back up the moment
/// it reconnects. Meant to be placed once at the app root (above the
/// router's page content) so it appears consistently across every screen.
class NoInternetBanner extends ConsumerWidget {
  const NoInternetBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStreamProvider);

    final isOffline = connectivityAsync.maybeWhen(
      data: (isConnected) => !isConnected,
      orElse: () => false,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1,
          child: child,
        );
      },
      child: isOffline
          ? Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  bottom: 10,
                  left: 16,
                  right: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('no_internet_banner'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 200.ms)
          : const SizedBox.shrink(key: ValueKey('online')),
    );
  }
}