import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'worship_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  late final List<Widget> _pages = const [HomeScreen(), WorshipScreen(), StatsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: WaznBottomNav(index: _index, onTap: (i) => setState(() => _index = i)),
    );
  }
}
