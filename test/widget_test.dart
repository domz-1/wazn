import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wazn/data/app_state.dart';
import 'package:wazn/data/local_store.dart';
import 'package:wazn/main.dart';
import 'package:wazn/models/selectable_app.dart';
import 'package:wazn/services/native_app_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SelectableApp models and defaults load correctly', () {
    expect(SelectableApp.defaultDistractingApps.isNotEmpty, true);
    expect(SelectableApp.defaultQuranApps.isNotEmpty, true);

    final tiktok = SelectableApp.defaultDistractingApps
        .firstWhere((a) => a.id == 'tiktok');
    expect(tiktok.name, 'تيك توك');

    final ayat =
        SelectableApp.defaultQuranApps.firstWhere((a) => a.id == 'ayat');
    expect(ayat.isQuranApp, true);
  });

  test('NativeAppService returns fallback apps on unsupported platforms',
      () async {
    final apps = await NativeAppService.instance.getInstalledApps();
    expect(apps.isNotEmpty, true);
    expect(apps.any((a) => a.id == 'tiktok'), true);
    expect(apps.any((a) => a.id == 'facebook'), true);

    final quranApps = await NativeAppService.instance.getQuranApps();
    expect(quranApps.isNotEmpty, true);
    expect(quranApps.any((a) => a.isQuranApp), true);
  });

  testWidgets('WaznApp smoke test builds cleanly', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await LocalStore.open();
    final state = AppState(store);

    await tester.pumpWidget(WaznApp(state: state));
    await tester.pump();

    expect(find.byType(WaznApp), findsOneWidget);
  });
}
