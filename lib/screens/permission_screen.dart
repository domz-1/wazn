import 'package:flutter/material.dart';
import '../services/native_app_service.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_buttons.dart';
import '../widgets/wazn_cards.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('الإذن غير مفعّل')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: WaznColors.sandWarm,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الإذن غير مفعّل',
                  style: TextStyle(
                    fontFamily: WaznFonts.ui,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'بدونه لا نستطيع حساب وقتك، فتوقف الحظر مؤقتاً. تفعيله يستغرق نصف دقيقة.',
                  style: TextStyle(
                      fontFamily: WaznFonts.ui, fontSize: 14, height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _step('١', 'افتح إعدادات الجهاز بالضغط على الزر أدناه'),
          _step('٢', 'ادخل إلى «وقت الشاشة» أو «إحصاءات الاستخدام»'),
          _step('٣', 'فعّل إذن الوصول لتطبيق وزن'),
          const SizedBox(height: 14),
          const WaznCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.menu_book_outlined, color: WaznColors.oasis),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'المصحف والأذكار والتفسير تعمل كلها بلا إنترنت، ولا يتأثر وردك اليوم.',
                    style: TextStyle(
                        fontFamily: WaznFonts.ui, fontSize: 13, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          EmeraldButton(
            label: 'افتح الإعدادات الآن',
            icon: Icons.settings_outlined,
            onTap: () => NativeAppService.instance.openUsageSettings(),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'لاحقاً',
              style: TextStyle(
                  fontFamily: WaznFonts.ui, color: WaznColors.inkMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _step(String n, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: WaznColors.emerald,
              ),
              alignment: Alignment.center,
              child: Text(
                n,
                style: const TextStyle(
                  fontFamily: WaznFonts.ui,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: WaznColors.sand,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    fontFamily: WaznFonts.ui, fontSize: 14.5, height: 1.5),
              ),
            ),
          ],
        ),
      );
}
