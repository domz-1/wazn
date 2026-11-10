import 'dart:typed_data';

enum AppCategory {
  social,
  entertainment,
  quran,
  productivity,
  other,
}

class SelectableApp {
  final String id;
  final String name;
  final String? englishName;
  final String? packageName;
  final Uint8List? iconBytes;
  final int iconBgColor;
  final AppCategory category;
  final bool isInstalled;
  final bool isQuranApp;

  const SelectableApp({
    required this.id,
    required this.name,
    this.englishName,
    this.packageName,
    this.iconBytes,
    this.iconBgColor = 0xFF1F6B5C,
    this.category = AppCategory.other,
    this.isInstalled = false,
    this.isQuranApp = false,
  });

  SelectableApp copyWith({
    String? id,
    String? name,
    String? englishName,
    String? packageName,
    Uint8List? iconBytes,
    int? iconBgColor,
    AppCategory? category,
    bool? isInstalled,
    bool? isQuranApp,
  }) {
    return SelectableApp(
      id: id ?? this.id,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      packageName: packageName ?? this.packageName,
      iconBytes: iconBytes ?? this.iconBytes,
      iconBgColor: iconBgColor ?? this.iconBgColor,
      category: category ?? this.category,
      isInstalled: isInstalled ?? this.isInstalled,
      isQuranApp: isQuranApp ?? this.isQuranApp,
    );
  }

  /// التطبيقات الشائعة المقترحة للحظر
  static const List<SelectableApp> defaultDistractingApps = [
    SelectableApp(
      id: 'tiktok',
      name: 'تيك توك',
      englishName: 'TikTok',
      packageName: 'com.zhiliaoapp.musically',
      iconBgColor: 0xFF000000,
      category: AppCategory.entertainment,
    ),
    SelectableApp(
      id: 'facebook',
      name: 'فيسبوك',
      englishName: 'Facebook',
      packageName: 'com.facebook.katana',
      iconBgColor: 0xFF1877F2,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'instagram',
      name: 'إنستغرام',
      englishName: 'Instagram',
      packageName: 'com.instagram.android',
      iconBgColor: 0xFFE1306C,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'youtube',
      name: 'يوتيوب',
      englishName: 'YouTube',
      packageName: 'com.google.android.youtube',
      iconBgColor: 0xFFFF0000,
      category: AppCategory.entertainment,
    ),
    SelectableApp(
      id: 'snapchat',
      name: 'سناب شات',
      englishName: 'Snapchat',
      packageName: 'com.snapchat.android',
      iconBgColor: 0xFFFFFC00,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'x',
      name: 'إكس (تويتر)',
      englishName: 'X (Twitter)',
      packageName: 'com.twitter.android',
      iconBgColor: 0xFF111111,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'whatsapp',
      name: 'واتساب',
      englishName: 'WhatsApp',
      packageName: 'com.whatsapp',
      iconBgColor: 0xFF25D366,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'telegram',
      name: 'تيليجرام',
      englishName: 'Telegram',
      packageName: 'org.telegram.messenger',
      iconBgColor: 0xFF229ED9,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'reddit',
      name: 'ريديت',
      englishName: 'Reddit',
      packageName: 'com.reddit.frontpage',
      iconBgColor: 0xFFFF4500,
      category: AppCategory.social,
    ),
    SelectableApp(
      id: 'pubg',
      name: 'ببجي موبايل',
      englishName: 'PUBG Mobile',
      packageName: 'com.tencent.ig',
      iconBgColor: 0xFF2E3440,
      category: AppCategory.entertainment,
    ),
  ];

  /// تطبيقات القرآن الكريم الشائعة
  static const List<SelectableApp> defaultQuranApps = [
    SelectableApp(
      id: 'ayat',
      name: 'آيات (جامعة الملك سعود)',
      englishName: 'Ayat - KSU',
      packageName: 'sa.edu.ksu.Ayat',
      iconBgColor: 0xFF0E4D3E,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
    SelectableApp(
      id: 'quran_android',
      name: 'القرآن الكريم (Quran Android)',
      englishName: 'Quran Android',
      packageName: 'com.quran.labs.androidquran',
      iconBgColor: 0xFF114B3F,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
    SelectableApp(
      id: 'golden_quran',
      name: 'المصحف الذهبي',
      englishName: 'Golden Quran',
      packageName: 'com.goldenquran',
      iconBgColor: 0xFFD4A24C,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
    SelectableApp(
      id: 'muslim_pro',
      name: 'مسلم برو (Muslim Pro)',
      englishName: 'Muslim Pro',
      packageName: 'com.bitsmedia.android.muslimpro',
      iconBgColor: 0xFF0B6653,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
    SelectableApp(
      id: 'madina_quran',
      name: 'مصحف المدينة النبوية',
      englishName: 'Madina Quran',
      packageName: 'com.quran.madina',
      iconBgColor: 0xFF14532D,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
    SelectableApp(
      id: 'telawa',
      name: 'تلاوة',
      englishName: 'Telaawah',
      packageName: 'com.telawa.app',
      iconBgColor: 0xFF1E3A8A,
      category: AppCategory.quran,
      isQuranApp: true,
    ),
  ];
}
