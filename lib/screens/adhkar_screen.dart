import 'package:flutter/material.dart';
import '../data/seed_adhkar.dart';
import '../models/dhikr.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/wazn_cards.dart';
import 'dhikr_counter_screen.dart';

class AdhkarScreen extends StatefulWidget {
  final bool morning;
  const AdhkarScreen({super.key, this.morning = true});
  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  late AdhkarSession _session =
      widget.morning ? SeedAdhkar.morning : SeedAdhkar.evening;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(title: Text(_session.title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            ChoiceChip(
                label: const Text('الصباح'),
                selected: widget.morning,
                onSelected: (_) =>
                    setState(() => _session = SeedAdhkar.morning)),
            const SizedBox(width: 8),
            ChoiceChip(
                label: const Text('المساء'),
                selected: !widget.morning,
                onSelected: (_) =>
                    setState(() => _session = SeedAdhkar.evening)),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: _session.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final d = _session.items[i];
              return WaznCard(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        DhikrCounterScreen(dhikr: d, session: _session))),
                child: Row(children: [
                  Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: WaznColors.sandWarm),
                      alignment: Alignment.center,
                      child: Text('${i + 1}',
                          style: const TextStyle(
                              fontFamily: WaznFonts.ui,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: WaznColors.oasis))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(d.text,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: WaznFonts.quran,
                              fontSize: 17,
                              height: 1.7,
                              color: WaznColors.ink))),
                  const SizedBox(width: 8),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: WaznColors.sandWarm,
                          borderRadius: BorderRadius.circular(999)),
                      child: Text('×${d.count}',
                          style: const TextStyle(
                              fontFamily: WaznFonts.ui,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: WaznColors.oasis))),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
