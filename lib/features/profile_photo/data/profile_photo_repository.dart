import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/storage_service.dart';
import '../domain/profile_photo.dart';

/// Persists the user's profile photo(s) to
/// `users/{uid}/profilePhotos/{photoId}` and mirrors the upload to
/// Firebase Storage. Only one photo is ever "active" — that's the one
/// sent to the AI as the person image.
class ProfilePhotoRepository {
  final FirebaseFirestore _firestore;
  final StorageService _storageService;

  ProfilePhotoRepository({
    FirebaseFirestore? firestore,
    required StorageService storageService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storageService = storageService;

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .collection(AppConstants.profilePhotosSubcollection);
  }

  /// Uploads [file] as the new active profile photo, deactivating any
  /// previous one. Returns the created [ProfilePhoto].
  Future<Either<Failure, ProfilePhoto>> saveProfilePhoto({
    required String uid,
    required File file,
  }) async {
    try {
      final imageUrl = await _storageService.uploadImage(
        file: file,
        basePath: AppConstants.profilePhotosStoragePath,
        uid: uid,
      );

      final batch = _firestore.batch();
      final col = _collection(uid);

      // Deactivate existing active photos.
      final existingActive =
          await col.where('isActive', isEqualTo: true).get();
      for (final doc in existingActive.docs) {
        batch.update(doc.reference, {'isActive': false});
      }

      final newDocRef = col.doc();
      final photo = ProfilePhoto(
        id: newDocRef.id,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        isActive: true,
      );
      batch.set(newDocRef, photo.toMap());

      await batch.commit();
      return Right(photo);
    } on StorageException catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  /// The currently active profile photo, or null if the user has never
  /// taken one.
  Future<Either<Failure, ProfilePhoto?>> getActiveProfilePhoto(
    String uid,
  ) async {
    try {
      final snap = await _collection(uid)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return const Right(null);
      final doc = snap.docs.first;
      return Right(ProfilePhoto.fromMap(doc.id, doc.data()));
    } catch (e) {
      return const Left(ServerFailure());
    }
  }

  Stream<ProfilePhoto?> watchActiveProfilePhoto(String uid) {
    return _collection(uid)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return ProfilePhoto.fromMap(doc.id, doc.data());
    });
  }
}
