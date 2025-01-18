class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
    );
  }
}

class Ayah {
  String text;
  final int number;

  Ayah(this.number, {required this.text});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(json['number'], text: json['text']);
  }

  get surahNumber => null;
}
