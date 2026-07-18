import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failure.dart';
import '../../try_on/domain/try_on_result.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore;

  HistoryRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.tryOnHistoryCollection);
  }

  Stream<List<TryOnResult>> watchHistory(String uid) {
    return _collection(uid)
        .orderBy('createdAtMillis', descending: true)
        .limit(AppConstants.maxHistoryItemsPerPage)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => TryOnResult.fromMap(d.id, d.data()))
            .toList());
  }

  Future<Either<Failure, Unit>> toggleFavorite({
    required String uid,
    required String resultId,
    required bool isFavorite,
  }) async {
    try {
      await _collection(uid).doc(resultId).update({
        'isFavorite': isFavorite,
      });
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  Future<Either<Failure, Unit>> deleteHistoryItem({
    required String uid,
    required String resultId,
  }) async {
    try {
      await _collection(uid).doc(resultId).delete();
      return const Right(unit);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}