import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import 'block_screen.dart';
import 'reading_screen.dart';

class PreBlockAlertScreen extends StatelessWidget {
  const PreBlockAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('التنبيه والويدجت')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const SectionTitle('تنبيه قبل الحظر'),
          WaznCard(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: WaznColors.sandWarm, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Icon(Icons.notifications_active_outlined, color: WaznColors.goldOld)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('وزن الآن', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w700, color: WaznColors.oasis)),
                SizedBox(height: 4),
                Text('بقي ٥ دقائق من حصة إنستغرام. اقرأ وردك الآن لتحتفظ بوقتك، أو أجّل مرة واحدة.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, height: 1.6, color: WaznColors.ink)),
              ])),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50), foregroundColor: WaznColors.emerald, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('أجّل ٥ د'))),
            const SizedBox(width: 10),
            Expanded(child: FilledButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReadingScreen())), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: WaznColors.emerald, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('ابدأ الورد'))),
          ]),
          const SizedBox(height: 20),
          const SectionTitle('ويدجت شاشة القفل'),
          WaznCard(
            gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: WaznColors.readingGradient),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.hourglass_bottom_rounded, size: 16, color: WaznColors.goldLight),
                SizedBox(width: 6),
                Text('١٣ دقيقة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w700, color: WaznColors.sandSoft)),
              ]),
              const SizedBox(height: 8),
              const Text('السلسلة · ٧ أيام', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: Color(0xFFBFD6CE))),
              const SizedBox(height: 4),
              const Text('التالي: أذكار الصباح', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w700, color: WaznColors.goldLight)),
              const SizedBox(height: 2),
              const Text('اضغط للبدء', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: Color(0xFF8FB0A6))),
            ]),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BlockScreen())), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: WaznColors.emeraldNight, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('معاينة شاشة الحظر')),
        ],
      ),
    );
  }
}
