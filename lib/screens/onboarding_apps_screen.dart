import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_buttons.dart';
import 'onboarding_defaults_screen.dart';

class OnboardingAppsScreen extends StatefulWidget {
  const OnboardingAppsScreen({super.key});
  @override
  State<OnboardingAppsScreen> createState() => _OnboardingAppsScreenState();
}

class _OnboardingAppsScreenState extends State<OnboardingAppsScreen> {
  static const apps = [
    ('instagram', 'إنستغرام', 'إ', Color(0xFFE1306C)),
    ('tiktok', 'تيك توك', 'ت', Color(0xFF111111)),
    ('facebook', 'فيسبوك', 'ف', Color(0xFF1877F2)),
    ('youtube', 'يوتيوب', 'ي', Color(0xFFFF0000)),
    ('snapchat', 'سناب شات', 'س', Color(0xFFFFFC00)),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final selected = state.settings.restrictedApps;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _StepHeader(step: 1, title: 'ما التطبيقات التي تسرق وقتك؟', subtitle: 'اختر ما تريد ضبطه. الباقي جاهز بقيم مناسبة تعدّلها لاحقاً.'),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: apps.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final a = apps[i];
                    final on = selected.contains(a.$1);
                    return InkWell(
                      onTap: () => state.toggleApp(a.$1),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: WaznColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: on ? WaznColors.oasis : WaznColors.sandLine, width: on ? 2 : 1),
                        ),
                        child: Row(children: [
                          Container(width: 42, height: 42, decoration: BoxDecoration(color: a.$4.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: Text(a.$3, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 18, fontWeight: FontWeight.w700, color: a.$4))),
                          const SizedBox(width: 12),
                          Expanded(child: Text(a.$2, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 16, fontWeight: FontWeight.w600, color: WaznColors.ink))),
                          Switch(value: on, onChanged: (_) => state.toggleApp(a.$1), activeTrackColor: WaznColors.oasis),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text('الحد اليومي للتطبيقات المختارة', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w600, color: WaznColors.inkMuted)),
              const SizedBox(height: 10),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 15, label: Text('١٥ دقيقة')),
                  ButtonSegment(value: 45, label: Text('٤٥ دقيقة')),
                  ButtonSegment(value: 120, label: Text('٢ ساعة')),
                ],
                selected: {_nearestLimit(state.settings.dailyLimitMinutes)},
                onSelectionChanged: (s) => state.updateSettings(state.settings.copyWith(dailyLimitMinutes: s.first)),
              ),
              const SizedBox(height: 16),
              EmeraldButton(label: 'التالي', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingDefaultsScreen()))),
            ],
          ),
        ),
      ),
    );
  }

  int _nearestLimit(int v) {
    if (v <= 30) return 15;
    if (v <= 80) return 45;
    return 120;
  }
}

class _StepHeader extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  const _StepHeader({required this.step, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('الخطوة $step من ٢', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w600, color: WaznColors.oasis)),
      const SizedBox(height: 6),
      Text(title, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 24, fontWeight: FontWeight.w700, color: WaznColors.ink, height: 1.4)),
      const SizedBox(height: 6),
      Text(subtitle, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, color: WaznColors.inkMuted, height: 1.6)),
    ]);
  }
}
