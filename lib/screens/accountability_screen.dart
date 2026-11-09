import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';

class AccountabilityScreen extends StatelessWidget {
  const AccountabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: const Text('شريك المساءلة')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Text('اختر صديقاً يشجّعك على الاستمرار.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, height: 1.6)),
          const SizedBox(height: 4),
          const Text('يرى سلسلتك فقط، ولا يرى ما تتصفحه ولا وقتك.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.inkMuted, height: 1.6)),
          const SizedBox(height: 18),
          WaznCard(
            child: Column(children: const [
              Icon(Icons.people_outline_rounded, size: 40, color: WaznColors.inkMuted),
              SizedBox(height: 10),
              Text('لم تضف شريكاً بعد', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.link_rounded),
            label: const Text('أرسل له دعوة برابط'),
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), foregroundColor: WaznColors.emerald, side: const BorderSide(color: WaznColors.sandLine), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 20),
          const SectionTitle('ما الذي يراه شريكك؟'),
          WaznCard(
            child: Column(children: const [
              _row(Icons.check_circle_outline, 'سلسلة الأيام', true),
              Divider(),
              _row(Icons.check_circle_outline, 'إتمام الورد اليومي', true),
              Divider(),
              _row(Icons.cancel_outlined, 'وقت التصفح والتطبيقات لا يُشارك أبداً', false),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('يمكنك إيقاف المشاركة أو إزالة الشريك في أي وقت.', style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 12, color: WaznColors.inkMuted)),
        ],
      ),
    );
  }
}

class _row extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool ok;
  const _row(this.icon, this.text, this.ok);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Icon(icon, size: 18, color: ok ? WaznColors.oasis : WaznColors.inkMuted),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 14))),
    ]),
  );
}
