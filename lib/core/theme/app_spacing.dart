/// Spacing scale (4pt base grid) — use these instead of magic numbers
/// so layout rhythm stays consistent across every screen.
abstract class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  static const double screenPadding = 20;
}

/// Corner-radius scale.
abstract class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}

/// Elevation / shadow tokens.
abstract class AppElevation {
  AppElevation._();

  static const double none = 0;
  static const double card = 2;
  static const double raised = 8;
  static const double modal = 16;
}
