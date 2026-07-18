import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../errors/exceptions.dart';

class TryOnAiService {
  final Logger _logger;
  final Dio _dio;

  String get _falApiKey => dotenv.env['FAL_API_KEY'] ?? '';

  TryOnAiService({Logger? logger, Dio? dio})
      : _logger = logger ?? Logger(),
        _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 180),
              ),
            );

  Future<String> generateTryOn({
    required String personImageUrl,
    required String garmentImageUrl,
    String category = 'tops',
    String gender = 'male',
  }) async {
    try {
      _logger.i('Calling FASHN.ai | category: $category | gender: $gender');

      // FASHN.ai بيحدد الجنس تلقائياً من الصورة، بس بنستخدم
      // الـ gender لتحسين بعض الـ parameters تلقائياً:
      // - البنات: بنرفع الـ guidance_scale شوية لتفاصيل أدق
      // - الرجالة: mode أسرع
      final isFemale = gender == 'female';

      final response = await _dio.post(
        'https://fal.run/fal-ai/fashn/tryon/v1.5',
        options: Options(
          headers: {
            'Authorization': 'Key $_falApiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model_image': personImageUrl,
          'garment_image': garmentImageUrl,
          'category': category,
          'garment_photo_type': 'auto',
          'mode': isFemale ? 'quality' : 'balanced',
          // لو category سفلي، بنفعّل long_top detection
          'long_top': category == 'bottoms',
        },
      );

      _logger.i('Response received');

      final images = response.data['images'] as List?;
      if (images == null || images.isEmpty) {
        throw const TryOnGenerationException('ai_no_image_returned');
      }

      final imageUrl = images[0]['url'] as String?;
      if (imageUrl == null || imageUrl.isEmpty) {
        throw const TryOnGenerationException('ai_no_url_in_response');
      }

      _logger.i('Result: $imageUrl');
      return imageUrl;
    } on DioException catch (e) {
      _logger.e('FASHN.ai request failed', error: e);

      // تحديد نوع الخطأ وإرجاع رسالة واضحة للمستخدم
      final statusCode = e.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        throw const TryOnGenerationException('ai_auth_error');
      } else if (statusCode == 429) {
        throw const TryOnGenerationException('ai_rate_limit');
      } else if (statusCode == 400) {
        throw const TryOnGenerationException('ai_bad_image');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TryOnGenerationException('ai_timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const TryOnGenerationException('ai_no_internet');
      }

      throw const TryOnGenerationException('ai_server_connect_failed');
    } catch (e) {
      _logger.e('Unexpected error', error: e);
      throw const TryOnGenerationException('ai_unexpected_error');
    }
  }
}
