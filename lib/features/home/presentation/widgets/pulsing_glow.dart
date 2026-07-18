import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';

/// هالة نابضة بهدوء (breathing glow) خلف الكارت الرئيسي.
/// الحركة: تكبر وتصغر + شفافيتها تزيد وتقل بلطف، بدورة طويلة (4 ثواني)
/// عشان تدي إحساس "حيوية" من غير ما تلفت نظر المستخدم عن المحتوى.
class PulsingGlow extends StatefulWidget {
  const PulsingGlow({super.key});

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacity = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: child,
          ),
        );
      },
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: const RadialGradient(
            colors: [
              AppColors.secondaryGlow,
              AppColors.primaryGlow,
              Colors.transparent,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }
}