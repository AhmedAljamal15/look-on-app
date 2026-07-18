/// Centralized, immutable app constants.
/// Keeping all magic numbers/strings here avoids drift across features.
abstract class AppConstants {
  AppConstants._();

  // ---------- App Info ----------
  static const String appName = 'LookOn';
  static const String appTagline = 'Try it on, before you try it on.';

  // ---------- Firestore Collections ----------
  static const String usersCollection = 'users';
  static const String tryOnHistoryCollection = 'tryOnHistory';
  static const String profilePhotosSubcollection = 'profilePhotos';

  // ---------- Firebase Storage Paths ----------
  static const String profilePhotosStoragePath = 'profile_photos';
  static const String garmentPhotosStoragePath = 'garment_photos';
  static const String resultPhotosStoragePath = 'try_on_results';
  
  // ---------- Cloud Function Names ----------
  static const String generateTryOnFunction = 'generateTryOn';

  // ---------- Local Storage Keys ----------
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String activeProfilePhotoIdKey = 'active_profile_photo_id';
  static const String themeMode = 'theme_mode_key';

  // ---------- Limits ----------
  static const int maxHistoryItemsPerPage = 20;
  static const int maxProfilePhotos = 5;
  static const int imageMaxWidth = 1280;
  static const int imageMaxHeight = 1280;
  static const int imageQuality = 85;

  // ---------- Timeouts ----------
  static const Duration apiTimeout = Duration(seconds: 90);
  static const Duration connectTimeout = Duration(seconds: 15);

  // ---------- Animation Durations ----------
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}
