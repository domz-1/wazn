import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import 'accountability_screen.dart';
import 'permission_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final s = state.settings;
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [WaznColors.sand, WaznColors.sandDeep])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          children: [
            const Text('الإعدادات', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 26, fontWeight: FontWeight.w700, color: WaznColors.ink)),
            const SizedBox(height: 16),
            const SectionTitle('القفل'),
            _group([
              SettingRow(title: 'التطبيقات المقيّد', subtitle: '${s.restrictedApps.length} تطبيقات'),
              const Divider(height: 1),
              SettingRow(title: 'الحد اليومي', trailing: Text('${s.dailyLimitMinutes} دقيقة', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'تنبيه قبل الحظر', trailing: Text('قبل ${s.alertBeforeMinutes} دقائق', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'التأجيل', subtitle: 'مرة واحدة يومياً في الوضع اللطيف', trailing: Text('${s.snoozeMinutes} دقائق', style: _val)),
              const Divider(height: 1),
              SettingRow(
                title: 'وضع الحظر',
                subtitle: s.blockMode == 'gentle' ? 'اللطيف يذكّرك ويتيح لك تأجيلاً واحداً.' : 'الصارم يقفل التطبيق حتى تقرأ وردك.',
                trailing: SegmentedButton<String>(
                  segments: const [ButtonSegment(value: 'gentle', label: Text('لطيف')), ButtonSegment(value: 'strict', label: Text('صارم'))],
                  selected: {s.blockMode},
                  onSelectionChanged: (v) => state.updateSettings(s.copyWith(blockMode: v.first)),
                ),
              ),
            ]),
            const SizedBox(height: 18),
            const SectionTitle('الورد'),
            _group([
              SettingRow(title: 'مصدر المصحف', trailing: Text(s.mushafSource == 'builtin' ? 'المصحف المدمج' : 'تطبيق خارجي', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'مدة الورد', trailing: Text('${s.readingMinutes} دقائق', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'رصيد التصفح', trailing: Text('١ دقيقة = ${s.browseRatio} دقائق', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'خطة الختمة', trailing: Text('${s.khatmaPagesPerDay} صفحات يومياً', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'الاستماع بدلاً من القراءة', trailing: Switch(value: false, onChanged: (_) {})),
              const Divider(height: 1),
              SettingRow(title: 'مظهر المصحف', trailing: Text(s.mushafTheme == 'paper' ? 'ورقي' : s.mushafTheme, style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'حجم الخط', trailing: Text('متوسط', style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'التفسير عند الضغط على الآية', subtitle: 'اختياري، يظهر عند طلبك فقط'),
              const Divider(height: 1),
              SettingRow(title: 'مصدر التفسير', trailing: Text(s.tafsirSource == 'muyassar' ? 'التفسير الميسر' : s.tafsirSource, style: _val)),
            ]),
            const SizedBox(height: 18),
            const SectionTitle('الأذكار'),
            _group([
              SettingRow(title: 'أذكار الصباح', trailing: Text(s.morningAdhkarTime, style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'أذكار المساء', trailing: Text(s.eveningAdhkarTime, style: _val)),
              const Divider(height: 1),
              SettingRow(title: 'حديث اليوم', subtitle: 'يظهر في الرئيسية'),
            ]),
            const SizedBox(height: 18),
            const SectionTitle('السلسلة'),
            _group([
              SettingRow(title: 'يوم راحة أسبوعياً', subtitle: 'لا يكسر السلسلة', trailing: Switch(value: s.restDayEnabled, onChanged: (v) => state.updateSettings(s.copyWith(restDayEnabled: v)))),
            ]),
            const SizedBox(height: 18),
            const SectionTitle('الأذونات'),
            _group([
              SettingRow(title: 'إحصاءات الاستخدام', subtitle: 'أندرويد', trailing: const _Status(enabled: true)),
              const Divider(height: 1),
              SettingRow(title: 'العرض فوق التطبيقات', subtitle: 'أندرويد', trailing: const _Status(enabled: true)),
              const Divider(height: 1),
              SettingRow(title: 'وقت الشاشة', subtitle: 'آيفون', trailing: const _Status(enabled: true)),
            ]),
            const SizedBox(height: 8),
            const Text('تظهر الأذونات المناسبة لنظام جهازك فقط.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
            const SizedBox(height: 18),
            _group([
              SettingRow(title: 'شريك المساءلة', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AccountabilityScreen()))),
              const Divider(height: 1),
              SettingRow(title: 'حالة الإذن', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PermissionScreen()))),
            ]),
          ],
        ),
      ),
    );
  }

  static const _val = TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, fontWeight: FontWeight.w600, color: WaznColors.oasis);

  Widget _group(List<Widget> children) => Container(
    decoration: BoxDecoration(color: WaznColors.white, borderRadius: BorderRadius.circular(WaznRadii.tile), border: Border.all(color: WaznColors.sandLine)),
    child: Column(children: children),
  );
}

class _Status extends StatelessWidget {
  final bool enabled;
  const _Status({required this.enabled});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? WaznColors.oasis : WaznColors.goldOld)),
    const SizedBox(width: 6),
    Text(enabled ? 'مفعّل' : 'غير مفعّل', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.oasis)),
  ]);
}
