import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../models/selectable_app.dart';
import '../services/native_app_service.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/wazn_buttons.dart';
import 'onboarding_defaults_screen.dart';

class OnboardingAppsScreen extends StatefulWidget {
  const OnboardingAppsScreen({super.key});
  @override
  State<OnboardingAppsScreen> createState() => _OnboardingAppsScreenState();
}

class _OnboardingAppsScreenState extends State<OnboardingAppsScreen> {
  List<SelectableApp> _availableApps = SelectableApp.defaultDistractingApps;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceApps();
  }

  Future<void> _loadDeviceApps() async {
    setState(() => _loading = true);
    final apps = await NativeAppService.instance.getInstalledApps();
    if (mounted) {
      setState(() {
        _availableApps = apps.where((a) => !a.isQuranApp).toList();
        _loading = false;
      });
    }
  }

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
              const _StepHeader(
                step: 1,
                title: 'ما التطبيقات التي تسرق وقتك؟',
                subtitle:
                    'اختر ما تريد ضبطه. الباقي جاهز بقيم مناسبة تعدّلها لاحقاً.',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _loading && _availableApps.isEmpty
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: WaznColors.oasis))
                    : ListView.separated(
                        itemCount: _availableApps.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final a = _availableApps[i];
                          final on = selected.contains(a.id) ||
                              (a.packageName != null &&
                                  selected.contains(a.packageName));

                          return InkWell(
                            onTap: () => state.toggleApp(a.id),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: WaznColors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: on
                                      ? WaznColors.oasis
                                      : WaznColors.sandLine,
                                  width: on ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AppIcon(app: a, size: 44),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          a.name,
                                          style: const TextStyle(
                                            fontFamily: WaznFonts.ui,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: WaznColors.ink,
                                          ),
                                        ),
                                        if (a.englishName != null)
                                          Text(
                                            a.englishName!,
                                            style: const TextStyle(
                                              fontFamily: WaznFonts.ui,
                                              fontSize: 12,
                                              color: WaznColors.inkMuted,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: on,
                                    onChanged: (_) => state.toggleApp(a.id),
                                    activeTrackColor: WaznColors.oasis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              const Text(
                'الحد اليومي للتطبيقات المختارة',
                style: TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WaznColors.inkMuted,
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 15, label: Text('١٥ دقيقة')),
                  ButtonSegment(value: 45, label: Text('٤٥ دقيقة')),
                  ButtonSegment(value: 120, label: Text('٢ ساعة')),
                ],
                selected: {_nearestLimit(state.settings.dailyLimitMinutes)},
                onSelectionChanged: (s) => state.updateSettings(
                    state.settings.copyWith(dailyLimitMinutes: s.first)),
              ),
              const SizedBox(height: 16),
              EmeraldButton(
                label: 'التالي',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const OnboardingDefaultsScreen()),
                ),
              ),
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
  const _StepHeader(
      {required this.step, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخطوة $step من ٢',
          style: const TextStyle(
            fontFamily: WaznFonts.ui,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: WaznColors.oasis,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontFamily: WaznFonts.ui,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: WaznColors.ink,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: WaznFonts.ui,
            fontSize: 14,
            color: WaznColors.inkMuted,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
