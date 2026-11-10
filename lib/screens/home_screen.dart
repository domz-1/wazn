import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../models/hadith.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import '../widgets/wazn_logo.dart';
import 'block_screen.dart';
import 'reading_screen.dart';
import 'adhkar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [WaznColors.sand, WaznColors.sandDeep]),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _header(state),
            const SizedBox(height: 16),
            _heroCard(context, state),
            const SizedBox(height: 18),
            const SectionTitle('خطة اليوم'),
            _plan(state),
            const SizedBox(height: 10),
            SectionTitle('حديث اليوم',
                trailing: 'سبّح الآن', onTrailing: () {}),
            _hadith(state.hadith),
            const SizedBox(height: 10),
            const SectionTitle('حصة التصفح اليوم'),
            _quota(context, state),
          ],
        ),
      ),
    );
  }

  Widget _header(AppState state) {
    return Row(
      children: [
        const WaznMark(size: 44),
        const SizedBox(width: 10),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          WaznWordmark(fontSize: 30),
          Text('السلام عليكم',
              style: TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 13,
                  color: WaznColors.inkMuted)),
        ]),
        const Spacer(),
        WaznChip(
            label: '${_ar(state.streak)} أيام',
            icon: Icons.local_fire_department_rounded),
      ],
    );
  }

  Widget _heroCard(BuildContext context, AppState state) {
    final phase = state.phase;
    late final List<Color> grad;
    late final Color ink;
    late final Color sub;
    late final String title;
    late final String subtitle;
    late final String btn;
    late final Color btnInk;
    late final IconData icon;
    late final VoidCallback onTap;
    switch (phase) {
      case HeroPhase.morning:
        grad = WaznColors.morningGradient;
        ink = const Color(0xFF2B1608);
        sub = const Color(0xFF4A2A10);
        title = 'أذكار الصباح';
        subtitle = '٨ أذكار · نحو ٣ دقائق';
        btn = 'ابدأ الآن';
        btnInk = const Color(0xFFFFE3A3);
        icon = Icons.wb_sunny_outlined;
        onTap = () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AdhkarScreen(morning: true)));
      case HeroPhase.reading:
        grad = WaznColors.readingGradient;
        ink = WaznColors.sandSoft;
        sub = const Color(0xFFBFD6CE);
        title = 'وردك القرآني';
        subtitle = 'متبقٍ ٤ دقائق من ١٠ · سورة البقرة';
        btn = 'تابع القراءة';
        btnInk = const Color(0xFF1A1405);
        icon = Icons.menu_book_outlined;
        onTap = () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ReadingScreen()));
      case HeroPhase.evening:
        grad = WaznColors.eveningGradient;
        ink = const Color(0xFFF5F0FF);
        sub = const Color(0xFFC9C5EE);
        title = 'أذكار المساء';
        subtitle = 'تبدأ ٤:٣٠ م · ٨ أذكار';
        btn = 'ابدأ الآن';
        btnInk = const Color(0xFF1A2358);
        icon = Icons.nightlight_outlined;
        onTap = () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => const AdhkarScreen(morning: false)));
    }
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WaznRadii.card),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: grad)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                  color: ink.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999)),
              child: Text('الخطوة التالية',
                  style: TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ink))),
          const Spacer(),
          Icon(icon, size: 40, color: ink),
        ]),
        const SizedBox(height: 10),
        Text(title,
            style: TextStyle(
                fontFamily: WaznFonts.ui,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: ink,
                height: 1.25)),
        Text(subtitle,
            style:
                TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, color: sub)),
        const SizedBox(height: 14),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
                backgroundColor: btnInk == const Color(0xFFFFE3A3)
                    ? const Color(0xFF2B1608)
                    : (btnInk == const Color(0xFF1A1405) ? null : btnInk),
                foregroundColor: phase == HeroPhase.reading
                    ? const Color(0xFF1A1405)
                    : btnInk,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WaznRadii.button))),
            child: Text(btn,
                style: const TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _plan(AppState state) {
    final rows = [
      ('أذكار الصباح', '٨ أذكار · ٣ د', state.phase.index > 0),
      ('الورد القرآني', '١٠ دقائق', state.phase.index > 1),
      ('أذكار المساء', '٤:٣٠ م', false),
    ];
    return WaznCard(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Column(
          children: List.generate(rows.length, (i) {
        final r = rows[i];
        final active = state.phase.index == i;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              color: active ? const Color(0xFFF6E8C3) : Colors.transparent,
              borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: r.$3
                        ? WaznColors.oasis
                        : (active ? WaznColors.white : Colors.transparent),
                    border: Border.all(
                        color: r.$3
                            ? Colors.transparent
                            : (active
                                ? WaznColors.goldOld
                                : const Color(0xFFCFC5AE)),
                        width: active ? 3 : 2)),
                child: r.$3
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null),
            const SizedBox(width: 12),
            Expanded(
                child: Text(r.$1,
                    style: const TextStyle(
                        fontFamily: WaznFonts.ui,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: WaznColors.ink))),
            Text(r.$2,
                style: const TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 13,
                    color: WaznColors.inkMuted)),
          ]),
        );
      })),
    );
  }

  Widget _hadith(DailyHadith h) {
    return WaznCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: WaznColors.sandWarm,
                  borderRadius: BorderRadius.circular(999)),
              child: Text(h.source,
                  style: const TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: WaznColors.inkMuted))),
          const Spacer(),
          Text(h.grade,
              style: const TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 12,
                  color: WaznColors.oasis)),
        ]),
        const SizedBox(height: 10),
        Text(h.text,
            style: const TextStyle(
                fontFamily: WaznFonts.quran,
                fontSize: 19,
                height: 1.9,
                color: WaznColors.ink)),
      ]),
    );
  }

  Widget _quota(BuildContext context, AppState state) {
    final total = state.settings.dailyLimitMinutes * 60;
    final ratio = (state.browseLeftSec / total).clamp(0.0, 1.0);
    return WaznCard(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const BlockScreen())),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.hourglass_bottom_rounded,
              size: 18, color: WaznColors.goldOld),
          const SizedBox(width: 6),
          Text('${_ar(state.browseLeftMinutes)} د متبقية',
              style: const TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: WaznColors.ink)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
                value: ratio,
                minHeight: 10,
                backgroundColor: WaznColors.sandWarm,
                valueColor: const AlwaysStoppedAnimation(WaznColors.oasis))),
        const SizedBox(height: 8),
        const Text('سننبّهك قبل الحظر بـ ٥ دقائق.',
            style: TextStyle(
                fontFamily: WaznFonts.ui,
                fontSize: 12.5,
                color: WaznColors.inkMuted)),
      ]),
    );
  }

  String _ar(int n) {
    const d = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n
        .toString()
        .split('')
        .map((c) => int.tryParse(c) != null ? d[int.parse(c)] : c)
        .join();
  }
}
