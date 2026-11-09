import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_buttons.dart';
import '../widgets/wazn_cards.dart';
import 'unlocked_screen.dart';

class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});
  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final _controller = TextEditingController();
  final _tags = ['دعاء', 'تذكير', 'أمر', 'بشارة'];
  String? _selected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('التدبّر')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: WaznColors.sandWarm, borderRadius: BorderRadius.circular(16)),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('أتممت وردك · ١٠ دقائق', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w700, color: WaznColors.oasis)),
              SizedBox(height: 8),
              Text('ماذا وقفتَ عنده؟', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 20, fontWeight: FontWeight.w700, color: WaznColors.ink)),
              SizedBox(height: 4),
              Text('لحظة تدبّر قصيرة تجعل القراءة تبقى معك.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.inkMuted)),
            ]),
          ),
          const SizedBox(height: 16),
          WaznCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.quran, fontSize: 24, height: 2.0, color: WaznColors.ink)),
              const SizedBox(height: 6),
              const Text('سورة الفاتحة · الآية ٦', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
              const Divider(height: 28),
              const Text('ما الذي لامسك فيها؟', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, children: _tags.map((t) => ChoiceChip(label: Text(t), selected: _selected == t, onSelected: (_) => setState(() => _selected = t))).toList()),
              const SizedBox(height: 14),
              TextField(controller: _controller, maxLines: 3, decoration: InputDecoration(hintText: 'ملاحظتك (اختيارية)', filled: true, fillColor: WaznColors.sand, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: WaznColors.sandLine)))),
            ]),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.mic_none_rounded), label: const Text('ملاحظة صوتية'), style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), foregroundColor: WaznColors.emerald)),
          const SizedBox(height: 16),
          EmeraldButton(label: 'احفظ وأكمل', onTap: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const UnlockedScreen()), (_) => _.isFirst)),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const UnlockedScreen()), (_) => _.isFirst), child: const Text('تخطَّ', style: TextStyle(fontFamily: WaznFonts.ui, color: WaznColors.inkMuted))),
        ],
      ),
    );
  }
}
