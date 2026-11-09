import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import 'adhkar_screen.dart';
import 'reading_screen.dart';

class WorshipScreen extends StatefulWidget {
  const WorshipScreen({super.key});
  @override
  State<WorshipScreen> createState() => _WorshipScreenState();
}

class _WorshipScreenState extends State<WorshipScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [WaznColors.sand, WaznColors.sandDeep])),
      child: SafeArea(
        bottom: false,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
            child: Row(children: [
              const Text('العبادة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700, color: WaznColors.ink)),
              const Spacer(),
              WaznChip(label: '${state.khatmaPage} / ٦٠٤', icon: Icons.auto_stories_outlined),
            ]),
          ),
          TabBar(
            controller: _tab,
            labelColor: WaznColors.emerald,
            unselectedLabelColor: WaznColors.inkMuted,
            indicatorColor: WaznColors.oasis,
            labelStyle: const TextStyle(fontFamily: WaznFonts.ui, fontWeight: FontWeight.w700, fontSize: 15),
            tabs: const [Tab(text: 'المصحف'), Tab(text: 'الأذكار')],
          ),
          Expanded(
            child: TabBarView(controller: _tab, children: [
              _mushafTab(context, state),
              _adhkarTab(context),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _mushafTab(BuildContext context, AppState state) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        WaznCard(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: WaznColors.readingGradient),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ReadingScreen())),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('تابع من حيث توقفت', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w700, color: WaznColors.goldLight)),
            const SizedBox(height: 8),
            Text(state.currentSurah.name, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700, color: WaznColors.sandSoft)),
            const SizedBox(height: 4),
            Text('صفحة ${state.khatmaPage} · الجزء ٢', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: Color(0xFFBFD6CE))),
            const SizedBox(height: 16),
            Container(height: 52, alignment: Alignment.center, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: WaznColors.goldBtnGradient)), child: const Text('تابع القراءة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1405)))),
          ]),
        ),
        const SizedBox(height: 14),
        WaznCard(
          child: Column(children: [
            Row(children: [
              const Text('خطة الختمة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('${state.settings.khatmaPagesPerDay} صفحات يومياً', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.inkMuted)),
            ]),
            const SizedBox(height: 6),
            const Align(alignment: Alignment.centerRight, child: Text('ختمة في نحو ٤ أشهر', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted))),
            const SizedBox(height: 10),
            ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: state.khatmaPage / 604, minHeight: 10, backgroundColor: WaznColors.sandWarm, valueColor: const AlwaysStoppedAnimation(WaznColors.oasis))),
          ]),
        ),
        const SizedBox(height: 18),
        const SectionTitle('السور'),
        ...state.surahs.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: WaznCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReadingScreen(surahIndex: state.surahs.indexOf(s)))),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: WaznColors.sandWarm, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text('${s.number}', style: const TextStyle(fontFamily: WaznFonts.ui, fontWeight: FontWeight.w700, color: WaznColors.oasis))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 16, fontWeight: FontWeight.w600)),
                Text('${s.makki ? 'مكية' : 'مدنية'} · ${s.ayahCount} آية', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
              ])),
              const Icon(Icons.chevron_left, color: WaznColors.inkMuted),
            ]),
          ),
        )),
      ],
    );
  }

  Widget _adhkarTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        WaznCard(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: WaznColors.morningGradient),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdhkarScreen(morning: true))),
          child: const Row(children: [
            Icon(Icons.wb_sunny_outlined, size: 32, color: Color(0xFF2B1608)),
            SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('أذكار الصباح', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF2B1608))),
              Text('٨ أذكار · نحو ٣ دقائق', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: Color(0xFF4A2A10))),
            ])),
            Icon(Icons.chevron_left, color: Color(0xFF2B1608)),
          ]),
        ),
        const SizedBox(height: 12),
        WaznCard(
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: WaznColors.eveningGradient),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdhkarScreen(morning: false))),
          child: const Row(children: [
            Icon(Icons.nightlight_outlined, size: 32, color: Color(0xFFF5F0FF)),
            SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('أذكار المساء', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFF5F0FF))),
              Text('تبدأ ٤:٣٠ م · ٨ أذكار', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: Color(0xFFC9C5EE))),
            ])),
            Icon(Icons.chevron_left, color: Color(0xFFF5F0FF)),
          ]),
        ),
      ],
    );
  }
}
