class AppSettings {
  final Set<String> restrictedApps;
  final int dailyLimitMinutes;
  final int alertBeforeMinutes;
  final int snoozeMinutes;
  final int readingMinutes;
  final int browseRatio;
  final String mushafSource;
  final String externalQuranPackage;
  final String externalQuranName;
  final String tafsirSource;
  final String mushafTheme;
  final double fontScale;
  final String blockMode; // gentle | strict
  final String morningAdhkarTime;
  final String eveningAdhkarTime;
  final bool restDayEnabled;
  final int khatmaPagesPerDay;

  const AppSettings({
    this.restrictedApps = const {
      'tiktok',
      'facebook',
      'instagram',
      'youtube',
      'snapchat'
    },
    this.dailyLimitMinutes = 45,
    this.alertBeforeMinutes = 5,
    this.snoozeMinutes = 5,
    this.readingMinutes = 10,
    this.browseRatio = 3,
    this.mushafSource = 'builtin',
    this.externalQuranPackage = 'com.quran.labs.androidquran',
    this.externalQuranName = 'القرآن الكريم',
    this.tafsirSource = 'muyassar',
    this.mushafTheme = 'paper',
    this.fontScale = 1.0,
    this.blockMode = 'gentle',
    this.morningAdhkarTime = '05:30',
    this.eveningAdhkarTime = '16:30',
    this.restDayEnabled = true,
    this.khatmaPagesPerDay = 5,
  });

  AppSettings copyWith({
    Set<String>? restrictedApps,
    int? dailyLimitMinutes,
    int? alertBeforeMinutes,
    int? snoozeMinutes,
    int? readingMinutes,
    int? browseRatio,
    String? mushafSource,
    String? externalQuranPackage,
    String? externalQuranName,
    String? tafsirSource,
    String? mushafTheme,
    double? fontScale,
    String? blockMode,
    String? morningAdhkarTime,
    String? eveningAdhkarTime,
    bool? restDayEnabled,
    int? khatmaPagesPerDay,
  }) {
    return AppSettings(
      restrictedApps: restrictedApps ?? this.restrictedApps,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      alertBeforeMinutes: alertBeforeMinutes ?? this.alertBeforeMinutes,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      readingMinutes: readingMinutes ?? this.readingMinutes,
      browseRatio: browseRatio ?? this.browseRatio,
      mushafSource: mushafSource ?? this.mushafSource,
      externalQuranPackage: externalQuranPackage ?? this.externalQuranPackage,
      externalQuranName: externalQuranName ?? this.externalQuranName,
      tafsirSource: tafsirSource ?? this.tafsirSource,
      mushafTheme: mushafTheme ?? this.mushafTheme,
      fontScale: fontScale ?? this.fontScale,
      blockMode: blockMode ?? this.blockMode,
      morningAdhkarTime: morningAdhkarTime ?? this.morningAdhkarTime,
      eveningAdhkarTime: eveningAdhkarTime ?? this.eveningAdhkarTime,
      restDayEnabled: restDayEnabled ?? this.restDayEnabled,
      khatmaPagesPerDay: khatmaPagesPerDay ?? this.khatmaPagesPerDay,
    );
  }
}
