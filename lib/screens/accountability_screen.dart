import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';

/// Manual, user-reviewed sharing. No account, invitation URL or remote tracking.
class AccountabilityScreen extends StatelessWidget {
  const AccountabilityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final text = 'سلسلتي في وزن: ${state.streak} أيام. شجعني على الاستمرار.';
    return Scaffold(
      appBar: AppBar(title: const Text('شارك تقدمك')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'المشاركة مع شريك تلقائياً غير متاحة بعد. يمكنك نسخ هذا الملخص وإرساله بنفسك. لا يتضمن وقت التصفح أو التطبيقات.',
            ),
            const SizedBox(height: 20),
            SelectableText(text),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('انسخ ملخص السلسلة'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (context.mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم النسخ. اختر بنفسك من ترسل له.'),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
