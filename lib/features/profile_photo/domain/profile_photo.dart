import 'package:equatable/equatable.dart';

/// The user's saved "base" photo used as the person input for every
/// try-on generation, so they only have to take it once.
class ProfilePhoto extends Equatable {
  final String id;
  final String imageUrl;
  final DateTime createdAt;
  final bool isActive;

  const ProfilePhoto({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    this.isActive = false,
  });

  factory ProfilePhoto.fromMap(String id, Map<String, dynamic> map) {
    return ProfilePhoto(
      id: id,
      imageUrl: map['imageUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAtMillis'] as int,
      ),
      isActive: map['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'createdAtMillis': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  ProfilePhoto copyWith({bool? isActive}) {
    return ProfilePhoto(
      id: id,
      imageUrl: imageUrl,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, createdAt, isActive];
}
