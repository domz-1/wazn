import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_buttons.dart';
import '../widgets/wazn_cards.dart';
import 'app_shell.dart';

class OnboardingDefaultsScreen extends StatelessWidget {
  const OnboardingDefaultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.settings;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            const Text('الخطوة ٢ من ٢', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w600, color: WaznColors.oasis)),
            const SizedBox(height: 6),
            const Text('جاهز بإعدادات مقترحة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 24, fontWeight: FontWeight.w700, color: WaznColors.ink)),
            const SizedBox(height: 6),
            const Text('عدّل ما تشاء الآن، أو لاحقاً من الإعدادات.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: WaznColors.inkMuted)),
            const SizedBox(height: 18),
            const SectionTitle('أين تقرأ وردك؟'),
            WaznCard(
              child: Column(children: [
                RadioListTile<String>(
                  value: 'builtin', groupValue: s.mushafSource, onChanged: (v) => state.updateSettings(s.copyWith(mushafSource: v)),
                  title: const Text('المصحف المدمج', style: TextStyle(fontFamily: WaznFonts.ui, fontWeight: FontWeight.w600)),
                  subtitle: const Text('يعمل على الآيفون والأندرويد ويحسب وقتك بدقة، وفيه التفسير وعدة مظاهر.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12.5, height: 1.5)),
                ),
                RadioListTile<String>(
                  value: 'external', groupValue: s.mushafSource, onChanged: (v) => state.updateSettings(s.copyWith(mushafSource: v)),
                  title: const Text('تطبيق خارجي', style: TextStyle(fontFamily: WaznFonts.ui, fontWeight: FontWeight.w600)),
                  subtitle: const Text('يُحسب وقته بدقة أعلى على الأندرويد فقط.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12.5, height: 1.5)),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            WaznCard(
              child: Column(children: [
                _kv('مدة الورد', '${s.readingMinutes} دقائق'),
                const Divider(),
                _kv('رصيد التصفح', '١ دقيقة = ${s.browseRatio} دقائق'),
                const Divider(),
                _kv('أذكار الصباح', s.morningAdhkarTime),
                const Divider(),
                _kv('أذكار المساء', s.eveningAdhkarTime),
              ]),
            ),
            const SizedBox(height: 12),
            WaznCard(
              color: WaznColors.sandWarm,
              child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.lock_clock_outlined, color: WaznColors.goldOld),
                SizedBox(width: 10),
                Expanded(child: Text('نحتاج إذناً واحداً: «وقت الشاشة» على الآيفون أو «إحصاءات الاستخدام» على الأندرويد، لنحسب وقتك ونُظهر شاشة الحظر.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, height: 1.6, color: WaznColors.ink))),
              ]),
            ),
            const SizedBox(height: 18),
            EmeraldButton(
              label: 'ابدأ مع وزن',
              onTap: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AppShell()), (_) => false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: WaznColors.inkMuted)),
      Text(v, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w700, color: WaznColors.ink)),
    ]),
  );
}
