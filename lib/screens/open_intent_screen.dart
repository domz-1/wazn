import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import 'dhikr_counter_screen.dart';
import '../data/seed_adhkar.dart';

class OpenIntentScreen extends StatefulWidget {
  const OpenIntentScreen({super.key});
  @override
  State<OpenIntentScreen> createState() => _OpenIntentScreenState();
}

class _OpenIntentScreenState extends State<OpenIntentScreen> {
  String? _reason;
  int _minutes = 10;
  static const reasons = [
    'أتواصل مع شخص',
    'عمل أو أمر ضروري',
    'استراحة قصيرة',
    'لا أعرف، فتحته تلقائياً'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('نية الفتح')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          WaznCard(
            child: Row(children: [
              Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE1306C).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: const Text('إ',
                      style: TextStyle(
                          fontFamily: WaznFonts.ui,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE1306C)))),
              const SizedBox(width: 12),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('إنستغرام',
                        style: TextStyle(
                            fontFamily: WaznFonts.ui,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                    Text('حصتك اليوم ١٣ دقيقة',
                        style: TextStyle(
                            fontFamily: WaznFonts.ui,
                            fontSize: 12.5,
                            color: WaznColors.inkMuted)),
                  ])),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('لماذا تفتحه الآن؟',
              style: TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('اختر سبباً، ثم ادخل بوعي.',
              style: TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 13,
                  color: WaznColors.inkMuted)),
          const SizedBox(height: 12),
          ...reasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => setState(() => _reason = r),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: WaznColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: _reason == r
                                ? WaznColors.oasis
                                : WaznColors.sandLine,
                            width: _reason == r ? 2 : 1)),
                    child: Row(children: [
                      Icon(
                          _reason == r
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 20,
                          color: _reason == r
                              ? WaznColors.oasis
                              : WaznColors.inkMuted),
                      const SizedBox(width: 10),
                      Text(r,
                          style: const TextStyle(
                              fontFamily: WaznFonts.ui, fontSize: 15)),
                    ]),
                  ),
                ),
              )),
          const SizedBox(height: 10),
          WaznCard(
            color: WaznColors.sandWarm,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('اقتراح لحظة هدوء',
                  style: TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WaznColors.goldOld)),
              const SizedBox(height: 4),
              const Text('ما رأيك بـ ٣٣ تسبيحة بدل التمرير؟ تأخذ دقيقة واحدة.',
                  style: TextStyle(
                      fontFamily: WaznFonts.ui, fontSize: 13, height: 1.6)),
              const SizedBox(height: 8),
              OutlinedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DhikrCounterScreen(
                          dhikr: SeedAdhkar.morning.items[4],
                          session: SeedAdhkar.morning))),
                  child: const Text('سبّح ٣٣ بدلاً من ذلك')),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('كم تحتاج؟',
              style: TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 5, label: Text('٥ د')),
              ButtonSegment(value: 10, label: Text('١٠ د')),
              ButtonSegment(value: 15, label: Text('١٥ د'))
            ],
            selected: {_minutes},
            onSelectionChanged: (s) => setState(() => _minutes = s.first),
          ),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: _reason == null ? null : () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: WaznColors.emerald,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28))),
              child: Text('ادخل لمدة $_minutes دقائق')),
        ],
      ),
    );
  }
}
