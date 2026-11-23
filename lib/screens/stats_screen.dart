import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../widgets/wazn_cards.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final week = state.weekReading;
    final max = week.fold<int>(1, (a, b) => a > b ? a : b);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('إحصاءاتك', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          WaznCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('دقائق القراءة خلال آخر ٧ أيام'),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    7,
                    (i) => Expanded(
                      child: Column(
                        children: [
                          Text('${week[i]}'),
                          Container(
                            height: 90 * week[i] / max + 1,
                            width: 20,
                            color: const Color(0xFF1F6B5C),
                          ),
                          Text(
                            '${DateTime.now().subtract(Duration(days: 6 - i)).day}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          WaznCard(
            child: Text(
              'رصيد مكتسب وإضافات هذا الأسبوع: ${state.weekEarnedMinutes} دقيقة\nليس تقديراً للوقت المستعاد من التطبيقات.',
            ),
          ),
          const SizedBox(height: 12),
          WaznCard(
            child: Text(
              'السلسلة الحالية: ${state.streak} أيام\nأطول سلسلة: ${state.longestStreak} أيام\nالقراءة اليوم: ${state.readingMinutesToday} دقيقة\nجلسات الأذكار المكتملة اليوم: ${state.completedAdhkarSessions}',
            ),
          ),
          const SizedBox(height: 16),
          const Text('خواطرك المحفوظة على هذا الجهاز'),
          if (state.notes.isEmpty) const Text('لم تحفظ خاطرة بعد.'),
          ...state.notes.reversed.map(
            (note) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: WaznCard(
                child: Text('${note['at']}\n${note['tag']}\n${note['text']}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
