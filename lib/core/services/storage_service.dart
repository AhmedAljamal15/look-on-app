import 'dart:io';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../errors/exceptions.dart' as app_exceptions;

class StorageService {
  final Logger _logger;
  final Uuid _uuid;

  StorageService({Logger? logger, Uuid? uuid})
      : _logger = logger ?? Logger(),
        _uuid = uuid ?? const Uuid();

  SupabaseClient get _client => Supabase.instance.client;

  Future<String> uploadImage({
    required File file,
    required String basePath,
    required String uid,
  }) async {
    try {
      final fileId = _uuid.v4();
      final filePath = '$basePath/$uid/$fileId.jpg';
      final bytes = await file.readAsBytes();

      await _client.storage
          .from('fitsnap-images')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      final publicUrl = _client.storage
          .from('fitsnap-images')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      _logger.e('Supabase Storage upload failed', error: e);
      throw app_exceptions.StorageException('storage_failure_msg');
    }
  }

  Future<void> deleteImage(String downloadUrl) async {
    try {
      final uri = Uri.parse(downloadUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('fitsnap-images');
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath =
            pathSegments.sublist(bucketIndex + 1).join('/');
        await _client.storage
            .from('fitsnap-images')
            .remove([filePath]);
      }
    } catch (e) {
      _logger.w('Supabase Storage delete failed (non-fatal)', error: e);
    }
  }
}