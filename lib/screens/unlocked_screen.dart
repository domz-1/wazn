import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_buttons.dart';
import '../widgets/wazn_cards.dart';

class UnlockedScreen extends StatelessWidget {
  const UnlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: WaznColors.sand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: WaznColors.goldBtnGradient)),
                child: const Icon(Icons.check_rounded, size: 64, color: Color(0xFF1A1405)),
              ),
              const SizedBox(height: 22),
              const Text('تقبّل الله منك', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 28, fontWeight: FontWeight.w700, color: WaznColors.emerald)),
              const SizedBox(height: 8),
              const Text('اكتمل وردك، وفُكّ القفل عن تطبيقاتك.', textAlign: TextAlign.center, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, color: WaznColors.inkMuted)),
              const SizedBox(height: 24),
              WaznCard(
                child: Column(children: [
                  const Text('رصيدك الجديد', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.inkMuted)),
                  const SizedBox(height: 6),
                  Text('${state.browseLeftMinutes} دقيقة تصفح', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 24, fontWeight: FontWeight.w700, color: WaznColors.oasis)),
                  const SizedBox(height: 4),
                  Text('${state.settings.readingMinutes} دقائق قراءة × ${state.settings.browseRatio}', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
                ]),
              ),
              const SizedBox(height: 14),
              WaznCard(
                child: Column(children: [
                  _row('إنستغرام', 'مفتوح'),
                  const Divider(),
                  _row('تيك توك', 'مفتوح'),
                  const Divider(),
                  _row('فيسبوك', 'مفتوح'),
                ]),
              ),
              const SizedBox(height: 16),
              Text('${state.streak} أيام متتالية — واصل', style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w700, color: WaznColors.goldOld)),
              const Spacer(),
              EmeraldButton(label: 'متابعة التصفح', onTap: () => Navigator.pop(context)),
              const SizedBox(height: 10),
              SoftButton(label: 'أكمل القراءة', icon: Icons.menu_book_outlined, onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14)),
      Text(v, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w700, color: WaznColors.oasis)),
    ]),
  );
}
