import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_logo.dart';
import 'emergency_screen.dart';
import 'reading_screen.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: WaznColors.emeraldNight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(children: [
                const WaznMark(size: 36),
                const SizedBox(width: 8),
                const WaznWordmark(fontSize: 24, color: WaznColors.sand),
              ]),
              const Spacer(),
              const Icon(Icons.hourglass_disabled_rounded, size: 64, color: WaznColors.goldOld),
              const SizedBox(height: 16),
              const Text('انتهت حصتك الترفيهية', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700, color: WaznColors.sand, height: 1.4)),
              const SizedBox(height: 8),
              const Text('حان وقت وردك القرآني', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, color: Color(0xFFBFD6CE))),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: WaznColors.sand.withOpacity(0.06), borderRadius: BorderRadius.circular(20), border: Border.all(color: WaznColors.sand.withOpacity(0.12))),
                child: Column(children: [
                  _appRow('إنستغرام', '٤٥ / ٤٥ د', true),
                  const SizedBox(height: 10),
                  _appRow('تيك توك', 'مقفل', false),
                  const SizedBox(height: 10),
                  _appRow('فيسبوك', 'مقفل', false),
                ]),
              ),
              const Spacer(),
              Text('اقرأ ${state.settings.readingMinutes} دقائق تفتح لك ${state.settings.readingMinutes * state.settings.browseRatio} دقيقة تصفح', textAlign: TextAlign.center, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: WaznColors.sandSoft)),
              const SizedBox(height: 4),
              const Text('كل دقيقة قراءة = ٣ دقائق تصفح', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12.5, color: Color(0xFF8FB0A6))),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReadingScreen())),
                style: FilledButton.styleFrom(backgroundColor: WaznColors.gold, foregroundColor: const Color(0xFF1A1405), minimumSize: const Size.fromHeight(56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
                child: const Text('ابدأ الورد لفك القفل', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 18, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: TextButton.icon(onPressed: () {}, icon: const Icon(Icons.headphones_outlined, size: 18, color: WaznColors.sandSoft), label: const Text('استمع بدلاً من القراءة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.sandSoft)))),
              ]),
              const SizedBox(height: 4),
              TextButton(
                onPressed: state.snoozeUsed ? null : () { state.useSnooze(); Navigator.pop(context); },
                child: Text(state.snoozeUsed ? 'التأجيل استُخدم اليوم' : 'أجّل ٥ دقائق · متاح مرة واحدة اليوم', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: state.snoozeUsed ? WaznColors.inkMuted : WaznColors.goldLight)),
              ),
              const SizedBox(height: 4),
              TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen())), child: const Text('أحتاجه الآن', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.sandSoft))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appRow(String name, String status, bool locked) {
    return Row(children: [
      Icon(locked ? Icons.lock_outline_rounded : Icons.lock_rounded, size: 18, color: locked ? WaznColors.goldOld : WaznColors.inkMuted),
      const SizedBox(width: 10),
      Text(name, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w600, color: WaznColors.sand)),
      const Spacer(),
      Text(status, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: locked ? WaznColors.goldLight : WaznColors.inkMuted)),
    ]);
  }
}
