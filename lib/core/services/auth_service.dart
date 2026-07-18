import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../errors/exceptions.dart';

/// Wraps Firebase anonymous auth. The app never shows a sign-up/login screen —
/// every user gets a stable anonymous UID on first launch, persisted by
/// Firebase itself across app restarts on the same device/install. This is
/// the deliberate UX choice: zero friction between opening the app and using it.
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final Logger _logger;

  AuthService({
    FirebaseAuth? firebaseAuth,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _logger = logger ?? Logger();

  /// Current user, if any. Null only before the very first sign-in completes.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of auth state changes — used by the router to gate navigation
  /// until anonymous sign-in resolves.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Ensures a user is signed in. Call once at app startup. If a user
  /// already exists (returning user on same device), this is a no-op.
  Future<String> ensureSignedIn() async {
    try {
      final existing = _firebaseAuth.currentUser;
      if (existing != null) return existing.uid;

      final credential = await _firebaseAuth.signInAnonymously();
      final uid = credential.user?.uid;
      if (uid == null) {
        throw const AuthException('auth_session_create_failed');
      }
      _logger.i('Anonymous session created: $uid');
      return uid;
    } on FirebaseAuthException catch (e) {
      _logger.e('Anonymous sign-in failed', error: e);
      throw AuthException(e.message ?? 'auth_login_failed');
    } catch (e) {
      _logger.e('Unexpected auth error', error: e);
      throw const AuthException();
    }
  }

  String get uidOrThrow {
    final uid = currentUser?.uid;
    if (uid == null) {
      throw const AuthException('auth_no_user');
    }
    return uid;
  }
}
