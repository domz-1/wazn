import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../models/hadith.dart';
import '../models/ayah.dart';
import 'local_store.dart';
import 'seed_hadith.dart';
import 'seed_quran.dart';

enum HeroPhase { morning, reading, evening }

class AppState extends ChangeNotifier {
  final LocalStore store;
  AppState(this.store) {
    _load();
  }

  // ── الإعدادات ─────────────────────────────────────────────
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  // ── الحالة اليومية ───────────────────────────────────────
  int _streak = 7;
  int _browseLeftSec = 780;
  bool _snoozeUsed = false;
  bool _emergencyUsed = false;
  int _khatmaPage = 25;
  int _readingMinutesToday = 0;
  String? _lastRead;
  int _morningDone = 0;
  int _eveningDone = 0;
  int _selectedSurah = 0;

  int get streak => _streak;
  int get browseLeftSec => _browseLeftSec;
  int get browseLeftMinutes => (_browseLeftSec / 60).ceil();
  bool get snoozeUsed => _snoozeUsed;
  bool get emergencyUsed => _emergencyUsed;
  int get khatmaPage => _khatmaPage;
  int get readingMinutesToday => _readingMinutesToday;
  String? get lastRead => _lastRead;
  int get morningDone => _morningDone;
  int get eveningDone => _eveningDone;

  DailyHadith get hadith => SeedHadith.forDay(DateTime.now());
  Surah get currentSurah => SeedQuran.surahs[_selectedSurah];
  List<Surah> get surahs => SeedQuran.surahs;

  HeroPhase get phase {
    final h = DateTime.now().hour;
    if (h < 12) return HeroPhase.morning;
    if (h < 16) return HeroPhase.reading;
    return HeroPhase.evening;
  }

  void _load() {
    final j = store.settingsJson;
    if (j.isNotEmpty) {
      _settings = AppSettings(
        restrictedApps: (j['restrictedApps'] as List?)?.cast<String>().toSet() ?? _settings.restrictedApps,
        dailyLimitMinutes: j['dailyLimitMinutes'] ?? _settings.dailyLimitMinutes,
        alertBeforeMinutes: j['alertBeforeMinutes'] ?? _settings.alertBeforeMinutes,
        snoozeMinutes: j['snoozeMinutes'] ?? _settings.snoozeMinutes,
        readingMinutes: j['readingMinutes'] ?? _settings.readingMinutes,
        browseRatio: j['browseRatio'] ?? _settings.browseRatio,
        mushafSource: j['mushafSource'] ?? _settings.mushafSource,
        tafsirSource: j['tafsirSource'] ?? _settings.tafsirSource,
        mushafTheme: j['mushafTheme'] ?? _settings.mushafTheme,
        fontScale: j['fontScale'] ?? _settings.fontScale,
        blockMode: j['blockMode'] ?? _settings.blockMode,
        morningAdhkarTime: j['morningAdhkarTime'] ?? _settings.morningAdhkarTime,
        eveningAdhkarTime: j['eveningAdhkarTime'] ?? _settings.eveningAdhkarTime,
        restDayEnabled: j['restDayEnabled'] ?? _settings.restDayEnabled,
        khatmaPagesPerDay: j['khatmaPagesPerDay'] ?? _settings.khatmaPagesPerDay,
      );
    }
    _streak = store.streakDays;
    _browseLeftSec = store.browseLeftSec;
    _snoozeUsed = store.snoozeUsed;
    _emergencyUsed = store.emergencyUsed;
    _khatmaPage = store.khatmaPage;
    _readingMinutesToday = store.readingMinutesToday;
    _lastRead = store.lastRead;
    notifyListeners();
  }

  void _persist() {
    store.saveSettings({
      'restrictedApps': _settings.restrictedApps.toList(),
      'dailyLimitMinutes': _settings.dailyLimitMinutes,
      'alertBeforeMinutes': _settings.alertBeforeMinutes,
      'snoozeMinutes': _settings.snoozeMinutes,
      'readingMinutes': _settings.readingMinutes,
      'browseRatio': _settings.browseRatio,
      'mushafSource': _settings.mushafSource,
      'tafsirSource': _settings.tafsirSource,
      'mushafTheme': _settings.mushafTheme,
      'fontScale': _settings.fontScale,
      'blockMode': _settings.blockMode,
      'morningAdhkarTime': _settings.morningAdhkarTime,
      'eveningAdhkarTime': _settings.eveningAdhkarTime,
      'restDayEnabled': _settings.restDayEnabled,
      'khatmaPagesPerDay': _settings.khatmaPagesPerDay,
    });
  }

  void updateSettings(AppSettings s) {
    _settings = s;
    _persist();
    notifyListeners();
  }

  void toggleApp(String id) {
    final next = Set<String>.from(_settings.restrictedApps);
    next.contains(id) ? next.remove(id) : next.add(id);
    updateSettings(_settings.copyWith(restrictedApps: next));
  }

  void selectSurah(int i) {
    _selectedSurah = i.clamp(0, surahs.length - 1);
    notifyListeners();
  }

  // ── منطق الورد والرصيد ────────────────────────────────────
  /// إتمام ورد قراءة: يضيف رصيد تصفح = دقائق القراءة × المعامل، ويزيد السلسلة.
  void completeReading(int minutes) {
    _readingMinutesToday += minutes;
    store.setReadingMinutesToday(_readingMinutesToday);
    _browseLeftSec += minutes * 60 * _settings.browseRatio;
    store.setBrowseLeftSec(_browseLeftSec);
    _lastRead = DateTime.now().toIso8601String();
    store.setLastRead(_lastRead!);
    _streak += 1;
    store.setStreakDays(_streak);
    _khatmaPage = (_khatmaPage + _settings.khatmaPagesPerDay).clamp(0, 604);
    store.setKhatmaPage(_khatmaPage);
    notifyListeners();
  }

  void consumeBrowse(int seconds) {
    _browseLeftSec = (_browseLeftSec - seconds).clamp(0, 1 << 30);
    store.setBrowseLeftSec(_browseLeftSec);
    notifyListeners();
  }

  void useSnooze() {
    _snoozeUsed = true;
    store.setSnoozeUsed(true);
    _browseLeftSec += _settings.snoozeMinutes * 60;
    store.setBrowseLeftSec(_browseLeftSec);
    notifyListeners();
  }

  void useEmergency(int minutes) {
    _emergencyUsed = true;
    store.setEmergencyUsed(true);
    _browseLeftSec += minutes * 60;
    store.setBrowseLeftSec(_browseLeftSec);
    notifyListeners();
  }

  void markAdhkar(bool morning, int done) {
    if (morning) {
      _morningDone = done;
    } else {
      _eveningDone = done;
    }
    notifyListeners();
  }

  void resetDailyQuota() {
    _browseLeftSec = _settings.dailyLimitMinutes * 60;
    _snoozeUsed = false;
    _emergencyUsed = false;
    _readingMinutesToday = 0;
    store.setBrowseLeftSec(_browseLeftSec);
    store.setSnoozeUsed(false);
    store.setEmergencyUsed(false);
    store.setReadingMinutesToday(0);
    notifyListeners();
  }
}
