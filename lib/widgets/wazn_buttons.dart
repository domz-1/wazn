import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

class EmeraldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const EmeraldButton({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: WaznColors.emerald,
        foregroundColor: WaznColors.sand,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WaznRadii.button)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        Text(label, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 18, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const GoldButton({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WaznRadii.button),
        gradient: const LinearGradient(colors: WaznColors.goldBtnGradient),
      ),
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: const Color(0xFF1A1405),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WaznRadii.button)),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Text(label, style: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }
}

class SoftButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  const SoftButton({super.key, required this.label, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: WaznColors.emerald,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: WaznColors.sandLine),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WaznRadii.button)),
        textStyle: const TextStyle(fontFamily: WaznFonts.ui, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}
