import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/features/history/presentation/widgets/filter_tab.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../application/history_providers.dart';
import '../widgets/history_grid_tile.dart';
import '../../../../core/localization/app_strings.dart';

enum _HistoryFilter { all, favorites }

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(title: Text(context.tr('history_title'))),
      body: historyAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.violet),
        ),
        error: (error, _) => ErrorStateView(
          message: context.tr('history_fetch_error'),
          onRetry: () => ref.invalidate(historyProvider),
        ),
        data: (allItems) {
          final items = _filter == _HistoryFilter.favorites
              ? allItems.where((item) => item.isFavorite).toList()
              : allItems;

          return Column(
            children: [
              // فلتر الكل/المفضلة
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.sm,
                  AppSpacing.screenPadding,
                  0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: AppColors.inkElevated,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      FilterTab(
                        label: context.tr('filter_all'),
                        icon: Icons.grid_view_rounded,
                        isSelected: _filter == _HistoryFilter.all,
                        onTap: () =>
                            setState(() => _filter = _HistoryFilter.all),
                      ),
                      FilterTab(
                        label: context.tr('filter_favorites'),
                        icon: Icons.favorite_rounded,
                        isSelected: _filter == _HistoryFilter.favorites,
                        onTap: () => setState(
                            () => _filter = _HistoryFilter.favorites),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: items.isEmpty
                    ? EmptyStateView(
                        icon: _filter == _HistoryFilter.favorites
                            ? Icons.favorite_border_rounded
                            : Icons.history_rounded,
                        title: _filter == _HistoryFilter.favorites
                            ? context.tr('favorites_empty_title')
                            : context.tr('history_empty_title'),
                        subtitle: _filter == _HistoryFilter.favorites
                            ? context.tr('favorites_empty_subtitle')
                            : context.tr('history_empty_subtitle'),
                        actionLabel: _filter == _HistoryFilter.favorites
                            ? null
                            : context.tr('capture_first_shirt'),
                        onAction: _filter == _HistoryFilter.favorites
                            ? null
                            : () => context.push(AppRoutes.captureGarment),
                      )
                    : AnimationLimiter(
                        child: GridView.builder(
                          padding:
                              const EdgeInsets.all(AppSpacing.screenPadding),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.sm,
                            crossAxisSpacing: AppSpacing.sm,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: HistoryGridTile(
                                    result: item,
                                    onTap: () => context
                                        .push(AppRoutes.result, extra: item),
                                    onDelete: () => ref
                                        .read(historyActionsProvider.notifier)
                                        .deleteItem(item.id),
                                    onToggleFavorite: () => ref
                                        .read(historyActionsProvider.notifier)
                                        .toggleFavorite(
                                            item.id, item.isFavorite),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

