import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../models/selectable_app.dart';
import '../services/native_app_service.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/app_icon.dart';
import '../widgets/wazn_buttons.dart';

class QuranAppsScreen extends StatefulWidget {
  const QuranAppsScreen({super.key});

  @override
  State<QuranAppsScreen> createState() => _QuranAppsScreenState();
}

class _QuranAppsScreenState extends State<QuranAppsScreen> {
  List<SelectableApp> _quranApps = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final apps = await NativeAppService.instance.getQuranApps();
    if (mounted) {
      setState(() {
        _quranApps = apps;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final currentPkg = state.settings.externalQuranPackage;
    final isExternalActive = state.settings.mushafSource == 'external';

    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(
        title: const Text('تطبيقات القرآن الكريم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث التطبيقات',
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: WaznColors.oasis))
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: WaznColors.sandWarm,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: WaznColors.sandLine),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_stories_rounded,
                          color: WaznColors.oasis, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'اختر تطبيق المصحف الذي تقرأ فيه وردك',
                              style: TextStyle(
                                fontFamily: WaznFonts.ui,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                color: WaznColors.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isExternalActive
                                  ? 'المصحف الخارجي المفعّل حالياً: ${state.settings.externalQuranName}'
                                  : 'المصحف المدمج هو المفعّل حالياً (يمكنك التبديل لتطبيقك المفضل أدناه).',
                              style: const TextStyle(
                                fontFamily: WaznFonts.ui,
                                fontSize: 12.5,
                                color: WaznColors.inkMuted,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'التطبيقات المتوفرة والمثبتة',
                  style: TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: WaznColors.ink,
                  ),
                ),
                const SizedBox(height: 10),
                ..._quranApps.map((a) {
                  final isSelected = isExternalActive &&
                      (currentPkg == a.packageName || currentPkg == a.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: WaznColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color:
                            isSelected ? WaznColors.oasis : WaznColors.sandLine,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: WaznColors.oasis.withValues(alpha: 0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      leading: AppIcon(app: a, size: 48),
                      title: Text(
                        a.name,
                        style: const TextStyle(
                          fontFamily: WaznFonts.ui,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.5,
                          color: WaznColors.ink,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.englishName ?? '',
                            style: const TextStyle(
                              fontFamily: WaznFonts.ui,
                              fontSize: 12,
                              color: WaznColors.inkMuted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: a.isInstalled
                                      ? WaznColors.oasis.withValues(alpha: 0.1)
                                      : WaznColors.sandWarm,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  a.isInstalled
                                      ? '✓ مثبت على هاتفك'
                                      : 'تطبيق مقترح',
                                  style: TextStyle(
                                    fontFamily: WaznFonts.ui,
                                    fontSize: 11,
                                    color: a.isInstalled
                                        ? WaznColors.oasis
                                        : WaznColors.inkMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.open_in_new_rounded, size: 20),
                            tooltip: 'فتح التطبيق',
                            onPressed: () => NativeAppService.instance
                                .launchApp(a.packageName ?? a.id),
                          ),
                          Radio<bool>(
                            value: true,
                            // ignore: deprecated_member_use
                            groupValue: isSelected,
                            activeColor: WaznColors.oasis,
                            // ignore: deprecated_member_use
                            onChanged: (_) {
                              state.setExternalQuranApp(
                                  a.packageName ?? a.id, a.name);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        state.setExternalQuranApp(
                            a.packageName ?? a.id, a.name);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 16),
                EmeraldButton(
                  label: 'استخدام المصحف المدمج داخل وزن بدلاً من ذلك',
                  icon: Icons.menu_book_outlined,
                  onTap: () {
                    state.updateSettings(
                        state.settings.copyWith(mushafSource: 'builtin'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
    );
  }
}
