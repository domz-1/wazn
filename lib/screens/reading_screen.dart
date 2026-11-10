import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../models/ayah.dart';
import '../models/selectable_app.dart';
import '../services/native_app_service.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/app_icon.dart';
import 'reflection_screen.dart';

class ReadingScreen extends StatefulWidget {
  final int? surahIndex;
  const ReadingScreen({super.key, this.surahIndex});
  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.surahIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.read<AppState>().selectSurah(widget.surahIndex!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final surah = state.currentSurah;
    final isExternal = state.settings.mushafSource == 'external';

    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(
        title: Text('سورة ${surah.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields_rounded),
            tooltip: 'حجم الخط',
            onPressed: () => _showFontSheet(context, state),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'مظهر المصحف',
            onPressed: () => _showThemeSheet(context, state),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          // بطاقة إذا كان المستخدم قد اختار تطبيق قرآن خارجي
          if (isExternal) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0E4D3E), Color(0xFF07241F)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  AppIcon(
                    app: SelectableApp(
                      id: state.settings.externalQuranPackage,
                      name: state.settings.externalQuranName,
                      packageName: state.settings.externalQuranPackage,
                      isQuranApp: true,
                    ),
                    size: 48,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.settings.externalQuranName,
                          style: const TextStyle(
                            fontFamily: WaznFonts.ui,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: WaznColors.sandSoft,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'تطبيقك القرآني المفضل للقراءة',
                          style: TextStyle(
                            fontFamily: WaznFonts.ui,
                            fontSize: 12.5,
                            color: Color(0xFFBFD6CE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => NativeAppService.instance
                        .launchApp(state.settings.externalQuranPackage),
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: const Text('افتح التطبيق'),
                    style: FilledButton.styleFrom(
                      backgroundColor: WaznColors.gold,
                      foregroundColor: const Color(0xFF1A1405),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: WaznColors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: WaznColors.sandLine),
              ),
              child: Text(
                '${surah.makki ? 'مكية' : 'مدنية'} · ${_ar(surah.ayahCount)} آيات · الجزء ١',
                style: const TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 12,
                  color: WaznColors.inkMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...surah.ayahs.map((a) => _ayahTile(a, state)),
          const SizedBox(height: 20),
          Text(
            'اضغط على أي آية لتفسيرها أو الاستماع إليها',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: WaznFonts.ui,
              fontSize: 12,
              color: WaznColors.inkMuted.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _prevSurah(state),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('السابقة'),
                  style: _navStyle(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _complete(state),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('أتممت الورد'),
                  style: FilledButton.styleFrom(
                    backgroundColor: WaznColors.emerald,
                    foregroundColor: WaznColors.sand,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _nextSurah(state),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('التالية'),
                  style: _navStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _navStyle() => OutlinedButton.styleFrom(
        foregroundColor: WaznColors.emerald,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: WaznColors.sandLine),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  Widget _ayahTile(Ayah a, AppState state) {
    final sel = _selected == a.number;
    return InkWell(
      onTap: () => setState(() => _selected = sel ? null : a.number),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: sel ? WaznColors.sandWarm : WaznColors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: sel ? WaznColors.goldOld : WaznColors.sandLine),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${a.text} ﴿${_ar(a.number)}﴾',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: WaznFonts.quran,
                fontSize: 24 * state.settings.fontScale,
                height: 2.0,
                color: WaznColors.ink,
              ),
            ),
            if (sel) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'تفسير الآية ${_ar(a.number)}',
                    style: const TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: WaznColors.oasis,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _tafsirLabel(state.settings.tafsirSource),
                    style: const TextStyle(
                      fontFamily: WaznFonts.ui,
                      fontSize: 12,
                      color: WaznColors.inkMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                a.tafsirFor(state.settings.tafsirSource),
                style: const TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 14.5,
                  height: 1.9,
                  color: WaznColors.ink,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _tafsirLabel(String s) => switch (s) {
        'ibn_kathir' => 'ابن كثير',
        'saadi' => 'السعدي',
        _ => 'التفسير الميسر'
      };

  void _nextSurah(AppState state) {
    if (state.surahs.isEmpty) return;
    final cur = state.surahs.indexOf(state.currentSurah);
    state.selectSurah((cur + 1) % state.surahs.length);
    setState(() => _selected = null);
  }

  void _prevSurah(AppState state) {
    final cur = state.surahs.indexOf(state.currentSurah);
    state.selectSurah((cur - 1 + state.surahs.length) % state.surahs.length);
    setState(() => _selected = null);
  }

  void _complete(AppState state) {
    state.completeReading(state.settings.readingMinutes);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ReflectionScreen()));
  }

  void _showFontSheet(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WaznColors.sand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حجم الخط',
              style: TextStyle(
                fontFamily: WaznFonts.ui,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text('أ',
                    style:
                        TextStyle(fontFamily: WaznFonts.quran, fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: state.settings.fontScale,
                    min: 0.85,
                    max: 1.6,
                    divisions: 5,
                    activeColor: WaznColors.oasis,
                    onChanged: (v) {
                      state.updateSettings(
                          state.settings.copyWith(fontScale: v));
                    },
                  ),
                ),
                const Text('أ',
                    style:
                        TextStyle(fontFamily: WaznFonts.quran, fontSize: 28)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSheet(BuildContext context, AppState state) {
    const themes = [('paper', 'ورقي'), ('sepia', 'رملي'), ('night', 'ليلي')];
    showModalBottomSheet(
      context: context,
      backgroundColor: WaznColors.sand,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مظهر المصحف',
              style: TextStyle(
                fontFamily: WaznFonts.ui,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: themes
                  .map((t) => Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ChoiceChip(
                          label: Text(t.$2),
                          selected: state.settings.mushafTheme == t.$1,
                          onSelected: (_) {
                            state.updateSettings(
                                state.settings.copyWith(mushafTheme: t.$1));
                            Navigator.pop(context);
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
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
