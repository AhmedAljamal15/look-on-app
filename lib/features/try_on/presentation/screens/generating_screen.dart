import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../application/try_on_providers.dart';
import '../../../../core/localization/app_strings.dart';

class GeneratingScreen extends ConsumerStatefulWidget {
  final File garmentImageFile;
  final String garmentCategory; // ← جديد

  const GeneratingScreen({
    super.key,
    required this.garmentImageFile,
    this.garmentCategory = 'tops', // ← default value
  });

  @override
  ConsumerState<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends ConsumerState<GeneratingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
  await ref
      .read(tryOnGenerationProvider.notifier)
      .generate(
        widget.garmentImageFile,
        category: widget.garmentCategory, // ← جديد
      );

  final state = ref.read(tryOnGenerationProvider);
  if (state.hasValue && state.value != null && mounted) {
    context.pushReplacement(AppRoutes.result, extra: state.value);
  }
}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tryOnGenerationProvider);

    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: state.when(
          data: (value) =>
              value == null ? const _GeneratingBody() : const SizedBox.shrink(),
          loading: () => const _GeneratingBody(),
          error: (error, _) => ErrorStateView(
            message: AppLocalizations.t(error.toString()),
            onRetry: () {
              ref.read(tryOnGenerationProvider.notifier).reset();
              _start();
            },
          ),
        ),
      ),
    );
  }
}

class _GeneratingBody extends StatefulWidget {
  const _GeneratingBody();

  @override
  State<_GeneratingBody> createState() => _GeneratingBodyState();
}

class _GeneratingBodyState extends State<_GeneratingBody> {
  Timer? _timer;
  int _seconds = 0;

  static const List<String> _messageKeys = [
    'generating_msg_1',
    'generating_msg_2',
    'generating_msg_3',
    'generating_msg_4',
    'generating_msg_5',
    'generating_msg_6',
    'generating_msg_7',
    'generating_msg_8',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _seconds = timer.tick;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _messageIndex => (_seconds ~/ 8).clamp(0, _messageKeys.length - 1);

  double get _progress => (_seconds / 120).clamp(0.0, 0.95);

  String _timeText(BuildContext context) {
    if (_seconds < 60) {
      return context.tr('generating_seconds').replaceAll('{n}', '$_seconds');
    }
    final mins = _seconds ~/ 60;
    final secs = _seconds % 60;
    final extra = secs > 0
        ? context.tr('generating_minutes_extra').replaceAll('{s}', '$secs')
        : '';
    return context
        .tr('generating_minutes')
        .replaceAll('{m}', '$mins')
        .replaceAll('{extra}', extra);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.violetGoldGradient,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1.05, 1.05),
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.05, 1.05),
                        end: const Offset(0.85, 0.85),
                        duration: 1200.ms,
                        curve: Curves.easeInOut,
                      ),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.ink,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                context.tr(_messageKeys[_messageIndex]),
                key: ValueKey(_messageIndex),
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.tr('generating_time_label').replaceAll('{time}', _timeText(context)),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: AppColors.divider,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.violet),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_seconds > 15)
              Text(
                context.tr('generating_ai_note'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(),
            if (_seconds > 60)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  context.tr('generating_slow_note'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
              ),
          ],
        ),
      ),
    );
  }
}
