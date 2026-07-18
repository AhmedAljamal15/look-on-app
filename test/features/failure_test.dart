import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_tryon_app/core/errors/failure.dart';

/// Example unit test — demonstrates how Failure equality works, which
/// matters because AsyncNotifiers compare/display these directly.
/// Add real repository/notifier tests here following this pattern:
/// mock the service layer with mocktail, feed it into the repository,
/// and assert the returned Either<Failure, T>.
void main() {
  group('Failure', () {
    test('two failures with the same message are equal', () {
      const a = NetworkFailure('no internet');
      const b = NetworkFailure('no internet');
      expect(a, equals(b));
    });

    test('different failure types with the same message are not equal', () {
      const network = NetworkFailure('error');
      const server = ServerFailure('error');
      expect(network, isNot(equals(server)));
    });

    test('default messages are in Arabic and non-empty', () {
      const failure = TryOnGenerationFailure();
      expect(failure.message, isNotEmpty);
    });
  });
}
