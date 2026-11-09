import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

/// بطاقة بيضاء بحدود رملية ناعمة.
class WaznCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  const WaznCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.color, this.gradient, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? WaznColors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(WaznRadii.tile),
        border: gradient == null ? Border.all(color: WaznColors.sandLine) : null,
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(WaznRadii.tile), onTap: onTap, child: content));
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final String? trailing;
  final VoidCallback? onTrailing;
  const SectionTitle(this.text, {super.key, this.trailing, this.onTrailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 17, fontWeight: FontWeight.w700, color: WaznColors.ink)),
          if (trailing != null)
            TextButton(onPressed: onTrailing, child: Text(trailing!, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 13, color: WaznColors.oasis))),
        ],
      ),
    );
  }
}

class WaznChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bg;
  final Color fg;
  const WaznChip({super.key, required this.label, this.icon, this.bg = WaznColors.white, this.fg = WaznColors.ink});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(WaznRadii.chip), border: Border.all(color: WaznColors.sandLine)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 17, color: WaznColors.gold), const SizedBox(width: 6)],
        Text(label, style: TextStyle(fontFamily: WaznFonts.ui, fontSize: 14, fontWeight: FontWeight.w600, color: fg)),
      ]),
    );
  }
}

/// صفّ إعداد بزر تبديل أو سهم.
class SettingRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const SettingRow({super.key, required this.title, this.subtitle, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w600, color: WaznColors.ink)),
              if (subtitle != null) Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle!, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 12.5, color: WaznColors.inkMuted, height: 1.5)),
              ),
            ]),
          ),
          if (trailing != null) trailing!,
        ]),
      ),
    );
  }
}
