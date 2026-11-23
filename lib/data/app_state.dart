import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/native_app_service.dart';
import '../models/selectable_app.dart';
import '../models/app_settings.dart';
import '../models/hadith.dart';
import '../models/ayah.dart';
import 'local_store.dart';
import 'seed_hadith.dart';
import 'seed_quran.dart';

enum HeroPhase { morning, reading, evening }

class AppState extends ChangeNotifier {
  final LocalStore store;
  final DateTime Function() clock;
  Timer? _timer;
  Future<void>? _refreshing;
  bool _disposed = false;
  AppState(this.store, {DateTime Function()? clock, bool startTimer = true})
    : clock = clock ?? DateTime.now {
    _load();
    if (startTimer) {
      _timer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => refreshNative(),
      );
      unawaited(refreshNative());
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose();
  }

  String _day(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  String _date = '';
  Map<String, dynamic> _history = {};
  List<dynamic> _notes = [];
  Set<String> _adhkarDone = {};
  int _earnedSec = 0;
  int _usedSec = 0;
  int _readingSec = 0;
  int _rewardedReadingSec = 0;
  bool usagePermission = false;
  bool overlayPermission = false;
  bool protectionRunning = false;
  bool get androidSupported => NativeAppService.instance.supportsBlocking;
  bool get onboardingDone => store.onboardingDone;
  int get readingSeconds => _readingSec;
  int get longestStreak => (_history['longest'] as int?) ?? 0;
  List<dynamic> get notes => List.unmodifiable(_notes);
  List<int> get weekReading => List.generate(7, (i) {
    final entry = _history[_day(clock().subtract(Duration(days: 6 - i)))];
    return entry is Map ? (entry['readingSec'] as int? ?? 0) ~/ 60 : 0;
  });
  int get weekEarnedMinutes =>
      List.generate(7, (i) {
        final entry = _history[_day(clock().subtract(Duration(days: i)))];
        return entry is Map ? (entry['earnedSec'] as int? ?? 0) : 0;
      }).fold<int>(0, (a, b) => a + b) ~/
      60;
  int get completedAdhkarSessions => [
    true,
    false,
  ].where((m) => (m ? _morningDone : _eveningDone) >= (m ? 8 : 5)).length;

  void _rollover() {
    final today = _day(clock());
    if (_date == today) return;
    _date = today;
    _earnedSec = 0;
    _usedSec = 0;
    _readingSec = 0;
    _rewardedReadingSec = 0;
    _readingMinutesToday = 0;
    _snoozeUsed = false;
    _emergencyUsed = false;
    _morningDone = 0;
    _eveningDone = 0;
    _adhkarDone = {};
    _browseLeftSec = _settings.dailyLimitMinutes * 60;
    _streak = _calculateStreak();
  }

  int _calculateStreak() {
    var date = clock();
    if (!((_history[_day(date)] as Map?)?['completed'] == true)) {
      date = date.subtract(const Duration(days: 1));
    }
    var result = 0;
    // A missed day breaks the streak. No implicit rest-day claims.
    for (var i = 0; i < 36600; i++) {
      if (!((_history[_day(date)] as Map?)?['completed'] == true)) break;
      result++;
      date = date.subtract(const Duration(days: 1));
    }
    return result;
  }

  Future<void> _writes = Future.value();
  Future<void> _saveActivity() {
    _history[_date] = {
      'readingSec': _readingSec,
      'earnedSec': _earnedSec,
      'usedSec': _usedSec,
      'completed': _lastRead?.startsWith(_date) ?? false,
    };
    _streak = _calculateStreak();
    if (_streak > longestStreak) _history['longest'] = _streak;
    final snapshot = <String, dynamic>{
      'date': _date,
      'earnedSec': _earnedSec,
      'usedSec': _usedSec,
      'readingSec': _readingSec,
      'rewardedReadingSec': _rewardedReadingSec,
      'snoozeUsed': _snoozeUsed,
      'emergencyUsed': _emergencyUsed,
      'lastRead': _lastRead,
      'khatmaPage': _khatmaPage,
      'adhkarDone': _adhkarDone.toList(),
      'history': Map<String, dynamic>.from(_history),
      'notes': List<dynamic>.from(_notes),
      'selectedSurah': _selectedSurah,
    };
    _writes = _writes.then((_) => store.saveActivity(snapshot));
    return _writes;
  }

  void addReadingSecond() {
    _rollover();
    _readingSec++;
    _readingMinutesToday = _readingSec ~/ 60;
    if (_readingSec % 10 == 0) unawaited(_saveActivity());
    notifyListeners();
  }

  void saveReflection(String text, String tag) {
    if (text.trim().isEmpty && tag.isEmpty) return;
    _notes.add({
      'text': text.trim(),
      'tag': tag,
      'at': clock().toIso8601String(),
    });
    unawaited(_saveActivity());
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    await store.finishOnboarding();
    await refreshNative();
  }

  Future<void> refreshNative() {
    _rollover();
    return _refreshing ??= _refreshNative().whenComplete(
      () => _refreshing = null,
    );
  }

  Future<void> _refreshNative() async {
    try {
      _rollover();
      if (androidSupported) {
        usagePermission = await NativeAppService.instance.hasUsagePermission();
        overlayPermission = await NativeAppService.instance
            .hasOverlayPermission();
        final ids = _settings.restrictedApps.map((id) {
          for (final app in SelectableApp.defaultDistractingApps) {
            if (app.id == id) return app.packageName ?? id;
          }
          return id;
        }).toList();
        NativeAppService.instance.setDailySeconds(
          _settings.dailyLimitMinutes * 60,
        );
        final result = await NativeAppService.instance.configureProtection(
          ids,
          _settings.dailyLimitMinutes * 60 + _earnedSec,
          store.onboardingDone && usagePermission && overlayPermission,
        );
        _usedSec = result['usedSeconds'] as int? ?? _usedSec;
        protectionRunning = result['running'] == true;
      }
      _browseLeftSec =
          (_settings.dailyLimitMinutes * 60 + _earnedSec - _usedSec).clamp(
            0,
            1 << 30,
          );
      await _saveActivity();
      if (!_disposed) notifyListeners();
    } finally {
      // The coalesced future is cleared by refreshNative.
    }
  }

  // ── الإعدادات ─────────────────────────────────────────────
  AppSettings _settings = const AppSettings();
  AppSettings get settings => _settings;

  // ── الحالة اليومية ───────────────────────────────────────
  int _streak = 0;
  int _browseLeftSec = 2700;
  bool _snoozeUsed = false;
  bool _emergencyUsed = false;
  int _khatmaPage = 0;
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

  DailyHadith get hadith => SeedHadith.forDay(clock());
  Surah get currentSurah => SeedQuran.surahs[_selectedSurah];
  List<Surah> get surahs => SeedQuran.surahs;

  HeroPhase get phase {
    final h = clock().hour;
    if (h < 12) return HeroPhase.morning;
    if (h < 16) return HeroPhase.reading;
    return HeroPhase.evening;
  }

  void _load() {
    final j = store.settingsJson;
    if (j.isNotEmpty) {
      _settings = AppSettings(
        restrictedApps:
            (j['restrictedApps'] as List?)?.cast<String>().toSet() ??
            _settings.restrictedApps,
        dailyLimitMinutes:
            j['dailyLimitMinutes'] ?? _settings.dailyLimitMinutes,
        alertBeforeMinutes:
            j['alertBeforeMinutes'] ?? _settings.alertBeforeMinutes,
        snoozeMinutes: j['snoozeMinutes'] ?? _settings.snoozeMinutes,
        readingMinutes: j['readingMinutes'] ?? _settings.readingMinutes,
        browseRatio: j['browseRatio'] ?? _settings.browseRatio,
        mushafSource: j['mushafSource'] ?? _settings.mushafSource,
        externalQuranPackage:
            j['externalQuranPackage'] ?? _settings.externalQuranPackage,
        externalQuranName:
            j['externalQuranName'] ?? _settings.externalQuranName,
        tafsirSource: j['tafsirSource'] ?? _settings.tafsirSource,
        mushafTheme: j['mushafTheme'] ?? _settings.mushafTheme,
        fontScale: (j['fontScale'] as num?)?.toDouble() ?? _settings.fontScale,
        blockMode: j['blockMode'] ?? _settings.blockMode,
        morningAdhkarTime:
            j['morningAdhkarTime'] ?? _settings.morningAdhkarTime,
        eveningAdhkarTime:
            j['eveningAdhkarTime'] ?? _settings.eveningAdhkarTime,
        restDayEnabled: j['restDayEnabled'] ?? _settings.restDayEnabled,
        khatmaPagesPerDay:
            j['khatmaPagesPerDay'] ?? _settings.khatmaPagesPerDay,
      );
    }
    final a = store.activity;
    _date = a['date'] as String? ?? '';
    _earnedSec = a['earnedSec'] as int? ?? 0;
    _usedSec = a['usedSec'] as int? ?? 0;
    _readingSec = a['readingSec'] as int? ?? 0;
    _rewardedReadingSec = a['rewardedReadingSec'] as int? ?? 0;
    _readingMinutesToday = _readingSec ~/ 60;
    _snoozeUsed = a['snoozeUsed'] == true;
    _emergencyUsed = a['emergencyUsed'] == true;
    _lastRead = a['lastRead'] as String?;
    _khatmaPage = a['khatmaPage'] as int? ?? 0;
    _selectedSurah = (a['selectedSurah'] as int? ?? 0).clamp(
      0,
      surahs.length - 1,
    );
    _history = Map<String, dynamic>.from(a['history'] as Map? ?? {});
    _notes = List<dynamic>.from(a['notes'] as List? ?? []);
    _adhkarDone = (a['adhkarDone'] as List? ?? []).cast<String>().toSet();
    _morningDone = _adhkarDone.where((k) => k.startsWith('morning:')).length;
    _eveningDone = _adhkarDone.where((k) => k.startsWith('evening:')).length;
    _rollover();
    _streak = _calculateStreak();
    _browseLeftSec = (_settings.dailyLimitMinutes * 60 + _earnedSec - _usedSec)
        .clamp(0, 1 << 30);
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
      'externalQuranPackage': _settings.externalQuranPackage,
      'externalQuranName': _settings.externalQuranName,
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
    unawaited(refreshNative());
    notifyListeners();
  }

  void toggleApp(String id) {
    final next = Set<String>.from(_settings.restrictedApps);
    next.contains(id) ? next.remove(id) : next.add(id);
    updateSettings(_settings.copyWith(restrictedApps: next));
  }

  void setExternalQuranApp(String package, String name) {
    updateSettings(
      _settings.copyWith(
        mushafSource: 'external',
        externalQuranPackage: package,
        externalQuranName: name,
      ),
    );
  }

  void selectSurah(int i) {
    _selectedSurah = i.clamp(0, surahs.length - 1);
    unawaited(_saveActivity());
    notifyListeners();
  }

  bool completeReading(int minutes) {
    _rollover();
    final available = (_readingSec - _rewardedReadingSec) ~/ 60;
    if (minutes <= 0 || available < minutes) return false;
    _rewardedReadingSec += minutes * 60;
    _earnedSec += minutes * 60 * _settings.browseRatio;
    _lastRead = clock().toIso8601String();
    // Page progress must reflect explicit page completion, not elapsed time.
    unawaited(_saveActivity());
    unawaited(refreshNative());
    notifyListeners();
    return true;
  }

  void useSnooze() {
    _rollover();
    if (_snoozeUsed || _settings.blockMode == 'strict') return;
    _snoozeUsed = true;
    _earnedSec += _settings.snoozeMinutes * 60;
    unawaited(_saveActivity());
    unawaited(refreshNative());
    notifyListeners();
  }

  void useEmergency(int minutes) {
    _rollover();
    if (_emergencyUsed || ![5, 10].contains(minutes)) return;
    _emergencyUsed = true;
    _earnedSec += minutes * 60;
    unawaited(_saveActivity());
    unawaited(refreshNative());
    notifyListeners();
  }

  bool dhikrDone(bool morning, int index) =>
      _adhkarDone.contains('${morning ? 'morning' : 'evening'}:$index');

  void completeDhikr(bool morning, int index, int sessionLength) {
    _rollover();
    final key = '${morning ? 'morning' : 'evening'}:$index';
    if (!_adhkarDone.add(key)) return;
    final count = _adhkarDone
        .where((k) => k.startsWith(morning ? 'morning:' : 'evening:'))
        .length;
    if (morning) {
      _morningDone = count;
    } else {
      _eveningDone = count;
    }
    if (count == sessionLength) {
      _earnedSec += 3 * 60 * _settings.browseRatio;
      _lastRead = clock().toIso8601String();
    }
    unawaited(_saveActivity());
    unawaited(refreshNative());
    notifyListeners();
  }
}
