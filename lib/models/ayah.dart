class Ayah {
  final int number;
  final String text;
  final String tafsirMuyassar;
  final String tafsirIbnKathir;
  final String tafsirSaadi;
  const Ayah({
    required this.number,
    required this.text,
    this.tafsirMuyassar = '',
    this.tafsirIbnKathir = '',
    this.tafsirSaadi = '',
  });
  String tafsirFor(String source) {
    final value = switch (source) {
      'ibn_kathir' => tafsirIbnKathir,
      'saadi' => tafsirSaadi,
      _ => tafsirMuyassar,
    };
    return value.isEmpty ? 'التفسير غير متاح لهذه الآية بعد.' : value;
  }
}

class Surah {
  final int number;
  final String name;
  final bool makki;
  final int ayahCount;
  final List<Ayah> ayahs;
  const Surah({
    required this.number,
    required this.name,
    required this.makki,
    required this.ayahCount,
    required this.ayahs,
  });
}
