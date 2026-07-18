import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// حقل من نقط بريق صغيرة بتلمع وتختفي بشكل عشوائي — قابلة لإعادة
/// الاستخدام في أي شاشة (السبلاش، الهوم، إلخ) خلف باقي الـ widgets.
class SparkleField extends StatefulWidget {
  final int count;
  final Color? color;

  const SparkleField({super.key, this.count = 10, this.color});

  @override
  State<SparkleField> createState() => _SparkleFieldState();
}

class _SparkleFieldState extends State<SparkleField> {
  final _random = Random();
  late final List<_SparkleData> _sparkles;

  @override
  void initState() {
    super.initState();
    _sparkles = List.generate(widget.count, (i) {
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
          child: _SingleSparkle(
            data: s,
            color: widget.color ?? AppColors.caramel,
          ),
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
  final Color color;

  const _SingleSparkle({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: data.size,
      height: data.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.5),
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

/// نص بتأثير Shimmer (لمعة بتعدي فوقه باستمرار) — قابل لإعادة الاستخدام.
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color baseColor;
  final Color shimmerColor;

  const ShimmerText({
    super.key,
    required this.text,
    this.style,
    this.baseColor = AppColors.ink,
    this.shimmerColor = AppColors.gold,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
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
              colors: [
                widget.baseColor,
                widget.shimmerColor,
                widget.baseColor,
              ],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: widget.style ??
                TextStyle(
                  fontWeight: FontWeight.w700,
                  color: widget.baseColor,
                ),
          ),
        );
      },
    );
  }
}