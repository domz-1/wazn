import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import 'emergency_screen.dart';
import 'reading_screen.dart';

class GradualBlockScreen extends StatefulWidget {
  const GradualBlockScreen({super.key});
  @override
  State<GradualBlockScreen> createState() => _GradualBlockScreenState();
}

class _GradualBlockScreenState extends State<GradualBlockScreen> {
  int _left = 30;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left = (_left - 1).clamp(0, 30));
      if (_left == 0) t.cancel();
    });
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.emeraldNight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: WaznColors.goldOld, width: 4)),
              alignment: Alignment.center,
              child: Text('$_left ثانية',
                  style: const TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: WaznColors.goldLight)),
            ),
            const SizedBox(height: 24),
            const Text('أنهِ ما بين يديك',
                style: TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: WaznColors.sand)),
            const SizedBox(height: 8),
            const Text('انتهت حصتك. سيُغلق التطبيق بهدوء بعد قليل.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 14,
                    color: Color(0xFFBFD6CE))),
            const Spacer(),
            FilledButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReadingScreen())),
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: WaznColors.gold,
                    foregroundColor: const Color(0xFF1A1405),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28))),
                child: const Text('ابدأ الورد الآن')),
            const SizedBox(height: 10),
            OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: WaznColors.sand,
                    side: BorderSide(color: WaznColors.sand.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
                child: const Text('أجّل ٥ د')),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EmergencyScreen())),
                child: const Text('أحتاجه الآن',
                    style: TextStyle(color: WaznColors.goldLight))),
          ]),
        ),
      ),
    );
  }
}
