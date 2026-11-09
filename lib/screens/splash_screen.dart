import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_logo.dart';
import '../widgets/wazn_buttons.dart';
import 'onboarding_apps_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [WaznColors.sand, WaznColors.sandDeep]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const WaznMark(size: 96),
                const SizedBox(height: 20),
                const WaznWordmark(fontSize: 64),
                const SizedBox(height: 10),
                const Text('اجعل وقتك يزن أكثر', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 16, color: WaznColors.inkMuted)),
                const Spacer(flex: 3),
                EmeraldButton(label: 'ابدأ', onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingAppsScreen()))),
                const SizedBox(height: 12),
                const Text('استبدل التمرير بوردٍ وذكر', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.inkMuted)),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
