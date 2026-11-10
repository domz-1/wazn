import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

class WaznBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const WaznBottomNav({super.key, required this.index, required this.onTap});

  static const items = [
    (Icons.home_outlined, 'الرئيسية'),
    (Icons.menu_book_outlined, 'العبادة'),
    (Icons.bar_chart_rounded, 'إحصاءات'),
    (Icons.tune_rounded, 'الإعدادات'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: WaznColors.white,
        border: Border(top: BorderSide(color: WaznColors.sandLine)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final active = i == index;
            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(items[i].$1,
                      size: 22,
                      color: active ? WaznColors.oasis : WaznColors.inkMuted),
                  const SizedBox(height: 4),
                  Text(items[i].$2,
                      style: TextStyle(
                          fontFamily: WaznFonts.ui,
                          fontSize: 12,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color:
                              active ? WaznColors.oasis : WaznColors.inkMuted)),
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}
