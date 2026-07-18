/// Tracks whether the splash has already played in this cold-start session.
/// Uses a static variable so it resets on process kill but persists across
/// pause/resume — the user won't see the splash again if they quickly
/// switch apps and come back.
abstract class AppSession {
  AppSession._();

  static bool _splashShown = false;

  static bool get splashShown => _splashShown;

  static void markSplashShown() => _splashShown = true;
}