import '../models/ayah.dart';

/// بيانات مصحف مضمّنة تعمل بلا إنترنت (عيّنة: الفاتحة والإخلاص والفلق والناس
/// وبعض آيات البقرة) مع تفسير الميسر. يمكن استبدالها لاحقاً بأرشيف كامل.
class SeedQuran {
  static const List<Surah> surahs = [
    Surah(number: 1, name: 'الفاتحة', makki: true, ayahCount: 7, ayahs: [
      Ayah(number: 1, text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', tafsirMuyassar: 'أبتدئ قراءتي باسم الله، مستعيناً به وحده، مذكّراً نفسي بصفاته: الرحمن الرحيم.'),
      Ayah(number: 2, text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', tafsirMuyassar: 'الثناء على الله بصفات الكمال، وله الحمد وحده على كل حال.'),
      Ayah(number: 3, text: 'الرَّحْمَٰنِ الرَّحِيمِ', tafsirMuyassar: 'وصفٌ لله بسعة رحمته التي وسعت كل شيء.'),
      Ayah(number: 4, text: 'مَالِكِ يَوْمِ الدِّينِ', tafsirMuyassar: 'المتصرف وحده في يوم القيامة، يوم الجزاء والحساب.'),
      Ayah(number: 5, text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', tafsirMuyassar: 'نخصّك وحدك بالعبادة، ونطلب العون منك وحدك.'),
      Ayah(number: 6, text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', tafsirMuyassar: 'دلّنا وثبّتنا على الطريق الواضح الذي لا اعتواج فيه.'),
      Ayah(number: 7, text: 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ', tafsirMuyassar: 'طريق من أنعمت عليهم من النبيين والصديقين، لا طريق من غضبت عليهم ولا من ضلّوا.'),
    ]),
    Surah(number: 112, name: 'الإخلاص', makki: true, ayahCount: 4, ayahs: [
      Ayah(number: 1, text: 'قُلْ هُوَ اللَّهُ أَحَدٌ', tafsirMuyassar: 'قل -أيها الرسول-: هو الله المنفرد بالألوهية، لا شريك له.'),
      Ayah(number: 2, text: 'اللَّهُ الصَّمَدُ', tafsirMuyassar: 'الذي تقصده الخلائق في حوائجها، الكامل في صفاته.'),
      Ayah(number: 3, text: 'لَمْ يَلِدْ وَلَمْ يُولَدْ', tafsirMuyassar: 'ليس له ولد ولا والد.'),
      Ayah(number: 4, text: 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ', tafsirMuyassar: 'ليس له نظير ولا مثيل.'),
    ]),
    Surah(number: 113, name: 'الفلق', makki: true, ayahCount: 5, ayahs: [
      Ayah(number: 1, text: 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ', tafsirMuyassar: 'قل: ألتجئ إلى ربّ الصبح.'),
      Ayah(number: 2, text: 'مِن شَرِّ مَا خَلَقَ', tafsirMuyassar: 'من شرّ جميع المخلوقات.'),
      Ayah(number: 3, text: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', tafsirMuyassar: 'ومن شرّ الليل حين يظلم.'),
      Ayah(number: 4, text: 'وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ', tafsirMuyassar: 'ومن شرّ الساحرات اللاتي ينفثن في العقد.'),
      Ayah(number: 5, text: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', tafsirMuyassar: 'ومن شرّ الحاسد حين يحسد.'),
    ]),
    Surah(number: 114, name: 'الناس', makki: true, ayahCount: 6, ayahs: [
      Ayah(number: 1, text: 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ', tafsirMuyassar: 'قل: ألتجئ إلى ربّ الناس.'),
      Ayah(number: 2, text: 'مَلِكِ النَّاسِ', tafsirMuyassar: 'ملكهم المتصرف في شؤونهم.'),
      Ayah(number: 3, text: 'إِلَٰهِ النَّاسِ', tafsirMuyassar: 'معبودهم الحق.'),
      Ayah(number: 4, text: 'مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ', tafsirMuyassar: 'من شرّ الشيطان الذي يوسوس ويختفي عند ذكر الله.'),
      Ayah(number: 5, text: 'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ', tafsirMuyassar: 'الذي يلقي الشك والشر في القلوب.'),
      Ayah(number: 6, text: 'مِنَ الْجِنَّةِ وَالنَّاسِ', tafsirMuyassar: 'من الجنّ ومن الإنس.'),
    ]),
  ];
}
