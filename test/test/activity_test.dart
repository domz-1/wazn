import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wazn/data/app_state.dart';
import 'package:wazn/data/local_store.dart';
import 'package:wazn/data/seed_quran.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DateTime now;
  late AppState state;
  setUp(() async {
    now = DateTime(2026, 11, 23, 10);
    SharedPreferences.setMockInitialValues({});
    state = AppState(
      await LocalStore.open(),
      clock: () => now,
      startTimer: false,
    );
  });
  tearDown(() => state.dispose());

  void readMinutes(int minutes) {
    for (var i = 0; i < minutes * 60; i++) {
      state.addReadingSecond();
    }
  }

  test('fresh installs do not inherit demo history', () {
    expect(state.streak, 0);
    expect(state.khatmaPage, 0);
    expect(state.browseLeftMinutes, state.settings.dailyLimitMinutes);
  });
  test(
    'reading cannot be claimed without active time or claimed twice',
    () async {
      expect(state.completeReading(10), false);
      readMinutes(10);
      expect(state.completeReading(10), true);
      await state.refreshNative();
      expect(state.browseLeftMinutes, 75);
      expect(state.completeReading(10), false);
      expect(state.streak, 1);
      readMinutes(10);
      expect(state.completeReading(10), true);
      expect(state.streak, 1);
    },
  );
  test(
    'daily rollover resets allowances and preserves consecutive streak',
    () async {
      readMinutes(10);
      state.completeReading(10);
      state.useEmergency(5);
      state.useSnooze();
      now = now.add(const Duration(days: 1));
      await state.refreshNative();
      expect(state.readingMinutesToday, 0);
      expect(state.emergencyUsed, false);
      expect(state.snoozeUsed, false);
      expect(state.browseLeftMinutes, 45);
      readMinutes(10);
      state.completeReading(10);
      expect(state.streak, 2);
      now = now.add(const Duration(days: 2));
      await state.refreshNative();
      expect(state.streak, 0);
      expect(state.longestStreak, 2);
    },
  );
  test('emergency and snooze are granted only once per date', () async {
    state.useEmergency(10);
    state.useEmergency(10);
    state.useSnooze();
    state.useSnooze();
    await state.refreshNative();
    expect(state.browseLeftMinutes, 60);
  });
  test('adhkar reward is once per complete session', () async {
    for (var i = 0; i < 8; i++) {
      state.completeDhikr(true, i, 8);
    }
    for (var i = 0; i < 8; i++) {
      state.completeDhikr(true, i, 8);
    }
    await state.refreshNative();
    expect(state.morningDone, 8);
    expect(state.browseLeftMinutes, 54);
    expect(state.streak, 1);
  });
  test('state survives reopening without rewarding a second time', () async {
    readMinutes(10);
    state.completeReading(10);
    state.saveReflection('remember', 'note');
    await state.refreshNative();
    final reopened = AppState(
      await LocalStore.open(),
      clock: () => now,
      startTimer: false,
    );
    expect(reopened.streak, 1);
    expect(reopened.notes.single['text'], 'remember');
    expect(reopened.completeReading(10), false);
    reopened.dispose();
  });
  test('Quran contains all surahs and 6236 verses', () {
    expect(SeedQuran.surahs.length, 114);
    expect(SeedQuran.surahs.fold<int>(0, (n, s) => n + s.ayahs.length), 6236);
    expect(SeedQuran.surahs.every((s) => s.ayahCount == s.ayahs.length), true);
  });
}
