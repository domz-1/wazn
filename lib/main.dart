import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'data/app_state.dart';
import 'data/local_store.dart';
import 'screens/splash_screen.dart';
import 'theme/wazn_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await LocalStore.open();
  runApp(WaznApp(state: AppState(store)));
}

class WaznApp extends StatelessWidget {
  final AppState state;
  const WaznApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        title: 'وزن',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: WaznTheme.light(),
        darkTheme: WaznTheme.dark(),
        themeMode: ThemeMode.light,
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        home: const SplashScreen(),
      ),
    );
  }
}
