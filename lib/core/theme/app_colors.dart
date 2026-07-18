import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  // ---------- Coffee Cream Palette ----------
  static const Color cream = Color(0xFFF7EFE3);
  static const Color warmCream = Color(0xFFFFF8ED);
  static const Color beige = Color(0xFFEBD8C4);
  static const Color softBeige = Color(0xFFF2E4D3);

  static const Color coffee = Color(0xFF4A2B22);
  static const Color espresso = Color(0xFF241411);
  static const Color mocha = Color(0xFF7A5141);

  static const Color caramel = Color(0xFFD98863);
  static const Color caramelSoft = Color(0xFFE7A07B);
  static const Color caramelDeep = Color(0xFFB86648);
  static const Color caramelGlow = Color(0x33D98863);

  // ---------- Base surfaces ----------
  static const Color ink = cream;
  static const Color inkElevated = warmCream;
  static const Color inkElevatedHigh = softBeige;

  // ---------- Primary accent ----------
  static const Color primary = caramel;
  static const Color primarySoft = caramelSoft;
  static const Color primaryDeep = caramelDeep;
  static const Color primaryGlow = caramelGlow;

  // ---------- Card surface ----------
  static const Color cardLight = warmCream;
  static const Color cardLightBg = softBeige;

  // ---------- Text ----------
  static const Color textPrimary = espresso;
  static const Color textSecondary = Color(0xFF7A6254);
  static const Color textTertiary = Color(0xFFB49A87);

  static const Color textDark = espresso;
  static const Color textDarkSecondary = Color(0xFF7A6254);

  // ---------- Borders & dividers ----------
  static const Color divider = Color(0xFFE3D2BE);
  static const Color border = Color(0xFFDCC7B2);

  // ---------- Semantic ----------
  static const Color success = Color(0xFF2FA86B);
  static const Color warning = Color(0xFFE2A23A);
  static const Color error = Color(0xFFD84A3A);
  static const Color info = Color(0xFF4D94B8);

  // ---------- Light mode ----------
  static const Color lightBg = cream;
  static const Color lightSurface = warmCream;
  static const Color lightTextPrimary = espresso;
  static const Color lightTextSecondary = Color(0xFF7A6254);

  // ---------- Gradients ----------
  static const LinearGradient appBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF8ED),
      Color(0xFFF7EFE3),
      Color(0xFFEBD8C4),
    ],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE7A07B),
      Color(0xFFD98863),
      Color(0xFFB86648),
    ],
  );

  static const LinearGradient softPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF3E6),
      Color(0xFFEBD8C4),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF8ED),
      Color(0xFFF2E4D3),
    ],
  );

  static const LinearGradient inkFade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      cream,
    ],
  );

  static const LinearGradient inkFadeDeep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0xE6F7EFE3),
    ],
  );

  // ---------- Legacy aliases ----------
  static const Color violetMain = caramel;
  static const Color violetSoft = caramelSoft;
  static const Color violetDeep = caramelDeep;
  static const Color violetGlow = caramelGlow;

  static const Color violet = caramel;
  static const Color rose = caramel;
  static const Color roseSoft = caramelSoft;
  static const Color coral = caramel;
  static const Color coralSoft = caramelSoft;
  static const Color coralDeep = caramelDeep;

  static const Color gold = caramel;
  static const Color goldSoft = caramelSoft;
  static const Color goldDeep = caramelDeep;
  static const Color secondaryGlow = caramelGlow;

  static const Color creamMuted = textSecondary;

  static const LinearGradient coralGradient = primaryGradient;
  static const LinearGradient goldGradient = primaryGradient;
  static const LinearGradient violetGoldGradient = primaryGradient;
  static const LinearGradient scanGradient = primaryGradient;
}
