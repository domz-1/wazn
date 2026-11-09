import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [WaznColors.sand, WaznColors.sandDeep])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            const Text('إحصاءاتك', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700, color: WaznColors.ink)),
            const SizedBox(height: 16),
            WaznCard(
              gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: WaznColors.readingGradient),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('الوقت المستعاد هذا الأسبوع', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: Color(0xFFBFD6CE))),
                const SizedBox(height: 6),
                const Text('١٥ ساعة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 34, fontWeight: FontWeight.w700, color: WaznColors.goldLight)),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                  _Bar(label: 'ح', h: 0.3), _Bar(label: 'ن', h: 0.5), _Bar(label: 'ث', h: 0.4), _Bar(label: 'ر', h: 0.8),
                  _Bar(label: 'خ', h: 0.7), _Bar(label: 'ج', h: 0.9), _Bar(label: 'س', h: 0.6),
                ]),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _statCard('سلسلة الورد الحالية', '${state.streak} أيام', Icons.local_fire_department_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('أطول سلسلة', '١٢ يوماً', Icons.emoji_events_outlined)),
            ]),
            const SizedBox(height: 14),
            WaznCard(
              color: WaznColors.sandWarm,
              child: Row(children: [
                const Icon(Icons.self_improvement_rounded, color: WaznColors.goldOld),
                const SizedBox(width: 10),
                const Expanded(child: Text('يوم راحة واحد أسبوعياً لا يكسر سلسلتك.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, height: 1.6, color: WaznColors.ink))),
              ]),
            ),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: _statCard('دقائق القراءة', '${state.readingMinutesToday} د', Icons.menu_book_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _statCard('أذكار مكتملة', '١٢ جلسة', Icons.auto_awesome_outlined)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) => WaznCard(
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 20, color: WaznColors.goldOld),
      const SizedBox(height: 8),
      Text(value, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 22, fontWeight: FontWeight.w700, color: WaznColors.ink)),
      Text(title, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
    ]),
  );
}

class _Bar extends StatelessWidget {
  final String label;
  final double h;
  const _Bar({required this.label, required this.h});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(width: 22, height: 80 * h, decoration: BoxDecoration(color: WaznColors.goldLight.withOpacity(0.85), borderRadius: BorderRadius.circular(6))),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: Color(0xFFBFD6CE))),
    ]);
  }
}
