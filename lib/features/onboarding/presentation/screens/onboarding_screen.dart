import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/onboarding_local_source.dart';
import '../widgets/onboarding_page.dart';
import '../../../../core/localization/app_strings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static List<OnboardingPageData> _pages(BuildContext context) => [
        OnboardingPageData(
          icon: Icons.checkroom_rounded,
          title: context.tr('onboard_1_title'),
          subtitle: context.tr('onboard_1_subtitle'),
        ),
        OnboardingPageData(
          icon: Icons.auto_awesome_rounded,
          title: context.tr('onboard_2_title'),
          subtitle: context.tr('onboard_2_subtitle'),
        ),
        OnboardingPageData(
          icon: Icons.bolt_rounded,
          title: context.tr('onboard_3_title'),
          subtitle: context.tr('onboard_3_subtitle'),
        ),
      ];

  Future<void> _finish() async {
    await ref.read(onboardingLocalSourceProvider).markComplete();
    ref.read(onboardingCompleteProvider.notifier).state = true;
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages(context);
    final isLast = _page == pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(context.tr('skip')),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => OnboardingPage(data: pages[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page ? AppColors.violet : AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(isLast ? context.tr('lets_start') : context.tr('next')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
