import 'package:equatable/equatable.dart';

/// A single try-on attempt: the garment photo that went in, and the
/// AI-generated composite image that came out.
class TryOnResult extends Equatable {
  final String id;
  final String personImageUrl;
  final String garmentImageUrl;
  final String resultImageUrl;
  final DateTime createdAt;
  final bool isFavorite;

  const TryOnResult({
    required this.id,
    required this.personImageUrl,
    required this.garmentImageUrl,
    required this.resultImageUrl,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory TryOnResult.fromMap(String id, Map<String, dynamic> map) {
    return TryOnResult(
      id: id,
      personImageUrl: map['personImageUrl'] as String,
      garmentImageUrl: map['garmentImageUrl'] as String,
      resultImageUrl: map['resultImageUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAtMillis'] as int,
      ),
      isFavorite: map['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personImageUrl': personImageUrl,
      'garmentImageUrl': garmentImageUrl,
      'resultImageUrl': resultImageUrl,
      'createdAtMillis': createdAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite,
    };
  }

  TryOnResult copyWith({bool? isFavorite}) {
    return TryOnResult(
      id: id,
      personImageUrl: personImageUrl,
      garmentImageUrl: garmentImageUrl,
      resultImageUrl: resultImageUrl,
      createdAt: createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        personImageUrl,
        garmentImageUrl,
        resultImageUrl,
        createdAt,
        isFavorite,
      ];
}