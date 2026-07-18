import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/image_service.dart';
import '../services/storage_service.dart';
import '../services/try_on_ai_service.dart';

/// Root dependency-injection providers for cross-cutting services.
/// Feature-level repository providers depend on these rather than
/// instantiating Firebase SDKs directly, which keeps repositories testable.

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

final tryOnAiServiceProvider =
    Provider<TryOnAiService>((ref) => TryOnAiService());

final imageServiceProvider = Provider<ImageService>((ref) => ImageService());

/// Emits the current Firebase UID once anonymous sign-in resolves.
/// The router and most repository providers depend on this.
final authStateProvider = StreamProvider<String?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges.map((user) => user?.uid);
});
