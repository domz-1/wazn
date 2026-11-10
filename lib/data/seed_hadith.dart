import '../models/hadith.dart';

class SeedHadith {
  static const List<DailyHadith> daily = [
    DailyHadith(
      text:
          'كَلِمَتَانِ خَفِيفَتَانِ عَلَى اللِّسَانِ، ثَقِيلَتَانِ فِي الْمِيزَانِ، حَبِيبَتَانِ إِلَى الرَّحْمَنِ: سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      source: 'متفق عليه',
      grade: 'صحيح',
    ),
    DailyHadith(
      text:
          'مَنْ قَالَ سُبْحَانَ اللَّهِ وَبِحَمْدِهِ مِائَةَ مَرَّةٍ حُطَّتْ خَطَايَاهُ وَإِنْ كَانَتْ مِثْلَ زَبَدِ الْبَحْرِ',
      source: 'رواه البخاري ومسلم',
      grade: 'صحيح',
    ),
    DailyHadith(
      text:
          'أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ فَأَكْثِرُوا الدُّعَاءَ',
      source: 'رواه مسلم',
      grade: 'صحيح',
    ),
  ];

  static DailyHadith forDay(DateTime d) =>
      daily[(d.year * 372 + d.month * 31 + d.day) % daily.length];
}
