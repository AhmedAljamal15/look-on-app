import 'package:flutter/material.dart';
import 'package:virtual_tryon_app/core/theme/app_colors.dart';

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.ink.withValues(alpha: 0.55),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}