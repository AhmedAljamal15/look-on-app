/// Exceptions are thrown by data sources (Firebase SDKs, Dio, etc.) and
/// caught by repositories, which convert them into [Failure]s for the
/// domain/application layer. Keeping exceptions and failures separate
/// avoids leaking infrastructure error types into the UI.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server error']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Auth error']);
}

class StorageException implements Exception {
  final String message;
  const StorageException([this.message = 'Storage error']);
}

class ImageProcessingException implements Exception {
  final String message;
  const ImageProcessingException([this.message = 'Image processing error']);
}

class TryOnGenerationException implements Exception {
  final String message;
  const TryOnGenerationException([this.message = 'Try-on generation error']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
}
