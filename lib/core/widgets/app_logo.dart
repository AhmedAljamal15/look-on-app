import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// The "LookOn" wordmark, styled like a logo rather than plain body text.
/// Always rendered left-to-right and centered on screen so it never moves
/// or flips when the app switches between Arabic and English — a logo
/// should stay put regardless of the reading direction around it.
///
/// Renders a continuous shimmer sweep across the gradient text to give
/// the brand mark a subtle "alive" feel wherever it appears (Home header,
/// Splash screen).
class AppLogo extends StatefulWidget {
  final double fontSize;
  final bool shimmer;

  const AppLogo({super.key, this.fontSize = 45, this.shimmer = true});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.shimmer) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      'LookOn',
      style: GoogleFonts.dancingScript(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        height: 1,
      ),
    );

    Widget shaderChild = text;

    if (widget.shimmer && _controller != null) {
      shaderChild = AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) {
          final shimmerPos = _controller!.value * 2.5 - 0.75;
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1 + shimmerPos, 0),
                end: Alignment(1 + shimmerPos, 0),
                colors: const [
                  AppColors.violet,
                  Colors.white,
                  AppColors.gold,
                  Colors.white,
                  AppColors.violet,
                ],
                stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
              ).createShader(bounds);
            },
            child: text,
          );
        },
      );
    } else {
      shaderChild = ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.violetGoldGradient.createShader(bounds),
        child: text,
      );
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: shaderChild,
    );
  }
}