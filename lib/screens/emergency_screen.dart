import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});
  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String? _reason;
  int _minutes = 5;
  static const reasons = ['عمل', 'أسرة', 'أمر طارئ', 'غير ذلك'];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('أحتاجه الآن')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text('أحتاجه الآن', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('نفتحه لك مدة قصيرة، ونسجّل ذلك لك وحدك دون محاسبة.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: WaznColors.inkMuted, height: 1.6)),
          const SizedBox(height: 20),
          const Text('السبب', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: reasons.map((r) => ChoiceChip(label: Text(r), selected: _reason == r, onSelected: (_) => setState(() => _reason = r))).toList()),
          const SizedBox(height: 20),
          const Text('المدة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<int>(segments: const [ButtonSegment(value: 5, label: Text('٥ دقائق')), ButtonSegment(value: 10, label: Text('١٠ دقائق'))], selected: {_minutes}, onSelectionChanged: (s) => setState(() => _minutes = s.first)),
          const SizedBox(height: 16),
          Text(state.emergencyUsed ? 'استُخدم استخدام الطوارئ اليوم.' : 'متبقٍ لك استخدام واحد للضرورة اليوم.', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.goldOld)),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: state.emergencyUsed ? null : () { state.useEmergency(_minutes); Navigator.pop(context); },
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56), backgroundColor: WaznColors.emerald, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
            child: Text('افتح لمدة $_minutes دقائق'),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('رجوع')),
        ],
      ),
    );
  }
}
