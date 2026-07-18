import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:virtual_tryon_app/core/widgets/app_logo.dart';

import '../../features/onboarding/data/onboarding_local_source.dart';
import '../providers/core_providers.dart';
import '../router/app_routes.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';
import '../utils/app_session.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  static const Duration _minSplashDuration = Duration(milliseconds: 7000);
  static const Duration _maxSplashDuration = Duration(seconds: 8);

  Timer? _safetyTimer;
  bool _minTimeElapsed = false;
  bool _authReady = false;
  bool _navigated = false;
  String? _error;

  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    if (AppSession.splashShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _skipToNext());
      return;
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.cream,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _signIn());

    Timer(_minSplashDuration, () {
      if (!mounted) return;
      _minTimeElapsed = true;
      _goNextIfReady();
    });

    _safetyTimer = Timer(_maxSplashDuration, () {
      _minTimeElapsed = true;
      _goNextIfReady();
    });
  }

  Future<void> _signIn() async {
    try {
      await ref.read(authServiceProvider).ensureSignedIn();
      if (!mounted) return;
      setState(() {
        _authReady = true;
        _error = null;
      });
      _goNextIfReady();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _authReady = false;
        _error = AppLocalizations.t('splash_session_error');
      });
    }
  }

  Future<void> _skipToNext() async {
    try {
      await ref.read(authServiceProvider).ensureSignedIn();
    } catch (_) {}
    if (!mounted) return;
    final onboardingComplete = ref.read(onboardingCompleteProvider);
    context.go(onboardingComplete ? AppRoutes.home : AppRoutes.onboarding);
  }

  void _goNextIfReady() {
    if (!mounted || _navigated || !_authReady || !_minTimeElapsed) return;

    _navigated = true;
    _safetyTimer?.cancel();
    AppSession.markSplashShown();

    final onboardingComplete = ref.read(onboardingCompleteProvider);
    context.go(onboardingComplete ? AppRoutes.home : AppRoutes.onboarding);
  }

  Future<void> _retry() async {
    setState(() {
      _error = null;
      _authReady = false;
    });
    await _signIn();
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── خلفية gradient متحركة بهدوء ──
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + _bgController.value * 0.4, -1),
                    end: Alignment(1, 1 - _bgController.value * 0.4),
                    colors: const [
                      Color(0xFFFFF8ED),
                      Color(0xFFF7EFE3),
                      Color(0xFFEBD8C4),
                      Color(0xFFE7C4A8),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── أشكال هندسية عائمة في الخلفية ──
          const _FloatingShape(
            top: 90,
            left: -40,
            size: 140,
            opacity: 0.10,
            delay: 0,
          ),
          const _FloatingShape(
            top: 260,
            right: -60,
            size: 180,
            opacity: 0.08,
            delay: 800,
          ),
          const _FloatingShape(
            bottom: 140,
            left: -30,
            size: 110,
            opacity: 0.12,
            delay: 400,
          ),
          const _FloatingShape(
            bottom: 40,
            right: -20,
            size: 90,
            opacity: 0.09,
            delay: 1200,
          ),

          // ── particles بريق متناثرة ──
          const _SparkleField(),

          // ── المحتوى الرئيسي ──
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // اللوجو مع حلقات نابضة + دخول قوي
                _PulsingLogo().animate().scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 28),

                // اسم التطبيق بـ shimmer
                const AppLogo(
                  fontSize: 42,
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                      begin: 0.5,
                      end: 0,
                      delay: 300.ms,
                      duration: 600.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 10),

                Text(
                  context.tr('splash_tagline'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                ).animate().fadeIn(delay: 650.ms, duration: 500.ms),

                const SizedBox(height: 36),

                // نقاط تحميل نابضة أنيقة بدل الشريط
                const _LoadingDots()
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 400.ms),
              ],
            ),
          ),

          // ── رسالة الخطأ ──
          if (_error != null)
            Positioned(
              left: 24,
              right: 24,
              bottom: 56,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.warmCream.withValues(alpha: 0.97),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.coffee.withValues(alpha: 0.15),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: _retry,
                      child: Text(AppLocalizations.t('retry')),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
            ),
        ],
      ),
    );
  }
}

