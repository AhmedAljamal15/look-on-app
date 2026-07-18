enum AppLanguage { arabic, english }
enum UserGender { male, female, unspecified }

class UserPreferences {
  final AppLanguage language;
  final UserGender gender;

  const UserPreferences({
    this.language = AppLanguage.arabic,
    this.gender = UserGender.unspecified,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      language: map['language'] == 'english'
          ? AppLanguage.english
          : AppLanguage.arabic,
      gender: switch (map['gender'] as String?) {
        'male' => UserGender.male,
        'female' => UserGender.female,
        _ => UserGender.unspecified,
      },
    );
  }

  Map<String, dynamic> toMap() => {
        'language': language == AppLanguage.english ? 'english' : 'arabic',
        'gender': switch (gender) {
          UserGender.male => 'male',
          UserGender.female => 'female',
          UserGender.unspecified => 'unspecified',
        },
      };

  UserPreferences copyWith({
    AppLanguage? language,
    UserGender? gender,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      gender: gender ?? this.gender,
    );
  }
}