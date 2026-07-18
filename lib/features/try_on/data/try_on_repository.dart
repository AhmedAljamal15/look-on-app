import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/try_on_ai_service.dart';
import '../domain/try_on_result.dart';

/// Orchestrates a full try-on generation:
/// 1. Upload the garment photo to Storage.
/// 2. Call the AI Cloud Function with (personImageUrl, garmentImageUrl).
/// 3. Save the resulting [TryOnResult] to Firestore history.
class TryOnRepository {
  final FirebaseFirestore _firestore;
  final StorageService _storageService;
  final TryOnAiService _aiService;

  TryOnRepository({
    FirebaseFirestore? firestore,
    required StorageService storageService,
    required TryOnAiService aiService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storageService = storageService,
        _aiService = aiService;

  CollectionReference<Map<String, dynamic>> _historyCollection(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.tryOnHistoryCollection);
  }

  Future<Either<Failure, TryOnResult>> generateTryOn({
    required String uid,
    required String personImageUrl,
    required File garmentImageFile,
    String category = 'tops',
    String gender = 'male', // ← جديد
  }) async {
    try {
      final garmentImageUrl = await _storageService.uploadImage(
        file: garmentImageFile,
        basePath: AppConstants.garmentPhotosStoragePath,
        uid: uid,
      );

      final resultImageUrl = await _aiService.generateTryOn(
        personImageUrl: personImageUrl,
        garmentImageUrl: garmentImageUrl,
        category: category,
        gender: gender, // ← جديد
      );

      final docRef = _historyCollection(uid).doc();
      final result = TryOnResult(
        id: docRef.id,
        personImageUrl: personImageUrl,
        garmentImageUrl: garmentImageUrl,
        resultImageUrl: resultImageUrl,
        createdAt: DateTime.now(),
      );
      await docRef.set(result.toMap());

      return Right(result);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } on TryOnGenerationException catch (e) {
      return Left(TryOnGenerationFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
