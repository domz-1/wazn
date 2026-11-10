import 'package:flutter/material.dart';
import '../models/dhikr.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

class DhikrCounterScreen extends StatefulWidget {
  final Dhikr dhikr;
  final AdhkarSession session;
  const DhikrCounterScreen(
      {super.key, required this.dhikr, required this.session});
  @override
  State<DhikrCounterScreen> createState() => _DhikrCounterScreenState();
}

class _DhikrCounterScreenState extends State<DhikrCounterScreen> {
  int _count = 0;
  final int _target = 33;

  @override
  Widget build(BuildContext context) {
    final done = _count >= _target;
    final progress = (_count / _target).clamp(0.0, 1.0);
    return Scaffold(
      backgroundColor: WaznColors.emerald,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: WaznColors.sand,
          title: Text(widget.session.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Text(widget.dhikr.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: WaznFonts.quran,
                      fontSize: 26,
                      height: 2.0,
                      color: WaznColors.sandSoft)),
              const SizedBox(height: 36),
              GestureDetector(
                onTap: () =>
                    setState(() => _count = (_count + 1).clamp(0, _target)),
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: WaznColors.sand.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation(
                                WaznColors.goldLight))),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: WaznColors.goldBtnGradient)),
                      alignment: Alignment.center,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(_ar(_count),
                            style: const TextStyle(
                                fontFamily: WaznFonts.ui,
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1405))),
                        Text('من ${_ar(_target)}',
                            style: const TextStyle(
                                fontFamily: WaznFonts.ui,
                                fontSize: 13,
                                color: Color(0xFF4A3A10))),
                      ]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 28),
              Text(done ? 'تقبّل الله منك' : 'اضغط على الدائرة للتسبيح',
                  style: const TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 14,
                      color: WaznColors.sandSoft)),
              const Spacer(),
              Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => setState(() => _count = 0),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: WaznColors.sand,
                            side: BorderSide(
                                color: WaznColors.sand.withValues(alpha: 0.3)),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        child: const Text('تصفير'))),
                const SizedBox(width: 12),
                Expanded(
                    child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                            backgroundColor: WaznColors.gold,
                            foregroundColor: const Color(0xFF1A1405),
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16))),
                        child: const Text('الذكر التالي'))),
              ]),
            ],
          ),
        ),
      ),
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
