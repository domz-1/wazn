import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Versioned local state. Legacy demo counters are deliberately not imported.
class LocalStore {
  final SharedPreferences _p;
  LocalStore(this._p);
  static Future<LocalStore> open() async =>
      LocalStore(await SharedPreferences.getInstance());

  Map<String, dynamic> _read(String key) {
    try {
      final raw = _p.getString(key);
      return raw == null
          ? {}
          : Map<String, dynamic>.from(jsonDecode(raw) as Map);
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Map<String, dynamic> get settingsJson => _read('wazn.settings');
  Future<void> saveSettings(Map<String, dynamic> value) async {
    await _p.setString('wazn.settings', jsonEncode(value));
  }

  Map<String, dynamic> get activity => _read('wazn.activity.v2');
  Future<void> saveActivity(Map<String, dynamic> value) async {
    await _p.setString('wazn.activity.v2', jsonEncode(value));
  }

  bool get onboardingDone => _p.getBool('wazn.onboarding.v2') ?? false;
  Future<void> finishOnboarding() async {
    await _p.setBool('wazn.onboarding.v2', true);
  }
}