class _PulsingLogo extends StatefulWidget {
  @override
  State<_PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<_PulsingLogo>
    with TickerProviderStateMixin {
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // حلقتين نابضتين بتوسعوا وتختفوا بالتتابع
          ..._buildPulsingRings(),

          // اللوجو الأساسي
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Color(0x50D98863),
                  blurRadius: 36,
                  offset: Offset(0, 14),
                ),
                BoxShadow(
                  color: Color(0x30B86648),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.checkroom_rounded,
              color: Colors.white,
              size: 46,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.05, 1.05),
                duration: 1400.ms,
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }

  List<Widget> _buildPulsingRings() {
    return List.generate(2, (i) {
      return AnimatedBuilder(
        animation: _ringController,
        builder: (context, child) {
          final progress = (_ringController.value + (i * 0.5)) % 1.0;
          final scale = 0.55 + progress * 0.9;
          final opacity = (1 - progress).clamp(0.0, 1.0) * 0.35;

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════
// اسم التطبيق مع تأثير shimmer (لمعة بتعدي فوق الحروف)
// ═══════════════════════════════════════════════════════════
class _ShimmerText extends StatefulWidget {
  final String text;
  const _ShimmerText({required this.text});

  @override
  State<_ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<_ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final shimmerPos = _controller.value * 2.5 - 0.75;
            return LinearGradient(
              begin: Alignment(-1 + shimmerPos, 0),
              end: Alignment(1 + shimmerPos, 0),
              colors: const [
                AppColors.espresso,
                AppColors.caramel,
                AppColors.espresso,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: AppColors.espresso,
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// أشكال هندسية عائمة ببطء في الخلفية
// ═══════════════════════════════════════════════════════════
class _FloatingShape extends StatefulWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double size;
  final double opacity;
  final int delay;

  const _FloatingShape({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
    required this.opacity,
    required this.delay,
  });

  @override
  State<_FloatingShape> createState() => _FloatingShapeState();
}

class _FloatingShapeState extends State<_FloatingShape>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000 + widget.delay),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      bottom: widget.bottom,
      left: widget.left,
      right: widget.right,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final offset = sin(_controller.value * pi) * 18;
          return Transform.translate(
            offset: Offset(0, offset),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: widget.opacity),
                    AppColors.primary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// حقل من نقاط بريق صغيرة بتلمع بشكل عشوائي
// ═══════════════════════════════════════════════════════════
class _SparkleField extends StatefulWidget {
  const _SparkleField();

  @override
  State<_SparkleField> createState() => _SparkleFieldState();
}

class _SparkleFieldState extends State<_SparkleField> {
  final _random = Random();
  late final List<_SparkleData> _sparkles;

  @override
  void initState() {
    super.initState();
    _sparkles = List.generate(10, (i) {
      return _SparkleData(
        top: _random.nextDouble(),
        left: _random.nextDouble(),
        size: 3 + _random.nextDouble() * 4,
        delay: _random.nextInt(2000),
        duration: 1800 + _random.nextInt(1400),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: _sparkles.map((s) {
        return Positioned(
          top: s.top * screenSize.height,
          left: s.left * screenSize.width,
          child: _SingleSparkle(data: s),
        );
      }).toList(),
    );
  }
}

class _SparkleData {
  final double top;
  final double left;
  final double size;
  final int delay;
  final int duration;

  _SparkleData({
    required this.top,
    required this.left,
    required this.size,
    required this.delay,
    required this.duration,
  });
}

class _SingleSparkle extends StatelessWidget {
  final _SparkleData data;
  const _SingleSparkle({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: data.size,
      height: data.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.caramel.withValues(alpha: 0.5),
      ),
    )
        .animate(
          onPlay: (c) => c.repeat(reverse: true),
          delay: Duration(milliseconds: data.delay),
        )
        .fadeIn(duration: Duration(milliseconds: data.duration))
        .then()
        .fadeOut(duration: Duration(milliseconds: data.duration));
  }
}

// ═══════════════════════════════════════════════════════════
// نقاط تحميل أنيقة بدل شريط التحميل التقليدي
// ═══════════════════════════════════════════════════════════
class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (_controller.value - (i * 0.2)) % 1.0;
            final scale = 0.6 + (sin(phase * pi) * 0.5).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(
                  alpha: 0.4 + (scale * 0.6).clamp(0.0, 0.6),
                ),
              ),
              transform: Matrix4.identity()..scale(scale),
              transformAlignment: Alignment.center,
            );
          }),
        );
      },
    );
  }
}
