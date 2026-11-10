import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// مخزن محلي بسيط يعمل بلا إنترنت (SharedPreferences + JSON).
/// قابل للاستبدال بـ SQLite/drift لاحقاً دون تغيير الواجهة.
class LocalStore {
  static const _kSettings = 'wazn.settings';
  static const _kStreak = 'wazn.streak';
  static const _kBrowseLeft = 'wazn.browseLeftSec';
  static const _kLastRead = 'wazn.lastRead';
  static const _kSnoozeUsed = 'wazn.snoozeUsed';
  static const _kEmergencyUsed = 'wazn.emergencyUsed';
  static const _kKhatmaPage = 'wazn.khatmaPage';
  static const _kReadingMinutes = 'wazn.readingMinutesToday';

  final SharedPreferences _p;
  LocalStore(this._p);

  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());

  Map<String, dynamic> get settingsJson {
    final s = _p.getString(_kSettings);
    return s == null ? {} : jsonDecode(s) as Map<String, dynamic>;
  }

  Future<void> saveSettings(Map<String, dynamic> j) =>
      _p.setString(_kSettings, jsonEncode(j));

  int get streakDays => _p.getInt(_kStreak) ?? 7;
  Future<void> setStreakDays(int v) => _p.setInt(_kStreak, v);

  int get browseLeftSec => _p.getInt(_kBrowseLeft) ?? 780;
  Future<void> setBrowseLeftSec(int v) => _p.setInt(_kBrowseLeft, v);

  String? get lastRead => _p.getString(_kLastRead);
  Future<void> setLastRead(String v) => _p.setString(_kLastRead, v);

  bool get snoozeUsed => _p.getBool(_kSnoozeUsed) ?? false;
  Future<void> setSnoozeUsed(bool v) => _p.setBool(_kSnoozeUsed, v);

  bool get emergencyUsed => _p.getBool(_kEmergencyUsed) ?? false;
  Future<void> setEmergencyUsed(bool v) => _p.setBool(_kEmergencyUsed, v);

  int get khatmaPage => _p.getInt(_kKhatmaPage) ?? 25;
  Future<void> setKhatmaPage(int v) => _p.setInt(_kKhatmaPage, v);

  int get readingMinutesToday => _p.getInt(_kReadingMinutes) ?? 0;
  Future<void> setReadingMinutesToday(int v) => _p.setInt(_kReadingMinutes, v);
}
