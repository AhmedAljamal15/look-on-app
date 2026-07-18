import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';
import '../errors/exceptions.dart';

/// Handles picking images (camera or gallery) and normalizing them
/// (resize/compress) before upload, so we never ship a 12MB photo straight
/// from a modern phone camera to Storage/the AI API.
///
/// Both pick methods can throw [ImageProcessingException] if the picked
/// file can't be decoded (corrupt file, unsupported format) — callers in
/// the UI layer should wrap calls in try/catch and show a friendly message
/// (see [pickFromCamera]/[pickFromGallery] usage in the capture screens).
class ImageService {
  final ImagePicker _picker;
  final Logger _logger;

  ImageService({ImagePicker? picker, Logger? logger})
      : _picker = picker ?? ImagePicker(),
        _logger = logger ?? Logger();

  Future<File?> pickFromCamera() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: AppConstants.imageQuality,
      maxWidth: AppConstants.imageMaxWidth.toDouble(),
      maxHeight: AppConstants.imageMaxHeight.toDouble(),
      preferredCameraDevice: CameraDevice.rear,
    );
    if (xfile == null) return null;
    return _normalize(File(xfile.path));
  }

  Future<File?> pickFromGallery() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: AppConstants.imageQuality,
      maxWidth: AppConstants.imageMaxWidth.toDouble(),
      maxHeight: AppConstants.imageMaxHeight.toDouble(),
    );
    if (xfile == null) return null;
    return _normalize(File(xfile.path));
  }

  /// Re-encodes to JPEG at a controlled max dimension to keep upload size
  /// predictable, regardless of source device's native resolution.
  Future<File> _normalize(File source) async {
  try {
    final bytes = await source.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const ImageProcessingException('image_unclear_error');
    }

    final resized = decoded.width > AppConstants.imageMaxWidth
        ? img.copyResize(decoded, width: AppConstants.imageMaxWidth)
        : decoded;

    final encoded =
        img.encodeJpg(resized, quality: AppConstants.imageQuality);

    // استخدم ApplicationDocumentsDirectory بدل Temporary عشان الملف ميتمسحش
    final dir = await getApplicationDocumentsDirectory();
    final outPath =
        '${dir.path}/normalized_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outFile = File(outPath);
    await outFile.writeAsBytes(encoded);

    // تأكد إن الملف اتكتب فعلاً قبل ما ترجعه
    if (!await outFile.exists()) {
      throw const ImageProcessingException('image_temp_save_error');
    }

    return outFile;
  } on ImageProcessingException {
    rethrow;
  } catch (e) {
    _logger.e('Image normalization failed', error: e);
    throw const ImageProcessingException('image_process_error');
  }
}
}
