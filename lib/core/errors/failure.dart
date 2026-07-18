import 'package:equatable/equatable.dart';

/// Base failure type. All repository methods return `Either<Failure, T>`
/// (via fpdart) instead of throwing, so the UI layer always handles errors
/// explicitly rather than relying on try/catch scattered through widgets.
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'network_failure']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'server_failure']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'auth_failure_msg']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'storage_failure_msg']);
}

class ImageProcessingFailure extends Failure {
  const ImageProcessingFailure([super.message = 'image_unclear_error']);
}

class TryOnGenerationFailure extends Failure {
  const TryOnGenerationFailure([super.message = 'tryon_gen_failure']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'permission_failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'cache_failure']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'unknown_failure']);
}
